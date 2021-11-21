defmodule HighScore do
  @init 0

  def new() do
    %{}
  end

  def add_player(scores, name, score \\ @init) do
    scores |> Map.put(name, score)
  end

  def remove_player(scores, name) do
    scores |> Map.delete(name)
  end

  def reset_score(scores, name) do
    scores |> Map.put(name, @init)
  end

  def update_score(scores, name, score) do
    Map.update(scores, name, score, fn s -> s + score end)
  end

  def get_players(scores) do
    scores |> Map.keys()
  end
end
