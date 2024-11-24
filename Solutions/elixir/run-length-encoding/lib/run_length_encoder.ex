defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    string
    |> String.graphemes()
    |> Enum.chunk_by(& &1)
    |> Enum.map_join(&encode_chunk/1)
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    ~r/(\d*)([\A-Za-z\s])/
    |> Regex.scan(string)
    |> Enum.map_join(&decode_chunk/1)
  end

  defp encode_chunk([char]), do: char
  defp encode_chunk(chars), do: "#{length(chars)}#{hd(chars)}"
  defp decode_chunk([_, "", char]), do: char
  defp decode_chunk([_, count, char]), do: String.duplicate(char, String.to_integer(count))
end
