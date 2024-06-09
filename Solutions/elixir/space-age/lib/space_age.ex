defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @earth_year_seconds 31_557_600

  @orbital_periods %{
    earth: 1.0,
    mercury: 0.2408467,
    venus: 0.61519726,
    mars: 1.8808158,
    jupiter: 11.862615,
    saturn: 29.447498,
    uranus: 84.016846,
    neptune: 164.79132
  }

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet', or an error if 'planet' is not a planet.
  """
  @spec age_on(planet, pos_integer) :: {:ok, float} | {:error, String.t()}
  def age_on(planet, seconds) when is_integer(seconds) and seconds > 0 do
    case Map.fetch(@orbital_periods, planet) do
      {:ok, orbital_period} ->
        age = seconds / (@earth_year_seconds * orbital_period)
        {:ok, Float.round(age, 2)}

      :error ->
        {:error, "not a planet"}
    end
  end

  def age_on(_, _), do: {:error, "invalid age"}
end
