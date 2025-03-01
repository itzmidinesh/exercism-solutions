defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(?A), do: "A\n"

  def build_shape(letter) do
    size = letter - ?A

    ?A..letter
    |> Stream.concat((letter - 1)..?A)
    |> Stream.map(&build_row(&1, size))
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp build_row(letter, size) do
    position = letter - ?A
    outer_spaces = size - position
    inner_spaces = max(2 * position - 1, 0)

    cond do
      letter == ?A ->
        String.duplicate(" ", outer_spaces) <>
          <<letter>> <> String.duplicate(" ", outer_spaces)

      true ->
        String.duplicate(" ", outer_spaces) <>
          <<letter>> <>
          String.duplicate(" ", inner_spaces) <>
          <<letter>> <> String.duplicate(" ", outer_spaces)
    end
  end
end
