defmodule Transmission do
  import Bitwise

  @data_bits_per_chunk 7
  @bits_per_byte 8

  @doc """
  Return the transmission sequence for a message.
  """
  @spec get_transmit_sequence(binary()) :: binary()
  def get_transmit_sequence(message) do
    message
    |> :binary.bin_to_list()
    |> Enum.flat_map(&byte_to_bits/1)
    |> Enum.chunk_every(@data_bits_per_chunk, @data_bits_per_chunk, :discard)
    |> add_last_chunk(message)
    |> Enum.map(&bits_with_parity/1)
    |> Enum.map(&bits_to_byte/1)
    |> :binary.list_to_bin()
  end

  defp byte_to_bits(byte), do: for(<<(bit::1 <- <<byte>>)>>, do: bit)
  defp bits_to_byte(bits), do: Enum.reduce(bits, 0, fn bit, acc -> acc <<< 1 ||| bit end)

  defp add_last_chunk(chunks, message) do
    message
    |> byte_size()
    |> Kernel.*(@bits_per_byte)
    |> rem(@data_bits_per_chunk)
    |> case do
      0 -> chunks
      _ -> append_remainder_chunk(message, chunks)
    end
  end

  defp append_remainder_chunk(message, chunks) do
    message
    |> :binary.bin_to_list()
    |> Enum.flat_map(&byte_to_bits/1)
    |> Enum.drop(length(chunks) * @data_bits_per_chunk)
    |> then(&(chunks ++ [&1]))
  end

  defp bits_with_parity(bits) do
    bits
    |> Kernel.++(List.duplicate(0, @data_bits_per_chunk - length(bits)))
    |> then(&(&1 ++ [calculate_parity(&1)]))
  end

  defp calculate_parity(bits), do: bits |> Enum.count(&(&1 == 1)) |> rem(2)

  @doc """
  Return the message decoded from the received transmission.
  """
  @spec decode_message(binary()) :: {:ok, binary()} | {:error, String.t()}
  def decode_message(received_data) do
    received_data
    |> :binary.bin_to_list()
    |> Enum.map(&byte_to_bits/1)
    |> Enum.reduce_while([], &validate_and_extract/2)
    |> case do
      {:error, _} = err -> err
      bits -> {:ok, bits_to_message(bits)}
    end
  end

  defp validate_and_extract(bits, acc) do
    bits
    |> Enum.count(&(&1 == 1))
    |> rem(2)
    |> case do
      0 -> {:cont, acc ++ Enum.take(bits, @data_bits_per_chunk)}
      _ -> {:halt, {:error, "wrong parity"}}
    end
  end

  defp bits_to_message(bits) do
    bits
    |> Enum.chunk_every(@bits_per_byte, @bits_per_byte, :discard)
    |> Enum.map(&bits_to_byte/1)
    |> :binary.list_to_bin()
  end
end
