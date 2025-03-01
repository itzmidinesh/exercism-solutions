defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: any()

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school
  def new(), do: %{}

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(school, String.t(), integer) :: {:ok | :error, school}
  def add(school, name, grade) do
    case already_enrolled?(school, name) do
      true -> {:error, school}
      false -> {:ok, add_student(school, name, grade)}
    end
  end

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school, integer) :: [String.t()]
  def grade(school, grade) do
    school
    |> Map.get(grade, [])
    |> Enum.sort()
  end

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school) :: [String.t()]
  def roster(school) do
    school
    |> Enum.sort_by(fn {grade, _students} -> grade end)
    |> Enum.flat_map(fn {_grade, students} -> Enum.sort(students) end)
  end

  defp add_student(school, name, grade) do
    Map.update(school, grade, [name], &[name | &1])
  end

  defp already_enrolled?(school, name) do
    school
    |> Enum.any?(fn {_grade, students} -> name in students end)
  end
end
