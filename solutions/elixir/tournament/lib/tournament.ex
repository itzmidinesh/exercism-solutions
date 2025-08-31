defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> parse_matches()
    |> build_stats()
    |> sort_teams()
    |> format_table()
  end

  defp parse_matches(lines) do
    lines
    |> Enum.map(&parse_match/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_match(line) do
    case String.split(line, ";") do
      [team1, team2, outcome] when outcome in ["win", "loss", "draw"] ->
        {team1, team2, outcome}

      _ ->
        nil
    end
  end

  defp build_stats(matches), do: matches |> Enum.reduce(%{}, &update_team_stats/2)

  defp update_team_stats({team1, team2, outcome}, stats) do
    stats
    |> update_team(team1, outcome)
    |> update_team(team2, opposite_outcome(outcome))
  end

  defp update_team(stats, team, outcome) do
    updated =
      stats
      |> Map.get(team, %{mp: 0, w: 0, d: 0, l: 0, p: 0})
      |> Map.update!(:mp, &(&1 + 1))
      |> update_outcome_stats(outcome)

    Map.put(stats, team, updated)
  end

  defp update_outcome_stats(stats, "win"),
    do: stats |> Map.update!(:w, &(&1 + 1)) |> Map.update!(:p, &(&1 + 3))

  defp update_outcome_stats(stats, "draw"),
    do: stats |> Map.update!(:d, &(&1 + 1)) |> Map.update!(:p, &(&1 + 1))

  defp update_outcome_stats(stats, "loss"), do: stats |> Map.update!(:l, &(&1 + 1))

  defp opposite_outcome("win"), do: "loss"
  defp opposite_outcome("loss"), do: "win"
  defp opposite_outcome("draw"), do: "draw"

  defp sort_teams(stats),
    do: stats |> Enum.sort_by(fn {team, %{p: points}} -> {-points, team} end)

  defp format_table(sorted_teams) do
    header = "#{format_trailing("Team")} | MP |  W |  D |  L |  P"

    rows =
      sorted_teams
      |> Enum.map(&format_row/1)

    [header | rows] |> Enum.join("\n")
  end

  defp format_row({team, %{mp: mp, w: w, d: d, l: l, p: p}}) do
    "#{format_trailing(team)} | #{format_number(mp)} | #{format_number(w)} | #{format_number(d)} | #{format_number(l)} | #{format_number(p)}"
  end

  defp format_trailing(team), do: String.pad_trailing(team, 30)
  defp format_number(n), do: String.pad_leading(to_string(n), 2)
end
