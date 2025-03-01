defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    first_day = Date.new!(year, month, 1)
    last_day = Date.end_of_month(first_day)

    candidates =
      Date.range(first_day, last_day)
      |> Enum.filter(&(Date.day_of_week(&1) == day_of_week(weekday)))

    case schedule do
      :first -> Enum.at(candidates, 0)
      :second -> Enum.at(candidates, 1)
      :third -> Enum.at(candidates, 2)
      :fourth -> Enum.at(candidates, 3)
      :teenth -> Enum.find(candidates, &(&1.day >= 13 and &1.day <= 19))
      :last -> List.last(candidates)
    end
  end

  defp day_of_week(weekday) do
    case weekday do
      :monday -> 1
      :tuesday -> 2
      :wednesday -> 3
      :thursday -> 4
      :friday -> 5
      :saturday -> 6
      :sunday -> 7
    end
  end
end
