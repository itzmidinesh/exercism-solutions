defmodule Prime do
  @doc """
  Generates the nth prime using the Sieve of Eratosthenes algorithm.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise "there is no zeroth prime"
  def nth(1), do: 2
  def nth(n) do
    primes = sieve(150_000)  # Generate a list of prime numbers up to an arbitrary limit
    Enum.at(primes, -n)  # Get the nth prime number from the list
  end

  defp sieve(limit) do
    sieve(Enum.to_list(2..limit), [])
  end

  defp sieve([], primes), do: primes
  defp sieve([p | rest], primes) do
    primes = [p | primes]
    sieve(Enum.filter(rest, fn x -> rem(x, p) != 0 end), primes)
  end
end
