defmodule Matrix do
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input), do: %Matrix{matrix: build_matrix(input)}

  defp build_matrix(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row_string) do
    row_string
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(%Matrix{matrix: matrix}) do
    matrix
    |> Enum.map(&format_row/1)
    |> Enum.join("\n")
  end

  defp format_row(row) do
    row
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join(" ")
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(%Matrix{matrix: matrix}), do: matrix

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(%Matrix{matrix: matrix}, index), do: Enum.at(matrix, index - 1)

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(%Matrix{matrix: matrix}), do: transpose(matrix)

  defp transpose([]), do: []
  defp transpose([[] | _]), do: []

  defp transpose(matrix) do
    matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) do
    matrix
    |> columns()
    |> Enum.at(index - 1)
  end
end
