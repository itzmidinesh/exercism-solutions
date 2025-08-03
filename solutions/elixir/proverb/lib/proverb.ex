defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite([first | _] = strings) do
    strings
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&generate_line/1)
    |> add_final_line(first)
    |> Enum.join()
  end

  defp generate_line([want, lost]), do: "For want of a #{want} the #{lost} was lost.\n"

  defp add_final_line(lines, first_item),
    do: lines ++ ["And all for the want of a #{first_item}.\n"]
end
