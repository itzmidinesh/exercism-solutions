defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    normalized_base = normalize(base)

    candidates
    |> Enum.filter(fn candidate ->
      candidate_normalized = normalize(candidate)

      candidate_normalized == normalized_base and
        String.downcase(candidate) != String.downcase(base)
    end)
  end

  defp normalize(word) do
    word
    |> String.downcase()
    |> String.graphemes()
    |> Enum.sort()
  end
end
