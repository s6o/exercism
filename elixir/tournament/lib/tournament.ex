defmodule Tournament do
  @type t :: %__MODULE__{
          team: String.t(),
          plays: non_neg_integer(),
          wins: non_neg_integer(),
          draws: non_neg_integer(),
          losses: non_neg_integer(),
          points: non_neg_integer()
        }
  defstruct [
    :team,
    :plays,
    :wins,
    :draws,
    :losses,
    :points
  ]

  @type resultset :: %{optional(String.t()) => Tournament.t()}

  @scoring %{
    "win" => 3,
    "draw" => 1,
    "loss" => 0
  }

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally([]), do: format_header() |> String.trim()

  def tally(input) do
    collect_results(input) |> format_results()
  end

  @spec collect_results(input :: list(String.t())) :: resultset()
  defp collect_results(input) do
    input |> Enum.reduce(%{}, &record_match/2)
  end

  @spec format_results(resultset :: resultset()) :: String.t()
  defp format_results(resultset) do
    format_header() <>
      (resultset
       |> Map.values()
       |> Enum.sort_by(fn t -> t.points end, &>=/2)
       |> Enum.map_join("\n", &format_row/1))
  end

  defp format_header, do: String.pad_trailing("Team", 31) <> "| MP |  W |  D |  L |  P\n"

  defp format_row(%Tournament{} = t) do
    (t.team |> String.pad_trailing(31)) <>
      "|" <>
      (t.plays |> Integer.to_string() |> String.pad_leading(3)) <>
      " |" <>
      (t.wins |> Integer.to_string() |> String.pad_leading(3)) <>
      " |" <>
      (t.draws |> Integer.to_string() |> String.pad_leading(3)) <>
      " |" <>
      (t.losses |> Integer.to_string() |> String.pad_leading(3)) <>
      " |" <> (t.points |> Integer.to_string() |> String.pad_leading(3))
  end

  defp record_match(record, resultset) do
    case record |> String.split(";") do
      [team_a, team_b, result] ->
        rs = resultset |> record_init(team_a) |> record_init(team_b)

        case result do
          "draw" ->
            rs |> record_draw(team_a) |> record_draw(team_b)

          "loss" ->
            rs |> record_loss(team_a) |> record_win(team_b)

          "win" ->
            rs |> record_win(team_a) |> record_loss(team_b)

          _ ->
            resultset
        end

      _ ->
        resultset
    end
  end

  defp record_win(resultset, team) do
    resultset
    |> Map.update!(team, fn t ->
      %Tournament{
        t
        | :plays => t.plays + 1,
          :wins => t.wins + 1,
          :points => t.points + @scoring["win"]
      }
    end)
  end

  defp record_draw(resultset, team) do
    resultset
    |> Map.update!(team, fn t ->
      %Tournament{
        t
        | :plays => t.plays + 1,
          :draws => t.draws + 1,
          :points => t.points + @scoring["draw"]
      }
    end)
  end

  defp record_loss(resultset, team) do
    resultset
    |> Map.update!(team, fn t ->
      %Tournament{
        t
        | :plays => t.plays + 1,
          :losses => t.losses + 1,
          :points => t.points + @scoring["loss"]
      }
    end)
  end

  defp record_init(resultset, team) do
    if Map.has_key?(resultset, team) do
      resultset
    else
      Map.put(resultset, team, %Tournament{
        :team => team,
        :plays => 0,
        :wins => 0,
        :draws => 0,
        :losses => 0,
        :points => 0
      })
    end
  end
end
