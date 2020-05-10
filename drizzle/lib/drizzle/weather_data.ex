defmodule Drizzle.WeatherData do
  @moduledoc """
  Updated by Weather module. Contains stored array of recent weather data.
  """
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    state = for _n <- 1..12, do: nil

    {:ok, state}
  end

  def update(next_24_hours) do
    GenServer.call(__MODULE__, {:update, next_24_hours})
  end

  def reset() do
    GenServer.call(__MODULE__, :reset)
  end

  def current_state() do
    GenServer.call(__MODULE__, :current_state)
  end

  def handle_call({:update, next_24_hours}, _from, state) do
    state = Enum.slice(state, 1..12) ++ next_24_hours
    {:reply, :ok, state}
  end

  def handle_call(:reset, _from, _state) do
    {:reply, :ok, []}
  end

  def handle_call(:current_state, _from, state) do
    {:reply, state, state}
  end
end
