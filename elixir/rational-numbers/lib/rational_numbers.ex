defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers.
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a1, b1}, {a2, b2}) do
    {a1 * b2 + a2 * b1, b1 * b2} |> RationalNumbers.reduce()
  end

  @doc """
  Subtract two rational numbers.
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({a1, b1}, {a2, b2}) do
    {a1 * b2 - a2 * b1, b1 * b2} |> RationalNumbers.reduce()
  end

  @doc """
  Multiply two rational numbers.
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a1, b1}, {a2, b2}) do
    {a1 * a2, b1 * b2} |> RationalNumbers.reduce()
  end

  @doc """
  Divide two rational numbers.
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({a1, b1}, {a2, b2}) do
    if a2 == 0 do
      raise(ArgumentError, message: "Incorrect `den` value: {#{a2}, #{b2}}")
    else
      {a1 * b2, a2 * b1} |> RationalNumbers.reduce()
    end
  end

  @doc """
  Absolute value of a rational number.
  """
  @spec abs(a :: rational) :: rational
  def abs({j, k}) do
    {Kernel.abs(j), Kernel.abs(k)} |> RationalNumbers.reduce()
  end

  @doc """
  Exponentiation of a rational number by an integer.
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({j, k}, n) do
    if n >= 0 do
      {pow(j, n), pow(k, n)}
    else
      {pow(k, Kernel.abs(n)), pow(j, Kernel.abs(n))}
    end
    |> RationalNumbers.reduce()
  end

  @doc """
  Exponentiation of a real number by a rational number.
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {a, b}) do
    nth_root(pow(x, a), b)
  end

  @doc """
  Reduce a rational number to its lowest terms.
  """
  @spec reduce(a :: rational) :: rational
  def reduce({j, k}) do
    d = Integer.gcd(Kernel.abs(j), Kernel.abs(k))

    {if(k < 0, do: -1 * div(j, d), else: div(j, d)),
     if(k < 0, do: -1 * div(k, d), else: div(k, d))}
  end

  # Integer.pow/2 exists only as of Elixir 1.12
  # https://hex.pm/packages/math
  defp pow(x, n)

  defp pow(x, n) when is_integer(x) and is_integer(n), do: _pow(x, n)

  # Float implementation. Uses erlang's math library.
  defp pow(x, n) do
    :math.pow(x, n)
  end

  # Integer implementation. Uses Exponentiation by Squaring.
  defp _pow(x, n, y \\ 1)
  defp _pow(_x, 0, y), do: y
  defp _pow(x, 1, y), do: x * y
  defp _pow(x, n, y) when n < 0, do: _pow(1 / x, -n, y)
  defp _pow(x, n, y) when rem(n, 2) == 0, do: _pow(x * x, div(n, 2), y)
  defp _pow(x, n, y), do: _pow(x * x, div(n - 1, 2), x * y)

  defp nth_root(x, n)
  defp nth_root(x, n), do: pow(x, 1 / n)
end
