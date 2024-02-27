defmodule ExBanking.Currency do
  @moduledoc """
  Its not a good idea to use floats for currency/money amounts.
  [Why?](https://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency)
  """
  @type t :: %__MODULE__{
          code: String.t(),
          fractions: pos_integer(),
          subunits: pos_integer(),
          symbol: String.t(),
          units: integer()
        }
  defstruct [
    :code,
    :fractions,
    :subunits,
    :symbol,
    :units
  ]

  @doc """
  Construct a new `ExBanking.Currency` struct from specified currency label.
  An initial non-negative amount can also be specified along with options:
  `:fractions`, `:subunits` and `:symbol` to override the defaults.
  """
  @spec new(currency :: String.t(), amount :: number(), options :: Keyword.t()) ::
          {:error, :wrong_arguments} | {:ok, ExBanking.Currency.t()}
  def new(currency, amount \\ 0.0, options \\ [])

  def new(currency, amount, options)
      when is_binary(currency) and currency != "" and is_number(amount) and amount >= 0 do
    defaults = [fractions: 10000, subunits: 100, symbol: ""]
    init = Keyword.merge(defaults, options)

    checks =
      is_integer(Keyword.get(init, :fractions)) and Keyword.get(init, :fractions) > 0 and
        is_integer(Keyword.get(init, :subunits)) and Keyword.get(init, :subunits) > 0 and
        is_binary(Keyword.get(init, :symbol))

    if checks do
      {:ok,
       %__MODULE__{
         code: currency,
         fractions: Keyword.get(init, :fractions),
         subunits: Keyword.get(init, :subunits),
         symbol: Keyword.get(init, :symbol),
         units:
           (amount * Keyword.get(init, :subunits) * Keyword.get(init, :fractions))
           |> Kernel.trunc()
       }}
    else
      {:error, :wrong_arguments}
    end
  end

  def new(_, _, _), do: {:error, :wrong_arguments}

  @doc """
  Construct `ExBanking.Currency` struct from a real-world euro value.
  """
  @spec euro(amount :: number()) :: {:error, :wrong_arguments} | {:ok, ExBanking.Currency.t()}
  def euro(amount) do
    new("EUR", amount, symbol: "€")
  end

  @doc """
  Construct `ExBanking.Currency` struct from a real-world US dollar value.
  """
  @spec usd(amount :: number()) :: {:error, :wrong_arguments} | {:ok, ExBanking.Currency.t()}
  def usd(amount) do
    new("USD", amount, symbol: "$")
  end

  @doc """
  Addition for currencies of the same type.
  """
  @spec add(
          a :: {:ok, ExBanking.Currency.t()} | ExBanking.Currency.t(),
          b :: {:ok, ExBanking.Currency.t()} | ExBanking.Currency.t()
        ) :: {:error, :wrong_arguments} | {:ok, ExBanking.Currency.t()}
  def add({:ok, %ExBanking.Currency{} = a}, {:ok, %ExBanking.Currency{} = b}), do: add(a, b)
  def add(%ExBanking.Currency{} = a, {:ok, %ExBanking.Currency{} = b}), do: add(a, b)
  def add({:ok, %ExBanking.Currency{} = a}, %ExBanking.Currency{} = b), do: add(a, b)

  def add(%ExBanking.Currency{} = a, %ExBanking.Currency{} = b), do: op(a, b, &Kernel.+/2)

  def add(_, _), do: {:error, :wrong_arguments}

  @doc """
  Subtraction for currencies of the same type.
  """
  @spec subtract(
          a :: {:ok, ExBanking.Currency.t()} | ExBanking.Currency.t(),
          b :: {:ok, ExBanking.Currency.t()} | ExBanking.Currency.t()
        ) :: {:error, :wrong_arguments} | {:ok, ExBanking.Currency.t()}
  def subtract({:ok, %ExBanking.Currency{} = a}, {:ok, %ExBanking.Currency{} = b}),
    do: subtract(a, b)

  def subtract(%ExBanking.Currency{} = a, {:ok, %ExBanking.Currency{} = b}),
    do: subtract(a, b)

  def subtract({:ok, %ExBanking.Currency{} = a}, %ExBanking.Currency{} = b),
    do: subtract(a, b)

  def subtract(%ExBanking.Currency{} = a, %ExBanking.Currency{} = b), do: op(a, b, &Kernel.-/2)

  def subtract(_, _), do: {:error, :wrong_arguments}

  @spec op(
          a :: ExBanking.Currency.t(),
          b :: ExBanking.Currency.t(),
          op_f :: (number(), number() -> number())
        ) :: {:error, :wrong_arguments} | {:ok, ExBanking.Currency.t()}
  defp op(
         %ExBanking.Currency{code: code_a, units: units_a} = a,
         %ExBanking.Currency{
           code: code_b,
           units: units_b
         },
         op_f
       )
       when is_binary(code_a) and code_a === code_b and code_a !== "" and
              is_integer(units_a) and is_integer(units_b) do
    {:ok,
     %__MODULE__{
       code: code_a,
       fractions: a.fractions,
       subunits: a.subunits,
       symbol: a.symbol,
       units: op_f.(units_a, units_b)
     }}
  end

  defp op(_, _, _), do: {:error, :wrong_arguments}

  @doc """
  Compare `ExBanking.Currency' instances, incompatible or invalid instance will raise `ArgumentError`.
  """
  @spec is_equal_or_greater!(
          {:ok, ExBanking.Currency.t()} | ExBanking.Currency.t(),
          {:ok, ExBanking.Currency.t()} | ExBanking.Currency.t()
        ) :: boolean
  def is_equal_or_greater!({:ok, %ExBanking.Currency{} = a}, {:ok, %ExBanking.Currency{} = b}),
    do: is_equal_or_greater!(a, b)

  def is_equal_or_greater!(%ExBanking.Currency{} = a, {:ok, %ExBanking.Currency{} = b}),
    do: is_equal_or_greater!(a, b)

  def is_equal_or_greater!({:ok, %ExBanking.Currency{} = a}, %ExBanking.Currency{} = b),
    do: is_equal_or_greater!(a, b)

  def is_equal_or_greater!(
        %ExBanking.Currency{code: ca, units: ua} = a,
        %ExBanking.Currency{code: cb, units: ub} = b
      )
      when is_binary(ca) and ca === cb and is_integer(ua) and is_integer(ub),
      do: cmp?(a, b, &Kernel.>=/2)

  def is_equal_or_greater!(_, _) do
    raise ArgumentError, message: "Invalid `ExBanking.Currency` struct(s)."
  end

  @spec cmp?(
          a :: ExBanking.Currency.t(),
          b :: ExBanking.Currency.t(),
          op_f :: (number(), number() -> boolean())
        ) :: boolean()
  defp cmp?(%ExBanking.Currency{} = a, %ExBanking.Currency{} = b, op_f), do: op_f.(a, b)

  @doc """
  Convert a `ExBanking.Currency` struct to float.
  """
  @spec to_float(ExBanking.Currency.t()) :: {:error, :wrong_arguments} | {:ok, float()}
  def to_float({:ok, %ExBanking.Currency{} = c}), do: to_float(c)

  def to_float(%ExBanking.Currency{fractions: fractions, subunits: subunits, units: units})
      when is_integer(fractions) and fractions > 0 and is_integer(subunits) and subunits > 0 and
             is_integer(units) do
    {:ok, Kernel.round(units / fractions) / subunits}
  end

  def to_float(_), do: {:error, :wrong_arguments}
end
