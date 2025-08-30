defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: {}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: {elem, list}

  @doc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count({}), do: 0
  def count({_elem, tail}), do: 1 + count(tail)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({}), do: true
  def empty?(_), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: {:error, :empty_list}
  def peek({elem, _tail}), do: {:ok, elem}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: {:error, :empty_list}
  def tail({_elem, tail}), do: {:ok, tail}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: {:error, :empty_list}
  def pop({elem, tail}), do: {:ok, elem, tail}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: list |> Enum.reverse() |> Enum.reduce(new(), &push(&2, &1))

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list({}), do: []
  def to_list({elem, tail}), do: [elem | to_list(tail)]

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: reverse(list, new())

  defp reverse({}, acc), do: acc
  defp reverse({elem, tail}, acc), do: reverse(tail, push(acc, elem))
end
