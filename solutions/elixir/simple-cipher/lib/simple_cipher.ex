defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key), do: shift_text(plaintext, key, &shift_forward/2)

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key), do: shift_text(ciphertext, key, &shift_backward/2)

  @doc """
  Generate a random key of a given length. It should contain lowercase letters only.
  """
  def generate_key(length) do
    1..length
    |> Enum.map(fn _ -> Enum.random(?a..?z) end)
    |> List.to_string()
  end

  defp shift_text(text, key, shift_fn) do
    text
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(&apply_shift_with_key(&1, key, shift_fn))
    |> Enum.join()
  end

  defp apply_shift_with_key({char, index}, key, shift_fn) do
    key_char = String.at(key, rem(index, String.length(key)))
    shift_fn.(char, key_char)
  end

  defp shift_forward(char, key_char) do
    char
    |> char_to_index()
    |> then(&(&1 - ?a + key_to_shift_amount(key_char)))
    |> index_to_char()
  end

  defp shift_backward(char, key_char) do
    char
    |> char_to_index()
    |> then(&(&1 - ?a - key_to_shift_amount(key_char) + 26))
    |> index_to_char()
  end

  defp char_to_index(char), do: char |> String.to_charlist() |> hd()
  defp key_to_shift_amount(key_char), do: (key_char |> String.to_charlist() |> hd()) - ?a
  defp index_to_char(shifted), do: <<rem(shifted, 26) + ?a>>
end
