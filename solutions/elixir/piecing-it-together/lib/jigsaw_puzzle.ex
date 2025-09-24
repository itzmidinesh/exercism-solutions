defmodule JigsawPuzzle do
  @doc """
  Fill in missing jigsaw puzzle details from partial data
  """

  @type format() :: :landscape | :portrait | :square
  @type t() :: %__MODULE__{
          pieces: pos_integer() | nil,
          rows: pos_integer() | nil,
          columns: pos_integer() | nil,
          format: format() | nil,
          aspect_ratio: float() | nil,
          border: pos_integer() | nil,
          inside: pos_integer() | nil
        }

  defstruct [:pieces, :rows, :columns, :format, :aspect_ratio, :border, :inside]

  @spec data(jigsaw_puzzle :: JigsawPuzzle.t()) ::
          {:ok, JigsawPuzzle.t()} | {:error, String.t()}
  def data(jigsaw_puzzle) do
    with {:ok, puzzle} <- fill_missing_data(jigsaw_puzzle),
         {:ok, puzzle} <- validate_consistency(puzzle) do
      {:ok, puzzle}
    end
  end

  defp fill_missing_data(puzzle) do
    puzzle
    |> derive_dimensions()
    |> derive_pieces()
    |> derive_aspect_ratio()
    |> derive_format()
    |> derive_border_inside()
    |> validate_completeness()
  end

  defp derive_dimensions(%{rows: rows, columns: columns} = puzzle)
       when rows != nil and columns != nil,
       do: puzzle

  defp derive_dimensions(%{rows: rows, format: :square} = puzzle) when rows != nil,
    do: %{puzzle | columns: rows}

  defp derive_dimensions(%{columns: columns, format: :square} = puzzle) when columns != nil,
    do: %{puzzle | rows: columns}

  defp derive_dimensions(%{rows: rows, aspect_ratio: ratio} = puzzle)
       when rows != nil and ratio != nil,
       do: %{puzzle | columns: round(rows * ratio)}

  defp derive_dimensions(%{columns: columns, aspect_ratio: ratio} = puzzle)
       when columns != nil and ratio != nil,
       do: %{puzzle | rows: round(columns / ratio)}

  defp derive_dimensions(%{pieces: pieces, aspect_ratio: ratio} = puzzle)
       when pieces != nil and ratio != nil do
    rows = round(:math.sqrt(pieces / ratio))
    %{puzzle | rows: rows, columns: round(rows * ratio)}
  end

  defp derive_dimensions(%{pieces: pieces, format: :square} = puzzle) when pieces != nil do
    side = round(:math.sqrt(pieces))
    %{puzzle | rows: side, columns: side}
  end

  defp derive_dimensions(%{border: border, format: format} = puzzle)
       when border != nil and format != nil,
       do: derive_from_border_and_format(puzzle)

  defp derive_dimensions(%{inside: inside, format: format} = puzzle)
       when inside != nil and format != nil,
       do: derive_from_inside_and_format(puzzle)

  defp derive_dimensions(%{inside: inside, aspect_ratio: ratio} = puzzle)
       when inside != nil and ratio != nil,
       do: derive_from_inside_and_ratio(puzzle)

  defp derive_dimensions(puzzle), do: puzzle

  defp derive_from_border_and_format(%{format: :square, border: border} = puzzle) do
    side = div(border + 4, 4)
    %{puzzle | rows: side, columns: side}
  end

  defp derive_from_border_and_format(puzzle), do: derive_non_square_from_border(puzzle)

  defp derive_non_square_from_border(%{aspect_ratio: ratio, border: border} = puzzle)
       when not is_nil(ratio) do
    rows = round((border + 4) / (2 * (1 + ratio)))
    %{puzzle | rows: rows, columns: round(rows * ratio)}
  end

  defp derive_non_square_from_border(%{pieces: pieces} = puzzle) when not is_nil(pieces),
    do: derive_from_border_and_pieces(puzzle)

  defp derive_non_square_from_border(puzzle), do: puzzle

  defp derive_from_border_and_pieces(%{border: border, pieces: pieces} = puzzle) do
    border
    |> quadratic_coefficients_for_border(pieces)
    |> get_discriminant()
    |> solve_quadratic()
    |> case do
      {:ok, rows} -> %{puzzle | rows: rows, columns: div(pieces, rows)}
      {:error, :no_solutions} -> puzzle
    end
  end

  defp quadratic_coefficients_for_border(border, pieces), do: {1, -((border + 4) / 2), pieces}

  defp get_discriminant({a, b, c}), do: {b * b - 4 * a * c, a, b}

  defp solve_quadratic({discriminant, a, b}) when discriminant >= 0 do
    [
      (-b + :math.sqrt(discriminant)) / (2 * a),
      (-b - :math.sqrt(discriminant)) / (2 * a)
    ]
    |> choose_positive_integer_solution()
  end

  defp solve_quadratic(_), do: {:error, :no_solutions}

  defp choose_positive_integer_solution(solutions) do
    solutions
    |> Enum.filter(&(&1 > 0))
    |> Enum.map(&round/1)
    |> case do
      [] -> {:error, :no_solutions}
      results -> {:ok, Enum.max(results)}
    end
  end

  defp derive_from_inside_and_format(%{format: :square, inside: inside} = puzzle) do
    side = round(:math.sqrt(inside)) + 2
    %{puzzle | rows: side, columns: side}
  end

  defp derive_from_inside_and_format(puzzle), do: puzzle

  defp derive_from_inside_and_ratio(%{inside: inside, aspect_ratio: ratio} = puzzle) do
    {ratio, inside}
    |> quadratic_coefficients_for_inside()
    |> get_discriminant()
    |> solve_quadratic()
    |> case do
      {:ok, rows} -> %{puzzle | rows: rows, columns: round(rows * ratio)}
      {:error, :no_solutions} -> puzzle
    end
  end

  defp quadratic_coefficients_for_inside({ratio, inside}),
    do: {ratio, -(2 * ratio + 2), 4 - inside}

  defp derive_pieces(%{pieces: pieces} = puzzle) when not is_nil(pieces), do: puzzle

  defp derive_pieces(%{rows: rows, columns: columns} = puzzle)
       when is_integer(rows) and is_integer(columns),
       do: %{puzzle | pieces: rows * columns}

  defp derive_pieces(%{border: border, inside: inside} = puzzle)
       when not is_nil(border) and not is_nil(inside),
       do: %{puzzle | pieces: border + inside}

  defp derive_pieces(puzzle), do: puzzle

  defp derive_aspect_ratio(%{aspect_ratio: ratio} = puzzle) when not is_nil(ratio), do: puzzle

  defp derive_aspect_ratio(%{rows: rows, columns: columns} = puzzle)
       when is_integer(rows) and is_integer(columns) and rows > 0,
       do: %{puzzle | aspect_ratio: columns / rows}

  defp derive_aspect_ratio(puzzle), do: puzzle

  defp derive_format(%{format: format} = puzzle) when not is_nil(format), do: puzzle

  defp derive_format(%{aspect_ratio: ratio} = puzzle) when is_number(ratio) do
    format = format_from_ratio(ratio)
    %{puzzle | format: format}
  end

  defp derive_format(puzzle), do: puzzle

  defp format_from_ratio(ratio) when ratio < 1, do: :portrait
  defp format_from_ratio(1.0), do: :square
  defp format_from_ratio(ratio) when ratio > 1, do: :landscape

  defp derive_border_inside(puzzle) do
    puzzle
    |> derive_border()
    |> derive_inside()
  end

  defp derive_border(%{border: border} = puzzle) when not is_nil(border), do: puzzle

  defp derive_border(%{rows: rows, columns: columns} = puzzle)
       when is_integer(rows) and is_integer(columns),
       do: %{puzzle | border: 2 * (rows + columns - 2)}

  defp derive_border(puzzle), do: puzzle

  defp derive_inside(%{inside: inside} = puzzle) when not is_nil(inside), do: puzzle

  defp derive_inside(%{pieces: pieces, border: border} = puzzle)
       when is_integer(pieces) and is_integer(border),
       do: %{puzzle | inside: pieces - border}

  defp derive_inside(puzzle), do: puzzle

  defp validate_completeness(%{pieces: nil}), do: {:error, "Insufficient data"}
  defp validate_completeness(%{rows: nil}), do: {:error, "Insufficient data"}
  defp validate_completeness(%{columns: nil}), do: {:error, "Insufficient data"}
  defp validate_completeness(puzzle), do: {:ok, puzzle}

  defp validate_consistency(puzzle) do
    [
      &check_pieces_consistency/1,
      &check_dimensions_consistency/1,
      &check_aspect_ratio_consistency/1,
      &check_format_consistency/1,
      &check_border_consistency/1,
      &check_inside_consistency/1
    ]
    |> Enum.all?(&apply(&1, [puzzle]))
    |> case do
      true -> {:ok, puzzle}
      false -> {:error, "Contradictory data"}
    end
  end

  defp check_pieces_consistency(%{pieces: pieces, rows: rows, columns: columns})
       when is_integer(pieces) and is_integer(rows) and is_integer(columns),
       do: pieces == rows * columns

  defp check_pieces_consistency(_), do: true

  defp check_dimensions_consistency(%{rows: rows, columns: columns, aspect_ratio: ratio})
       when is_integer(rows) and is_integer(columns) and is_number(ratio),
       do: abs(columns / rows - ratio) < 0.01

  defp check_dimensions_consistency(_), do: true

  defp check_aspect_ratio_consistency(%{aspect_ratio: ratio, format: format}) do
    case {ratio, format} do
      {ratio, :portrait} when is_number(ratio) -> ratio < 1
      {ratio, :square} when is_number(ratio) -> abs(ratio - 1.0) < 0.01
      {ratio, :landscape} when is_number(ratio) -> ratio > 1
      _ -> true
    end
  end

  defp check_format_consistency(%{format: :square, rows: rows, columns: columns})
       when is_integer(rows) and is_integer(columns),
       do: rows == columns

  defp check_format_consistency(%{format: :portrait, rows: rows, columns: columns})
       when is_integer(rows) and is_integer(columns),
       do: rows > columns

  defp check_format_consistency(%{format: :landscape, rows: rows, columns: columns})
       when is_integer(rows) and is_integer(columns),
       do: columns > rows

  defp check_format_consistency(_), do: true

  defp check_border_consistency(%{border: border, rows: rows, columns: columns})
       when is_integer(border) and is_integer(rows) and is_integer(columns),
       do: border == 2 * (rows + columns - 2)

  defp check_border_consistency(_), do: true

  defp check_inside_consistency(%{inside: inside, pieces: pieces, border: border})
       when is_integer(inside) and is_integer(pieces) and is_integer(border),
       do: inside == pieces - border

  defp check_inside_consistency(_), do: true
end
