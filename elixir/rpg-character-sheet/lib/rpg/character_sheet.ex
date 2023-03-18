defmodule RPG.CharacterSheet do
  def welcome() do
    IO.puts("Welcome! Let's fill out your character sheet together.")
  end

  def ask_name() do
    case IO.gets("What is your character's name?\n") do
      {:error, _} -> ""
      answer -> answer |> String.trim()
    end
  end

  def ask_class() do
    case IO.gets("What is your character's class?\n") do
      {:error, _} -> ""
      answer -> answer |> String.trim()
    end
  end

  def ask_level() do
    case IO.gets("What is your character's level?\n") do
      {:error, _} ->
        0

      input ->
        case String.trim(input) |> Integer.parse() do
          :error -> 0
          {level, _} -> level
        end
    end
  end

  def run() do
    welcome()

    %{
      name: ask_name(),
      class: ask_class(),
      level: ask_level()
    }
    |> IO.inspect(label: "Your character")
  end
end
