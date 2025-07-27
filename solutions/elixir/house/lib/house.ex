defmodule House do
  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    start..stop
    |> Enum.map(&verse/1)
    |> Enum.join("")
  end

  defp verse(n) do
    verse_data()
    |> Enum.take(n)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(&format_phrase(&1, n))
    |> Enum.join(" ")
    |> build_verse()
  end

  defp format_phrase({{subject, _action}, index}, n) when index == n - 1, do: subject
  defp format_phrase({{subject, action}, _index}, _n), do: "#{subject} #{action}"
  defp build_verse(chain), do: "This is #{chain}.\n"

  defp verse_data do
    [
      {"the house that Jack built", ""},
      {"the malt", "that lay in"},
      {"the rat", "that ate"},
      {"the cat", "that killed"},
      {"the dog", "that worried"},
      {"the cow with the crumpled horn", "that tossed"},
      {"the maiden all forlorn", "that milked"},
      {"the man all tattered and torn", "that kissed"},
      {"the priest all shaven and shorn", "that married"},
      {"the rooster that crowed in the morn", "that woke"},
      {"the farmer sowing his corn", "that kept"},
      {"the horse and the hound and the horn", "that belonged to"}
    ]
  end
end
