defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(category, dice) do
    case category do
      :ones -> sum_for_number(dice, 1)
      :twos -> sum_for_number(dice, 2)
      :threes -> sum_for_number(dice, 3)
      :fours -> sum_for_number(dice, 4)
      :fives -> sum_for_number(dice, 5)
      :sixes -> sum_for_number(dice, 6)
      :full_house -> full_house_score(dice)
      :four_of_a_kind -> four_of_a_kind_score(dice)
      :little_straight -> if Enum.sort(dice) == [1, 2, 3, 4, 5], do: 30, else: 0
      :big_straight -> if Enum.sort(dice) == [2, 3, 4, 5, 6], do: 30, else: 0
      :choice -> Enum.sum(dice)
      :yacht -> if Enum.uniq(dice) == [hd(dice)], do: 50, else: 0
    end
  end

  @doc false
  defp sum_for_number(dice, number) do
    dice
    |> Enum.filter(&(&1 == number))
    |> Enum.sum()
  end

  @doc false
  defp full_house_score(dice) do
    counts = dice |> Enum.frequencies() |> Map.values() |> Enum.sort()
    if counts == [2, 3], do: Enum.sum(dice), else: 0
  end

  @doc false
  defp four_of_a_kind_score(dice) do
    counts = Enum.frequencies(dice)

    case Enum.find_value(counts, fn {_k, v} -> v >= 4 end) do
      nil -> 0
      _ -> dice |> Enum.filter(fn x -> counts[x] >= 4 end) |> Enum.take(4) |> Enum.sum()
    end
  end
end
