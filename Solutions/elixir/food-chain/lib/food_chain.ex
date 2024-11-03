defmodule FoodChain do
  @animals [
    {"fly", nil},
    {"spider", "It wriggled and jiggled and tickled inside her."},
    {"bird", "How absurd to swallow a bird!"},
    {"cat", "Imagine that, to swallow a cat!"},
    {"dog", "What a hog, to swallow a dog!"},
    {"goat", "Just opened her throat and swallowed a goat!"},
    {"cow", "I don't know how she swallowed a cow!"},
    {"horse", "She's dead, of course!"}
  ]
  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    start..stop
    |> Enum.map(&generate_verse/1)
    |> Enum.join("\n")
  end

  defp generate_verse(8) do
    {animal, comment} = Enum.at(@animals, 7)
    "I know an old lady who swallowed a #{animal}.\n#{comment}\n"
  end

  defp generate_verse(n) do
    current_verse = build_first_lines(n)
    chain = build_chain(n)
    last_line = "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    current_verse <> chain <> last_line
  end

  defp build_first_lines(n) do
    {animal, comment} = Enum.at(@animals, n - 1)
    comment_line = if comment, do: "#{comment}\n", else: ""
    "I know an old lady who swallowed a #{animal}.\n#{comment_line}"
  end

  defp build_chain(1), do: ""
  defp build_chain(2), do: "She swallowed the spider to catch the fly.\n"

  defp build_chain(n) do
    {current_animal, _} = Enum.at(@animals, n - 1)
    {previous_animal, _} = Enum.at(@animals, n - 2)

    case n == 3 do
      true ->
        "She swallowed the #{current_animal} to catch the spider that wriggled and jiggled and tickled inside her.\n" <>
          "She swallowed the spider to catch the fly.\n"

      false ->
        "She swallowed the #{current_animal} to catch the #{previous_animal}.\n" <>
          build_chain(n - 1)
    end
  end
end
