defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    with :ok <- validate_colors(opts),
         white <- Keyword.get(opts, :white),
         black <- Keyword.get(opts, :black),
         :ok <- validate_position(white),
         :ok <- validate_position(black),
         :ok <- validate_not_same_position(white, black) do
      %Queens{white: white, black: black}
    end
  end

  defp validate_colors([]), do: :ok
  defp validate_colors([{:white, _} | rest]), do: validate_colors(rest)
  defp validate_colors([{:black, _} | rest]), do: validate_colors(rest)
  defp validate_colors(_), do: raise(ArgumentError)

  defp validate_position(nil), do: :ok
  defp validate_position({r, c}) when r in 0..7 and c in 0..7, do: :ok
  defp validate_position(_), do: raise(ArgumentError)

  defp validate_not_same_position(nil, _), do: :ok
  defp validate_not_same_position(_, nil), do: :ok
  defp validate_not_same_position(pos, pos), do: raise(ArgumentError)
  defp validate_not_same_position(_, _), do: :ok

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{white: white, black: black}) do
    0..7
    |> Enum.map(&render_row(&1, white, black))
    |> Enum.join("\n")
  end

  defp render_row(row, white, black) do
    0..7
    |> Enum.map(&piece_at({row, &1}, white, black))
    |> Enum.join(" ")
  end

  defp piece_at(pos, pos, _black), do: "W"
  defp piece_at(pos, _white, pos), do: "B"
  defp piece_at(_pos, _white, _black), do: "_"

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{white: nil}), do: false
  def can_attack?(%Queens{black: nil}), do: false
  def can_attack?(%Queens{white: {r, _c1}, black: {r, _c2}}), do: true
  def can_attack?(%Queens{white: {_r1, c}, black: {_r2, c}}), do: true
  def can_attack?(%Queens{white: {r1, c1}, black: {r2, c2}}), do: abs(r1 - r2) == abs(c1 - c2)
end
