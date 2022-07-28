defmodule Tree do
  @type t :: %__MODULE__{
          value: any(),
          children: [t()]
        }

  defstruct value: nil, children: []

  defimpl Functor do
    @spec fmap(fa :: Tree.t(), (va :: any() -> vb :: any())) :: Tree.t()
    def fmap(fa, f) do
      case fa do
        %Tree{value: v, children: []} ->
          %Tree{value: f.(v), children: []}

        %Tree{value: v, children: cs} ->
          fcs = Functor.fmap(cs, fn x -> fmap(x, f) end)
          %Tree{value: f.(v), children: fcs}
      end
    end
  end
end
