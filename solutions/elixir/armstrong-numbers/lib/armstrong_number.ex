defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits_len = number |> Integer.digits |> length
    number
    |> Integer.digits
    |> Enum.map(fn x -> x**digits_len end)
    |> Enum.sum == number
  end
end
