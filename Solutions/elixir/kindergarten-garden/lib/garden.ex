defmodule Garden do
  @doc """
  Accepts a string representing the arrangement of cups on a windowsill and a
  list with names of students in the class. The student names list does not
  have to be in alphabetical order.

  It decodes that string into the various gardens for each student and returns
  that information in a map.
  """
  @plant_map %{
    "G" => :grass,
    "C" => :clover,
    "R" => :radishes,
    "V" => :violets
  }
  @default_students [
    :alice,
    :bob,
    :charlie,
    :david,
    :eve,
    :fred,
    :ginny,
    :harriet,
    :ileana,
    :joseph,
    :kincaid,
    :larry
  ]
  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_students) do
    [row1, row2] = String.split(info_string, "\n")

    sorted_student_names = Enum.sort(student_names)

    sorted_student_names
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {student, index}, acc ->
      plant_indices = (index * 2)..(index * 2 + 1)

      plants =
        Enum.flat_map([row1, row2], fn row ->
          String.slice(row, plant_indices) |> String.graphemes()
        end)
        |> Enum.map(&Map.get(@plant_map, &1))

      Map.put(acc, student, List.to_tuple(plants))
    end)
  end
end
