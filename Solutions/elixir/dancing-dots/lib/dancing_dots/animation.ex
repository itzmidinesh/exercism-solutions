defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot, frame_number, opts) :: dot

  defmacro __using__(_opts) do
    quote do
      @behaviour DancingDots.Animation

      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) do
    case rem(frame_number, 4) do
      0 -> %{dot | opacity: dot.opacity / 2}
      _ -> dot
    end
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    case Keyword.fetch(opts, :velocity) do
      {:ok, velocity} when is_number(velocity) ->
        {:ok, opts}

      {:ok, velocity} ->
        {:error,
         "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}

      :error ->
        {:error, "The :velocity option is required, and its value must be a number. Got: nil"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, opts) do
    velocity = Keyword.get(opts, :velocity, 0)
    %{dot | radius: dot.radius + (frame_number - 1) * velocity}
  end
end
