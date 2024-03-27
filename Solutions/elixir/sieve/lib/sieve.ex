defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    if limit < 2,
      do: [],
      else:
        2..limit
        |> Enum.to_list()
        |> sieve
  end

  defp sieve([]), do: []

  defp sieve([p | rest]) do
    [p | sieve(Enum.filter(rest, fn x -> rem(x, p) != 0 end))]
  end
end
