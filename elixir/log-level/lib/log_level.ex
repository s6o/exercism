defmodule LogLevel do
  @levels %{
    # Current
    false => %{
      0 => :trace,
      1 => :debug,
      2 => :info,
      3 => :warning,
      4 => :error,
      5 => :fatal
    },
    # Legacy
    true => %{
      1 => :debug,
      2 => :info,
      3 => :warning,
      4 => :error
    }
  }

  @alerts %{
    {false, :error} => :ops,
    {true, :error} => :ops,
    {false, :fatal} => :ops,
    {true, :fatal} => :ops,
    {true, :unknown} => :dev1,
    {false, :unknown} => :dev2
  }

  def to_label(level, legacy?) do
    @levels |> Map.get(legacy?, :unknown) |> Map.get(level, :unknown)
  end

  def alert_recipient(level, legacy?) do
    key = to_label(level, legacy?) |> (fn l -> {legacy?, l} end).()
    Map.get(@alerts, key, false)
  end
end
