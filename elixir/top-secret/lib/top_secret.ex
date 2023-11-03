defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part(ast, acc) do
    {ast,
     case ast do
       {:def, _, [{_fname, _, []} | _]} ->
         ["" | acc]

       {:defp, _, [{_fname, _, []} | _]} ->
         ["" | acc]

       {:def, _, [{_fname, _, nil} | _]} ->
         ["" | acc]

       {:defp, _, [{_fname, _, nil} | _]} ->
         ["" | acc]

       {:def, _, [{:when, _, [{fname, _, args} | _]} | _]} ->
         [Atom.to_string(fname) |> String.slice(0, Enum.count(args)) | acc]

       {:defp, _, [{:when, _, [{fname, _, args} | _]} | _]} ->
         [Atom.to_string(fname) |> String.slice(0, Enum.count(args)) | acc]

       {:def, _, [{fname, _, args} | _]} ->
         [Atom.to_string(fname) |> String.slice(0, Enum.count(args)) | acc]

       {:defp, _, [{fname, _, args} | _]} ->
         [Atom.to_string(fname) |> String.slice(0, Enum.count(args)) | acc]

       _ ->
         acc
     end}
  end

  def decode_secret_message(string) do
    {_, acc} = Macro.prewalk(to_ast(string), [], &decode_secret_message_part/2)
    acc |> Enum.reverse() |> Enum.join("")
  end
end
