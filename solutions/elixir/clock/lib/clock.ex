defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    (hour * 60 + minute)
    |> normalize_minutes()
    |> minutes_to_clock()
  end

  defp normalize_minutes(total_minutes) when rem(total_minutes, 1440) < 0,
    do: rem(total_minutes, 1440) + 1440

  defp normalize_minutes(total_minutes), do: rem(total_minutes, 1440)

  defp minutes_to_clock(minutes), do: %Clock{hour: div(minutes, 60), minute: rem(minutes, 60)}

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute), do: new(hour, minute + add_minute)
end

defimpl String.Chars, for: Clock do
  def to_string(%Clock{hour: hour, minute: minute}), do: "#{pad_time(hour)}:#{pad_time(minute)}"

  defp pad_time(time), do: time |> Integer.to_string() |> String.pad_leading(2, "0")
end
