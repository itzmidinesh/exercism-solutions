defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(&count_letters/1, max_concurrency: workers)
    |> Enum.reduce(%{}, &merge_frequencies/2)
  end

  defp count_letters(text) do
    text
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&String.match?(&1, ~r/[[:alpha:]+]/u))
    |> Enum.group_by(& &1)
    |> Map.new(fn {k, v} -> {k, length(v)} end)
  end

  defp merge_frequencies({:ok, freq}, acc) do
    Map.merge(acc, freq, fn _, v1, v2 -> v1 + v2 end)
  end
end
