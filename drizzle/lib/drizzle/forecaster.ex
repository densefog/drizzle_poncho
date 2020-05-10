defmodule Drizzle.Forecaster do
  @moduledoc """
  Scheduler for weather forecast checking, calls
  Weather to communicate to service and that
  sends results to WeatehrData for storage.
  """
  use GenServer
  alias Drizzle.Weather

  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.info("Starting forecaster")
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.info("Checking weather forecast")
    # Get the forecast from Darksky and update the Agent
    Weather.get_todays_forecast()

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # Every Hour
    Process.send_after(self(), :work, 60 * 60 * 1000)
  end
end
