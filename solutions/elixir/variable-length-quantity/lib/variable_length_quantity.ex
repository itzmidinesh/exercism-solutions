defmodule VariableLengthQuantity do
  import Bitwise

  @seven_bit_mask 0x7F
  @continuation_bit 0x80

  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    integers
    |> Enum.map(&encode_integer/1)
    |> IO.iodata_to_binary()
  end

  defp encode_integer(n) do
    n
    |> encode_to_chunks([])
    |> finalize_chunks()
  end

  defp encode_to_chunks(0, []), do: [0]
  defp encode_to_chunks(0, acc), do: acc

  defp encode_to_chunks(n, acc) do
    chunk = n &&& @seven_bit_mask
    encode_to_chunks(n >>> 7, [chunk | acc])
  end

  defp finalize_chunks([last]), do: [last]
  defp finalize_chunks([head | tail]), do: [head ||| @continuation_bit | finalize_chunks(tail)]

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    with {:ok, integers} <- decode_bytes(bytes, []) do
      {:ok, Enum.reverse(integers)}
    end
  end

  defp decode_bytes(<<>>, acc), do: {:ok, acc}

  defp decode_bytes(bytes, acc) do
    with {:ok, integer, remaining} <- decode_single_integer(bytes, 0, 0) do
      decode_bytes(remaining, [integer | acc])
    end
  end

  defp decode_single_integer(<<>>, _value, _bits_read), do: {:error, "incomplete sequence"}

  defp decode_single_integer(<<byte, rest::binary>>, value, _bits_read)
       when byte < @continuation_bit do
    final_value = value <<< 7 ||| byte
    {:ok, final_value, rest}
  end

  defp decode_single_integer(<<byte, rest::binary>>, value, bits_read) do
    chunk = byte &&& @seven_bit_mask
    new_value = value <<< 7 ||| chunk
    decode_single_integer(rest, new_value, bits_read + 7)
  end
end
