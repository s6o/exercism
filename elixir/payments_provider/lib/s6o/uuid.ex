defmodule S6o.Uuid do
  @moduledoc """
  Generate a UUID on a supported OS: MacOS or Linux via respective command line
  utilities. On MacOS `uuidgen` is available. On Linux `cat` and the kernel do
  the job.
  """

  @spec new!() :: String.t()
  def new!() do
    {result, exit_status} =
      case :os.type() do
        {:unix, :darwin} -> System.cmd("uuidgen", [])
        {:unix, :linux} -> System.cmd("cat", ["/proc/sys/kernel/random/uuid"])
        _ -> {nil, 0}
      end

    if is_nil(result) do
      raise(ArgumentError, "Unsupported operating system: #{:os.type()}")
    else
      if exit_status == 0 do
        result
        |> String.trim()
        |> String.downcase()
      else
        raise(RuntimeError, "Missing utility ?! Error: #{result}")
      end
    end
  end
end
