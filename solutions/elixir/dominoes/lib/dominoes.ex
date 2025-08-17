defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true
  def chain?([{a, a}]), do: true
  def chain?([{_a, _b}]), do: false

  def chain?(dominoes) do
    dominoes
    |> Stream.map(&{&1, List.delete(dominoes, &1)})
    |> Enum.any?(&try_both_orientations/1)
  end

  defp try_both_orientations({domino, remaining}),
    do: build_chain(domino, remaining) or build_chain(reverse(domino), remaining)

  defp build_chain({target, current}, []), do: current == target

  defp build_chain(state, remaining),
    do: Enum.any?(remaining, &connects_and_continues?(&1, state, remaining))

  defp connects_and_continues?({current, next}, {target, current}, remaining),
    do: continue_chain({current, next}, {target, next}, remaining)

  defp connects_and_continues?({next, current}, {target, current}, remaining),
    do: continue_chain({next, current}, {target, next}, remaining)

  defp connects_and_continues?(_, _, _), do: false

  defp continue_chain(used_domino, state, remaining) do
    remaining
    |> List.delete(used_domino)
    |> then(&build_chain(state, &1))
  end

  defp reverse({a, b}), do: {b, a}
end
