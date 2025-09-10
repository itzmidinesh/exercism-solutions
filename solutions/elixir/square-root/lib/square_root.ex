defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand), do: binary_search(radicand, 0, radicand)

  defp binary_search(radicand, low, high) when low <= high do
    mid = div(low + high, 2)
    square = mid * mid

    cond do
      square == radicand -> mid
      square < radicand -> binary_search(radicand, mid + 1, high)
      square > radicand -> binary_search(radicand, low, mid - 1)
    end
  end
end
