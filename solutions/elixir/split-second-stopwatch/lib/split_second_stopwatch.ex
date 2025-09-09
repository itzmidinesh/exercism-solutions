defmodule SplitSecondStopwatch do
  @doc """
  A stopwatch that can be used to track lap times.
  """

  @type state :: :ready | :running | :stopped

  @type t :: %__MODULE__{
          state: state(),
          current_lap: Time.t(),
          total: Time.t(),
          previous_laps: [Time.t()]
        }

  defstruct state: :ready,
            current_lap: ~T[00:00:00],
            total: ~T[00:00:00],
            previous_laps: []

  @spec new() :: t()
  def new(), do: %__MODULE__{}

  @spec state(t()) :: state()
  def state(%__MODULE__{state: state}), do: state

  @spec current_lap(t()) :: Time.t()
  def current_lap(%__MODULE__{current_lap: current_lap}), do: current_lap

  @spec previous_laps(t()) :: [Time.t()]
  def previous_laps(%__MODULE__{previous_laps: previous_laps}), do: previous_laps

  @spec advance_time(t(), Time.t()) :: t()
  def advance_time(%__MODULE__{state: :running} = stopwatch, time) do
    new_current_lap = Time.add(stopwatch.current_lap, Time.diff(time, ~T[00:00:00], :second))
    new_total = Time.add(stopwatch.total, Time.diff(time, ~T[00:00:00], :second))

    %{stopwatch | current_lap: new_current_lap, total: new_total}
  end

  def advance_time(stopwatch, _time), do: stopwatch

  @spec total(t()) :: Time.t()
  def total(%__MODULE__{total: total}), do: total

  @spec start(t()) :: t() | {:error, String.t()}
  def start(%__MODULE__{state: :ready} = stopwatch), do: %{stopwatch | state: :running}
  def start(%__MODULE__{state: :stopped} = stopwatch), do: %{stopwatch | state: :running}

  def start(%__MODULE__{state: :running}),
    do: {:error, "cannot start an already running stopwatch"}

  @spec stop(t()) :: t() | {:error, String.t()}
  def stop(%__MODULE__{state: :running} = stopwatch), do: %{stopwatch | state: :stopped}
  def stop(%__MODULE__{}), do: {:error, "cannot stop a stopwatch that is not running"}

  @spec lap(t()) :: t() | {:error, String.t()}
  def lap(%__MODULE__{state: :running} = stopwatch) do
    new_previous_laps = stopwatch.previous_laps ++ [stopwatch.current_lap]
    %{stopwatch | previous_laps: new_previous_laps, current_lap: ~T[00:00:00]}
  end

  def lap(%__MODULE__{}), do: {:error, "cannot lap a stopwatch that is not running"}

  @spec reset(t()) :: t() | {:error, String.t()}
  def reset(%__MODULE__{state: :stopped}), do: new()
  def reset(%__MODULE__{}), do: {:error, "cannot reset a stopwatch that is not stopped"}
end
