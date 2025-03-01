defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count([_|tail]), do: 1 + count(tail)

  @spec reverse(list) :: list
  def reverse(l), do: reversed(l, [])

  defp reversed([], acc), do: acc
  defp reversed([head|tail], acc), do: reversed(tail, [head|acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    l
    |> foldl([], fn head, acc -> [f.(head)|acc] end)
    |> reverse()
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    l
    |> foldl([], fn head, acc -> if f.(head), do: [head|acc], else: acc end)
    |> reverse()
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _f), do: acc
  def foldl([head|tail], acc, f) do
    foldl(tail, f.(head, acc), f)
  end

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(l, acc, f) do
    l
    |> reverse()
    |> foldl(acc, f)
  end

  @spec append(list, list) :: list
  def append([], b), do: b
  def append(a, []), do: a
  def append([head|tail], b), do: [head|append(tail, b)]

  @spec concat([[any]]) :: [any]
  def concat([]), do: []
  def concat([head|tail]), do: append(head, concat(tail))

end
