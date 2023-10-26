defmodule LogParser do
  def valid_line?(line) do
    Regex.match?(~r/^\[DEBUG|INFO|WARNING|WARN|ERROR\]/u, line)
  end

  def split_line(line) do
    String.split(line, ~r/\<[\-\*\~\=]*\>/u)
  end

  def remove_artifacts(line) do
    String.replace(line, ~r/end\-of\-line\d+/iu, "")
  end

  def tag_with_user_name(line) do
    String.replace(
      line,
      ~r/^(.+User[[:blank:]\n]+)([!\_\w\d[:graph:]]+)([[:blank:]\n]+.+$)?/iu,
      "[USER] \\2 \\1\\2\\3"
    )
  end
end
