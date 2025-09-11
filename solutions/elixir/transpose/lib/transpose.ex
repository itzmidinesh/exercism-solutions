defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(""), do: ""

  def transpose(input) do
    input
    |> String.split("\n")
    |> transpose_matrix()
  end

  defp transpose_matrix([]), do: ""

  defp transpose_matrix(rows) do
    max_col = find_max_col(rows)

    0..(max_col - 1)
    |> Enum.map(&build_transposed_row(&1, rows))
    |> Enum.join("\n")
  end

  defp find_max_col(rows) do
    rows
    |> Enum.map(&String.length/1)
    |> Enum.max(fn -> 0 end)
  end

  defp build_transposed_row(col_index, rows) do
    rows
    |> Enum.map(&extract_chars_with_info(&1, col_index))
    |> Enum.reverse()
    |> Enum.drop_while(fn {type, _char} -> type == :padding end)
    |> Enum.reverse()
    |> Enum.map(fn {_type, char} -> char end)
    |> Enum.join("")
  end

  defp extract_chars_with_info(row, col_index) do
    case col_index < String.length(row) do
      true -> {:real_char, String.at(row, col_index)}
      false -> {:padding, " "}
    end
  end
end
