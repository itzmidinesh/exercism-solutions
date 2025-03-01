defmodule RobotSimulator do
  @type robot() :: %{direction: direction(), position: position()}
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0}) do
    cond do
      not valid_direction?(direction) ->
        {:error, "invalid direction"}

      not valid_position?(position) ->
        {:error, "invalid position"}

      true ->
        %{
          direction: direction,
          position: position
        }
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, instructions) do
    instructions
    |> String.graphemes()
    |> Enum.reduce_while(robot, fn instruction, robot ->
      case instruction do
        "R" ->
          {:cont, turn_right(robot)}

        "L" ->
          {:cont, turn_left(robot)}

        "A" ->
          {:cont, advance(robot)}

        _ ->
          {:halt, {:error, "invalid instruction"}}
      end
    end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(robot), do: robot.position

  defp valid_direction?(direction), do: direction in [:north, :east, :south, :west]

  defp valid_position?({x, y}), do: is_integer(x) and is_integer(y)
  defp valid_position?(_), do: false

  defp turn_right(%{direction: :north} = robot), do: %{robot | direction: :east}
  defp turn_right(%{direction: :east} = robot), do: %{robot | direction: :south}
  defp turn_right(%{direction: :south} = robot), do: %{robot | direction: :west}
  defp turn_right(%{direction: :west} = robot), do: %{robot | direction: :north}

  defp turn_left(%{direction: :north} = robot), do: %{robot | direction: :west}
  defp turn_left(%{direction: :west} = robot), do: %{robot | direction: :south}
  defp turn_left(%{direction: :south} = robot), do: %{robot | direction: :east}
  defp turn_left(%{direction: :east} = robot), do: %{robot | direction: :north}

  defp advance(%{direction: :north, position: {x, y}} = robot),
    do: %{robot | position: {x, y + 1}}

  defp advance(%{direction: :east, position: {x, y}} = robot), do: %{robot | position: {x + 1, y}}

  defp advance(%{direction: :south, position: {x, y}} = robot),
    do: %{robot | position: {x, y - 1}}

  defp advance(%{direction: :west, position: {x, y}} = robot), do: %{robot | position: {x - 1, y}}
end
