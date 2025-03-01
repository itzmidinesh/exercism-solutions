defmodule ZebraPuzzle do
  @data %{
    colors: [:red, :green, :ivory, :yellow, :blue],
    people: [:englishman, :spaniard, :ukrainian, :japanese, :norwegian],
    drinks: [:coffee, :tea, :milk, :orange_juice, :water],
    smokes: [:old_gold, :kools, :chesterfields, :lucky_strike, :parliaments],
    pets: [:dog, :snails, :fox, :horse, :zebra]
  }
  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water() do
    %{person: person} = find_solution() |> Enum.find(fn person -> person.drink == :water end)
    person
  end

  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra() do
    %{person: person} = find_solution() |> Enum.find(fn person -> person.pet == :zebra end)
    person
  end

  # Helper functions
  defp create_person(color, person, drink, smoke, pet) do
    %{color: color, person: person, drink: drink, smoke: smoke, pet: pet}
  end

  defp find_index(list, val) do
    Enum.find_index(list, &(&1 == val))
  end

  # Constraint functions
  @spec same_index?(list1 :: [atom], val1 :: atom, list2 :: [atom], val2 :: atom) :: boolean
  defp same_index?(list1, val1, list2, val2) do
    find_index(list1, val1) == find_index(list2, val2)
  end

  @spec next_to?(list1 :: [atom], val1 :: atom, list2 :: [atom], val2 :: atom) :: boolean
  defp next_to?(list1, val1, list2, val2) do
    abs(find_index(list1, val1) - find_index(list2, val2)) == 1
  end

  @spec at_index?(list :: [atom], val :: atom, index :: non_neg_integer) :: boolean
  defp at_index?(list, val, index) do
    find_index(list, val) == index
  end

  @spec right_of?(list :: [atom], val1 :: atom, val2 :: atom) :: boolean
  defp right_of?(list, val1, val2) do
    find_index(list, val1) - find_index(list, val2) == 1
  end

  # Solution function
  defp find_solution() do
    %{colors: colors, people: people, drinks: drinks, smokes: smokes, pets: pets} = @data

    for color_perm <- permutations(colors),
        valid_color_perm?(color_perm),
        people_perm <- permutations(people),
        valid_people_perm?(people_perm, color_perm),
        drink_perm <- permutations(drinks),
        valid_drink_perm?(drink_perm, color_perm, people_perm),
        smoke_perm <- permutations(smokes),
        valid_smoke_perm?(smoke_perm, color_perm, drink_perm, people_perm),
        pet_perm <- permutations(pets),
        valid_pet_perm?(pet_perm, people_perm, smoke_perm) do
      Enum.zip([color_perm, people_perm, drink_perm, smoke_perm, pet_perm])
    end
    |> List.first()
    |> Enum.map(fn {color, person, drink, smoke, pet} ->
      create_person(color, person, drink, smoke, pet)
    end)
  end

  # Valid permutation functions
  defp valid_color_perm?(color_perm) do
    right_of?(color_perm, :green, :ivory)
  end

  defp valid_people_perm?(people_perm, color_perm) do
    at_index?(people_perm, :norwegian, 0) and
      same_index?(people_perm, :englishman, color_perm, :red) and
      next_to?(people_perm, :norwegian, color_perm, :blue)
  end

  defp valid_drink_perm?(drink_perm, color_perm, people_perm) do
    at_index?(drink_perm, :milk, 2) and
      same_index?(drink_perm, :coffee, color_perm, :green) and
      same_index?(drink_perm, :tea, people_perm, :ukrainian)
  end

  defp valid_smoke_perm?(smoke_perm, color_perm, drink_perm, people_perm) do
    same_index?(smoke_perm, :kools, color_perm, :yellow) and
      same_index?(smoke_perm, :lucky_strike, drink_perm, :orange_juice) and
      same_index?(smoke_perm, :parliaments, people_perm, :japanese)
  end

  defp valid_pet_perm?(pet_perm, people_perm, smoke_perm) do
    same_index?(pet_perm, :dog, people_perm, :spaniard) and
      same_index?(pet_perm, :snails, smoke_perm, :old_gold) and
      next_to?(smoke_perm, :chesterfields, pet_perm, :fox) and
      next_to?(smoke_perm, :kools, pet_perm, :horse)
  end

  # Permutations function
  @spec permutations([any()]) :: [[any()]]
  defp permutations([]), do: [[]]

  defp permutations(list) do
    for elem <- list,
        rest <- permutations(list -- [elem]) do
      [elem | rest]
    end
  end
end
