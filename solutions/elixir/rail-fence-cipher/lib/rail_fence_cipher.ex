defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str
  def encode(str, rails) when rails >= byte_size(str), do: str
  def encode("", _rails), do: ""

  def encode(str, rails) do
    str
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.group_by(fn {_char, index} -> rail_for_position(index, rails) end)
    |> Enum.sort()
    |> Enum.flat_map(fn {_rail, chars} -> chars end)
    |> Enum.map(fn {char, _index} -> char end)
    |> Enum.join()
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1), do: str
  def decode(str, rails) when rails >= byte_size(str), do: str
  def decode("", _rails), do: ""

  def decode(str, rails) do
    length = String.length(str)

    length
    |> build_position_map(rails)
    |> distribute_cipher_chars(str)
    |> reconstruct_original_order(length)
  end

  defp build_position_map(length, rails) do
    0..(length - 1)
    |> Enum.group_by(&rail_for_position(&1, rails))
    |> Enum.sort()
  end

  defp distribute_cipher_chars(rail_positions, cipher_str) do
    rail_positions
    |> Enum.reduce({cipher_str, %{}}, &assign_chars_to_positions/2)
    |> elem(1)
  end

  defp assign_chars_to_positions({_rail, positions}, {remaining_chars, char_map}) do
    rail_length = length(positions)
    {rail_chars, rest} = String.split_at(remaining_chars, rail_length)

    position_chars =
      positions
      |> Enum.zip(String.graphemes(rail_chars))
      |> Map.new()

    {rest, Map.merge(char_map, position_chars)}
  end

  defp reconstruct_original_order(char_map, length) do
    0..(length - 1)
    |> Enum.map(&Map.get(char_map, &1))
    |> Enum.join()
  end

  defp rail_for_position(_position, rails) when rails <= 1, do: 0

  defp rail_for_position(position, rails) do
    cycle_length = 2 * (rails - 1)
    position_in_cycle = rem(position, cycle_length)

    min(position_in_cycle, cycle_length - position_in_cycle)
  end
end
