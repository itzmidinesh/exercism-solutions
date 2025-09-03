defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}
  
  defstruct map: %{}

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    enumerable
    |> Enum.reduce(%{}, fn element, acc -> Map.put(acc, element, true) end)
    |> then(&%CustomSet{map: &1})
  end

  @spec empty?(t) :: boolean
  def empty?(%CustomSet{map: map}), do: Map.size(map) == 0

  @spec contains?(t, any) :: boolean
  def contains?(%CustomSet{map: map}, element), do: Map.has_key?(map, element)

  @spec subset?(t, t) :: boolean
  def subset?(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    Map.keys(map1) |> Enum.all?(&Map.has_key?(map2, &1))
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    Map.keys(map1) |> Enum.all?(&(not Map.has_key?(map2, &1)))
  end

  @spec equal?(t, t) :: boolean
  def equal?(%CustomSet{map: map1}, %CustomSet{map: map2}), do: map1 == map2

  @spec add(t, any) :: t
  def add(%CustomSet{map: map}, element) do
    %CustomSet{map: Map.put(map, element, true)}
  end

  @spec intersection(t, t) :: t
  def intersection(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    Map.keys(map1)
    |> Enum.filter(&Map.has_key?(map2, &1))
    |> new()
  end

  @spec difference(t, t) :: t
  def difference(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    Map.keys(map1)
    |> Enum.reject(&Map.has_key?(map2, &1))
    |> new()
  end

  @spec union(t, t) :: t
  def union(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    Map.merge(map1, map2) |> then(&%CustomSet{map: &1})
  end
end
