defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []
  """
  @spec flatten(list) :: list
  def flatten(list), do: _flatten(list, [], [])

  defp _flatten(list, accum, stack) do
    case list do
      [] ->
        case stack do
          [] -> accum
          [s | sr] -> _flatten(s, accum, sr)
        end

      [x | rest] when not is_list(x) and not is_nil(x) ->
        _flatten(rest, accum ++ [x], stack)

      [x | rest] when not is_list(x) and is_nil(x) ->
        _flatten(rest, accum, stack)

      [x | rest] when is_list(x) ->
        _flatten(x, accum, [rest | stack])
    end
  end
end
