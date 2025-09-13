defmodule Ledger do
  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @spec format_entries(currency(), locale(), list(entry())) :: String.t()
  def format_entries(_currency, locale, []), do: get_header(locale)

  def format_entries(currency, locale, entries) do
    entries
    |> sort_entries()
    |> Enum.map(&format_entry(currency, locale, &1))
    |> Enum.join("\n")
    |> then(&(get_header(locale) <> &1 <> "\n"))
  end

  defp get_header(:en_US), do: "Date       | Description               | Change       \n"
  defp get_header(:nl_NL), do: "Datum      | Omschrijving              | Verandering  \n"

  defp sort_entries(entries),
    do: Enum.sort_by(entries, &{&1.date, &1.description, &1.amount_in_cents})

  defp format_entry(currency, locale, entry) do
    date = format_date(entry.date, locale)
    description = format_description(entry.description)
    amount = format_amount(entry.amount_in_cents, currency, locale)

    "#{date}|#{description} |#{amount}"
  end

  defp format_date(%Date{year: year, month: month, day: day}, locale),
    do: format_date_string(pad_two_digits(month), pad_two_digits(day), year, locale)

  defp pad_two_digits(input), do: input |> to_string() |> String.pad_leading(2, "0")
  defp format_date_string(month, day, year, :en_US), do: "#{month}/#{day}/#{year} "
  defp format_date_string(month, day, year, :nl_NL), do: "#{day}-#{month}-#{year} "

  defp format_description(description) when byte_size(description) > 25,
    do: " #{String.slice(description, 0, 22)}..."

  defp format_description(description), do: " #{String.pad_trailing(description, 25, " ")}"

  defp format_amount(amount_in_cents, currency, locale) do
    amount_in_cents
    |> abs()
    |> then(&format_dollars_cents(div(&1, 100), rem(&1, 100), locale))
    |> format_signed_amount(get_currency_symbol(currency), amount_in_cents >= 0, locale)
    |> String.pad_leading(14, " ")
  end

  defp format_dollars_cents(dollars, cents, :en_US),
    do: "#{format_thousands(dollars, ",")}.#{pad_two_digits(cents)}"

  defp format_dollars_cents(dollars, cents, :nl_NL),
    do: "#{format_thousands(dollars, ".")},#{pad_two_digits(cents)}"

  defp format_thousands(amount, _separator) when amount < 1000, do: to_string(amount)

  defp format_thousands(amount, separator) do
    thousands = div(amount, 1000)
    remainder = rem(amount, 1000) |> to_string() |> String.pad_leading(3, "0")
    "#{thousands}#{separator}#{remainder}"
  end

  defp get_currency_symbol(:usd), do: "$"
  defp get_currency_symbol(:eur), do: "€"
  defp format_signed_amount(number, symbol, true, :en_US), do: "  #{symbol}#{number} "
  defp format_signed_amount(number, symbol, false, :en_US), do: " (#{symbol}#{number})"
  defp format_signed_amount(number, symbol, true, :nl_NL), do: " #{symbol} #{number} "
  defp format_signed_amount(number, symbol, false, :nl_NL), do: " #{symbol} -#{number} "
end
