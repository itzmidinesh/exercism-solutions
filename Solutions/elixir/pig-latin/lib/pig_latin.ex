defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.map(&translate_word/1)
    |> Enum.join(" ")
  end

  defp translate_word(word) do
    case word do
      <<char::binary-size(1), _::binary>> when char in ~w(a e i o u) ->
        word <> "ay"

      <<char1::binary-size(1), char2::binary-size(1), _::binary>>
      when char1 in ~w(x y) and char2 not in ~w(a e i o u y) ->
        word <> "ay"

      _ ->
        translate_word_default(word)
    end
  end

  defp translate_word_default(word) do
    case String.split(word, ~r/a|i|u|e|o|y|qu/, parts: 2, include_captures: true, trim: true) do
      [consonant, rest] ->
        rest <> consonant <> "ay"

      [prefix, vowel, rest] when vowel in ~w(a e i o u y) ->
        vowel <> rest <> prefix <> "ay"

      [prefix, "qu", rest] ->
        rest <> prefix <> "quay"
    end
  end
end
