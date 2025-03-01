defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    score
    |> Kernel.-(10)
    |> Integer.floor_div(2)
  end

  @spec ability :: pos_integer()
  def ability do
    Enum.map(1..4, fn _ -> roll_dice() end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp roll_dice, do: Enum.random(1..6)

  @spec character :: t()
  def character do
    char =
      for key <- Map.keys(%__MODULE__{}),
          into: %{},
          do: {key, ability()}

    %{char | hitpoints: 10 + modifier(char.constitution)}
  end
end
