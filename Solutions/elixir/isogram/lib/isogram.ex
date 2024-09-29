defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    cleaned_sentence =
      sentence
      |> String.downcase()
      |> String.graphemes()
      |> Enum.filter(&(&1 =~ ~r/^[a-z]$/))

    length(cleaned_sentence) == length(Enum.uniq(cleaned_sentence))
  end
end
