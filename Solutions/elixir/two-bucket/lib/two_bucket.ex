defmodule TwoBucket do
  defstruct [:bucket_one, :bucket_two, :moves]
  @type t :: %TwoBucket{bucket_one: integer, bucket_two: integer, moves: integer}

  @doc """
  Find the quickest way to fill a bucket with some amount of water from two buckets of specific sizes.
  """
  @spec measure(
          size_one :: integer,
          size_two :: integer,
          goal :: integer,
          start_bucket :: :one | :two
        ) :: {:ok, TwoBucket.t()} | {:error, :impossible}

  def measure(b1, b2, goal, :one), do: explore(b1, b2, goal, [{b1, 0, 1}], MapSet.new([{0, b2}]))
  def measure(b1, b2, goal, :two), do: explore(b1, b2, goal, [{0, b2, 1}], MapSet.new([{b1, 0}]))

  defp explore(_s1, _s2, _goal, [], _visited), do: {:error, :impossible}

  defp explore(s1, s2, goal, [{b1, b2, steps} | queue], visited) do
    cond do
      {b1, b2} in visited -> explore(s1, s2, goal, queue, visited)
      true -> explore_state(s1, s2, goal, b1, b2, steps, queue, visited)
    end
  end

  defp explore_state(_s1, _s2, goal, b1, b2, steps, _queue, _visited)
       when b1 == goal or b2 == goal do
    {:ok, %TwoBucket{bucket_one: b1, bucket_two: b2, moves: steps}}
  end

  defp explore_state(s1, s2, goal, b1, b2, steps, queue, visited) do
    new_states = next_states(s1, s2, b1, b2, steps)
    explore(s1, s2, goal, queue ++ new_states, MapSet.put(visited, {b1, b2}))
  end

  defp next_states(s1, s2, b1, b2, steps) do
    [
      # Fill bucket one
      {s1, b2, steps + 1},
      # Fill bucket two
      {b1, s2, steps + 1},
      # Pour from bucket two to bucket one
      {min(b1 + b2, s1), b2 - min(b1 + b2, s1) + b1, steps + 1},
      # Pour from bucket one to bucket two
      {b1 - min(b1 + b2, s2) + b2, min(b1 + b2, s2), steps + 1},
      # Empty bucket one
      {0, b2, steps + 1},
      # Empty bucket two
      {b1, 0, steps + 1}
    ]
  end
end
