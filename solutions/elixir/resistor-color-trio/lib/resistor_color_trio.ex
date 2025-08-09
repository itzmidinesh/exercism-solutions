defmodule ResistorColorTrio do
  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label([first, second, third | _]) do
    first
    |> calculate_base_value(second)
    |> apply_multiplier(third)
    |> format_with_prefix()
  end

  defp calculate_base_value(first, second), do: color_value(first) * 10 + color_value(second)
  defp apply_multiplier(base_value, third), do: base_value * round(:math.pow(10, color_value(third)))

  defp color_value(:black), do: 0
  defp color_value(:brown), do: 1
  defp color_value(:red), do: 2
  defp color_value(:orange), do: 3
  defp color_value(:yellow), do: 4
  defp color_value(:green), do: 5
  defp color_value(:blue), do: 6
  defp color_value(:violet), do: 7
  defp color_value(:grey), do: 8
  defp color_value(:white), do: 9

  defp format_with_prefix(value) when value >= 1_000_000_000,
    do: {div(value, 1_000_000_000), :gigaohms}

  defp format_with_prefix(value) when value >= 1_000_000,
    do: {div(value, 1_000_000), :megaohms}

  defp format_with_prefix(value) when value >= 1_000,
    do: {div(value, 1_000), :kiloohms}

  defp format_with_prefix(value), do: {value, :ohms}
end
