defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    raw
    |> prepare_number()
    |> validate_number()
  end

  defp prepare_number(raw) do
    raw
    |> String.replace(~r/[\s.()-]/, "")
    |> String.replace(~r/^\+/, "")
  end

  defp validate_number(number) when byte_size(number) < 10,
    do: {:error, "must not be fewer than 10 digits"}

  defp validate_number(number) when byte_size(number) > 11,
    do: {:error, "must not be greater than 11 digits"}

  defp validate_number("1" <> rest) when byte_size(rest) == 10,
    do: validate_number(rest)

  defp validate_number(
         <<area_code::binary-size(3), exchange_code::binary-size(3), _::binary>> = number
       )
       when byte_size(number) == 10 do
    cond do
      String.match?(number, ~r/[^\d]/) -> {:error, "must contain digits only"}
      String.starts_with?(area_code, "0") -> {:error, "area code cannot start with zero"}
      String.starts_with?(area_code, "1") -> {:error, "area code cannot start with one"}
      String.starts_with?(exchange_code, "0") -> {:error, "exchange code cannot start with zero"}
      String.starts_with?(exchange_code, "1") -> {:error, "exchange code cannot start with one"}
      true -> {:ok, number}
    end
  end

  defp validate_number(_), do: {:error, "11 digits must start with 1"}
end
