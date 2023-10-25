defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(markdown :: String.t()) :: String.t()
  def parse(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.map_join(&process/1)
    |> format_emphasis_and_lists()
  end

  defp process(token) do
    case String.slice(token, 0..0) do
      "#" ->
        token |> process_header()

      "*" ->
        token |> process_list_items()

      _ ->
        token |> process_paragraph()
    end
  end

  defp process_header(token) do
    [hashes | words] = token |> String.split()
    header_size = hashes |> String.length()

    if header_size < 7 do
      title = words |> Enum.join(" ")
      "<h#{header_size}>" <> title <> "</h#{header_size}>"
    else
      "<p>#{token}</p>"
    end
  end

  defp process_list_items(token) do
    token
    |> String.trim_leading("* ")
    |> (fn s -> "<li>#{s}</li>" end).()
  end

  defp process_paragraph(token) do
    token
    |> (fn s -> "<p>#{s}</p>" end).()
  end

  defp format_emphasis_and_lists(token) do
    token
    |> String.replace(~r/__(.*)__/, "<strong>\\1</strong>")
    |> String.replace(~r/_(.*)_/, "<em>\\1</em>")
    |> String.replace(~r/<li>.*<\/li>/, "<ul>\\0</ul>")
  end
end
