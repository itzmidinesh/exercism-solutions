defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(1), do: []
  def factors_for(number), do: find_factors(number, 2, [])

  defp find_factors(1, _divisor, factors), do: Enum.reverse(factors)

  defp find_factors(number, divisor, factors) when divisor * divisor > number,
    do: Enum.reverse([number | factors])

  defp find_factors(number, divisor, factors) when rem(number, divisor) == 0,
    do: find_factors(div(number, divisor), divisor, [divisor | factors])

  defp find_factors(number, divisor, factors),
    do: find_factors(number, next_divisor(divisor), factors)

  defp next_divisor(divisor) when divisor == 2, do: 3
  defp next_divisor(divisor), do: divisor + 2
end
