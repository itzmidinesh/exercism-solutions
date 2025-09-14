defmodule OcrNumbers do
  @digit_patterns %{
    [" _ ", "| |", "|_|", "   "] => "0",
    ["   ", "  |", "  |", "   "] => "1",
    [" _ ", " _|", "|_ ", "   "] => "2",
    [" _ ", " _|", " _|", "   "] => "3",
    ["   ", "|_|", "  |", "   "] => "4",
    [" _ ", "|_ ", " _|", "   "] => "5",
    [" _ ", "|_ ", "|_|", "   "] => "6",
    [" _ ", "  |", "  |", "   "] => "7",
    [" _ ", "|_|", "|_|", "   "] => "8",
    [" _ ", "|_|", " _|", "   "] => "9"
  }

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    with {:ok, lines} <- validate_dimensions(input) do
      process_lines(lines)
    end
  end

  defp validate_dimensions(input) do
    line_count = length(input)

    case {rem(line_count, 4), valid_column_count?(input)} do
      {0, true} -> {:ok, input}
      {_, false} -> {:error, "invalid column count"}
      _ -> {:error, "invalid line count"}
    end
  end

  defp valid_column_count?(input) do
    input
    |> Enum.map(&String.length/1)
    |> Enum.all?(&(rem(&1, 3) == 0))
  end

  defp process_lines(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.map(&parse_number_line/1)
    |> Enum.join(",")
    |> then(&{:ok, &1})
  end

  defp parse_number_line(lines) do
    digit_count = calculate_digit_count(lines)

    0..(digit_count - 1)
    |> Enum.map(&extract_recognize_digit(&1, lines))
    |> Enum.join("")
  end

  defp calculate_digit_count(lines) do
    lines
    |> hd()
    |> String.length()
    |> div(3)
  end

  defp extract_recognize_digit(index, lines) do
    start_col = index * 3

    lines
    |> Enum.map(&String.slice(&1, start_col, 3))
    |> recognize_digit()
  end

  defp recognize_digit(pattern), do: Map.get(@digit_patterns, pattern, "?")
end
