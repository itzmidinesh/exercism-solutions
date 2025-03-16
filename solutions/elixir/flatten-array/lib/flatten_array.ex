defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1, 2, 3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list), do: do_flatten(list, [])

  defp do_flatten([], acc), do: Enum.reverse(acc)
  defp do_flatten([nil | tail], acc), do: do_flatten(tail, acc)
  defp do_flatten([head | tail], acc) when is_list(head), do: do_flatten(head ++ tail, acc)
  defp do_flatten([head | tail], acc), do: do_flatten(tail, [head | acc])
end
