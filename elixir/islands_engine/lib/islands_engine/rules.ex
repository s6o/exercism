defmodule IslandsEngine.Rules do
  @type t :: %__MODULE__{
          :state => :initialized | :players_set | :player1_turn | :player2_turn | :game_over,
          :player1 => player_state(),
          :player2 => player_state()
        }
  @type event ::
          :add_player
          | {:position_islands, event_player()}
          | {:set_islands, event_player()}
          | {:guess_coordinate, event_player()}
          | {:win_check, :no_win | :win}
  @type event_player :: :player1 | :player2
  @type player_state :: :islands_not_set | :islands_set | :no_win | :win

  defstruct [:state, :player1, :player2]

  alias __MODULE__

  def new(),
    do: %Rules{state: :initialized, player1: :islands_not_set, player2: :islands_not_set}

  def check(%Rules{state: :initialized} = rules, :add_player),
    do: {:ok, %Rules{rules | state: :players_set}}

  def check(%Rules{state: :players_set} = rules, {:position_islands, player}) do
    case Map.fetch!(rules, player) do
      :islands_set -> :error
      :islands_not_set -> {:ok, rules}
    end
  end

  def check(%Rules{state: :players_set} = rules, {:set_islands, player}) do
    rules = Map.put(rules, player, :islands_set)

    case both_players_islands_set?(rules) do
      false -> {:ok, rules}
      true -> {:ok, %Rules{rules | state: :player1_turn}}
    end
  end

  def check(%Rules{state: :player1_turn} = rules, {:guess_coordinate, :player1}),
    do: {:ok, %Rules{rules | state: :player2_turn}}

  def check(%Rules{state: :player2_turn} = rules, {:guess_coordinate, :player2}),
    do: {:ok, %Rules{rules | state: :player1_turn}}

  def check(%Rules{state: :player1_turn} = rules, {:win_check, win_or_not}) do
    case win_or_not do
      :no_win -> {:ok, rules}
      :win -> {:ok, %Rules{rules | state: :game_over, player1: :win, player2: :no_win}}
    end
  end

  def check(%Rules{state: :player2_turn} = rules, {:win_check, win_or_not}) do
    case win_or_not do
      :no_win -> {:ok, rules}
      :win -> {:ok, %Rules{rules | state: :game_over, player1: :no_win, player2: :win}}
    end
  end

  def check(_state, _event), do: :error

  defp both_players_islands_set?(rules),
    do: rules.player1 == :islands_set && rules.player2 == :islands_set
end
