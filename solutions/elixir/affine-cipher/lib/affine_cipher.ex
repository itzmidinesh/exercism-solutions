defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b} = key, message) do
    with {:ok, :valid} <- validate_coprime(key) do
      message
      |> clean_message()
      |> encrypt_chars(a, b)
      |> group_by_fives()
      |> then(&{:ok, &1})
    end
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), encrypted :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b} = key, encrypted) do
    with {:ok, :valid} <- validate_coprime(key) do
      encrypted
      |> String.replace(" ", "")
      |> String.downcase()
      |> String.to_charlist()
      |> Enum.map(&decrypt_char(&1, a, b))
      |> List.to_string()
      |> then(&{:ok, &1})
    end
  end

  defp validate_coprime(%{a: a}) do
    case gcd(a, 26) do
      1 -> {:ok, :valid}
      _ -> {:error, "a and m must be coprime."}
    end
  end

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp clean_message(message) do
    message
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]/, "")
  end

  defp encrypt_chars(message, a, b) do
    message
    |> String.to_charlist()
    |> Enum.map(&encrypt_char(&1, a, b))
    |> List.to_string()
  end

  defp encrypt_char(char, a, b) when char >= ?a and char <= ?z,
    do: rem(a * (char - ?a) + b, 26) + ?a

  defp encrypt_char(char, _a, _b), do: char

  defp group_by_fives(text) do
    text
    |> String.graphemes()
    |> Enum.chunk_every(5)
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end

  defp decrypt_char(char, a, b) when char >= ?a and char <= ?z do
    decrypted_i = rem(mod_inverse(a, 26) * (char - ?a - b), 26)

    case decrypted_i < 0 do
      true -> decrypted_i + 26 + ?a
      false -> decrypted_i + ?a
    end
  end

  defp decrypt_char(char, _a, _b), do: char

  defp mod_inverse(a, m) do
    case extended_gcd(a, m) do
      {_, x, _} when x < 0 -> x + m
      {_, x, _} -> x
    end
  end

  defp extended_gcd(a, 0), do: {a, 1, 0}

  defp extended_gcd(a, b) do
    {gcd_val, x1, y1} = extended_gcd(b, rem(a, b))
    {gcd_val, y1, x1 - div(a, b) * y1}
  end
end
