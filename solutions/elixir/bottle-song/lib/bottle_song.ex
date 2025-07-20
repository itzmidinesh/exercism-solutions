defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) do
    start_bottle
    |> Stream.iterate(&(&1 - 1))
    |> Enum.take(take_down)
    |> Enum.map(&verse/1)
    |> Enum.join("\n\n")
  end

  defp verse(bottles) do
    current = number_word(bottles)
    next = number_word(bottles - 1)
    current_bottle = bottle_word(bottles)
    next_bottle = bottle_word(bottles - 1)

    """
    #{String.capitalize(current)} green #{current_bottle} hanging on the wall,
    #{String.capitalize(current)} green #{current_bottle} hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be #{next} green #{next_bottle} hanging on the wall.\
    """
  end

  defp number_word(0), do: "no"
  defp number_word(1), do: "one"
  defp number_word(2), do: "two"
  defp number_word(3), do: "three"
  defp number_word(4), do: "four"
  defp number_word(5), do: "five"
  defp number_word(6), do: "six"
  defp number_word(7), do: "seven"
  defp number_word(8), do: "eight"
  defp number_word(9), do: "nine"
  defp number_word(10), do: "ten"

  defp bottle_word(1), do: "bottle"
  defp bottle_word(_), do: "bottles"
end
