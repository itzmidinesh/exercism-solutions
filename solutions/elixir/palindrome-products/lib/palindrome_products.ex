defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    validate_factors(max_factor, min_factor)

    min_factor..max_factor
    |> generate_palindrome_products(max_factor)
    |> group_by_product()
  end

  defp validate_factors(max_factor, min_factor) when max_factor < min_factor do
    raise ArgumentError, "max_factor must be >= min_factor"
  end

  defp validate_factors(_, _), do: :ok

  defp generate_palindrome_products(range, max_factor) do
    for a <- range,
        b <- a..max_factor,
        product = a * b,
        palindrome?(product),
        do: {product, [a, b]}
  end

  defp group_by_product(products) do
    Enum.group_by(products, &elem(&1, 0), &elem(&1, 1))
  end

  defp palindrome?(n) do
    n
    |> Integer.digits()
    |> then(&(&1 == Enum.reverse(&1)))
  end
end
