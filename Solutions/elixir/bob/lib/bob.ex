defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = String.trim(input)

    cond do
      input == "" -> "Fine. Be that way!"
      is_shouting?(input) and is_question?(input) -> "Calm down, I know what I'm doing!"
      is_question?(input) -> "Sure."
      is_shouting?(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp is_question?(input) do
    String.ends_with?(input, "?")
  end

  defp is_shouting?(input) do
    input == String.upcase(input) and input != String.downcase(input)
  end
end
