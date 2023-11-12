defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts :: opts()) :: {:ok, opts()} | {:error, error()}
  @callback handle_frame(dot :: dot(), frame_num :: frame_number(), opts()) :: dot()

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(%DancingDots.Dot{} = dot, frame_num, _opts) do
    if frame_num >= 1 and Kernel.rem(frame_num, 4) == 0 do
      %{dot | opacity: dot.opacity / 2}
    else
      dot
    end
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    if Keyword.has_key?(opts, :velocity) and Kernel.is_number(Keyword.get(opts, :velocity)) do
      {:ok, opts}
    else
      {:error,
       "The :velocity option is required, and its value must be a number. Got: #{
         inspect(Keyword.get(opts, :velocity))
       }"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(%DancingDots.Dot{} = dot, frame_num, velocity: velocity) do
    if frame_num >= 1 do
      %{dot | radius: dot.radius + (frame_num - 1) * velocity}
    else
      dot
    end
  end
end
