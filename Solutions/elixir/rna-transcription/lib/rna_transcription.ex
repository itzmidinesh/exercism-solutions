defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

    iex> RnaTranscription.to_rna(~c"ACTG")
    ~c"UGAC"
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna
    |> Enum.map(&to_rna_char/1)
  end

  defp to_rna_char(?G), do: ?C
  defp to_rna_char(?C), do: ?G
  defp to_rna_char(?T), do: ?A
  defp to_rna_char(?A), do: ?U
end
