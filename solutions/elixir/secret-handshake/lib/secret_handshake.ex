defmodule SecretHandshake do
  import Bitwise
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    actions = ["wink", "double blink", "close your eyes", "jump"]

    result =
      actions
      |> Enum.with_index()
      |> Enum.filter(fn {_, index} -> (code &&& 1 <<< index) != 0 end)
      |> Enum.map(fn {action, _} -> action end)

    if (code &&& 0x10) != 0, do: Enum.reverse(result), else: result
  end
end
