defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{year, month, day}, {hours, minutes, seconds}}) do
    {:ok, datetime} = NaiveDateTime.new(year, month, day, hours, minutes, seconds)

    datetime
    |> NaiveDateTime.add(1_000_000_000, :second)
    |> to_tuple()
  end

  defp to_tuple(%NaiveDateTime{year: y, month: m, day: d, hour: h, minute: min, second: s}),
    do: {{y, m, d}, {h, min, s}}
end
