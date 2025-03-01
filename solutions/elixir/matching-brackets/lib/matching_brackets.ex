defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.graphemes()
    |> Enum.reduce_while([], fn char, stack ->
      case {char, stack} do
        {c, _} when c in ["(", "{", "["] -> {:cont, [char | stack]}
        {")", ["(" | rest]} -> {:cont, rest}
        {"]", ["[" | rest]} -> {:cont, rest}
        {"}", ["{" | rest]} -> {:cont, rest}
        {c, _} when c in [")", "]", "}"] -> {:halt, false}
        _ -> {:cont, stack}
      end
    end)
    |> case do
      [] -> true
      _ -> false
    end
  end
end
