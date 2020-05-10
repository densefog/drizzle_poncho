defmodule Drizzle.TodaysEvents do
  @moduledoc """
  Module generates list of on/off times for schedule
  """
  use GenServer

  require Logger

  @available_watering_times Application.get_env(:drizzle, :available_watering_times, %{})

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    Logger.info("Initializing todays events")
    Agent.start_link(fn -> [] end, name: __MODULE__)

    {:ok, state}
  end

  def update(today) do
    Agent.update(__MODULE__, fn _state ->
      calculate_start_stop_time(today)
    end)
  end

  def reset do
    Agent.update(__MODULE__, fn _state -> [] end)
  end

  def current_state() do
    Agent.get(__MODULE__, fn state -> state end)
  end

  defp calculate_start_stop_time(today) do
    Enum.group_by(today, fn {_z, avail, _d} -> avail end)
    |> Enum.map(fn {key, list} -> reduce_event_groups(key, list) end)
    |> Enum.reduce([], fn m, acc -> acc ++ m[:events] end)
  end

  defp reduce_event_groups(key, list) do
    factor = Drizzle.Weather.weather_adjustment_factor()
    Logger.info("Weather factor: #{inspect(factor)}")
    {start_time, _stop_time} = Map.get(@available_watering_times, key)

    Enum.reduce(list, %{last_time: start_time, events: []}, fn {zone, _grp, duration}, acc ->
      new_start_event = {acc[:last_time], :on, zone}
      duration = Kernel.trunc(duration * factor)
      new_start = add_duration(acc[:last_time], duration)
      acc = Map.put(acc, :last_time, new_start)
      new_stop_event = {acc[:last_time], :off, zone}
      new_stop = add_duration(acc[:last_time], 1)
      acc = Map.put(acc, :last_time, new_stop)
      update_in(acc[:events], &(&1 ++ [new_start_event, new_stop_event]))
    end)
  end

  defp add_duration(time, duration) do
    hour = Integer.floor_div(time, 100)
    minutes = Integer.mod(time, 100)
    {:ok, nt} = Time.new(hour, minutes, 0, 0)
    nt = Time.add(nt, duration * 60, :second)
    nt.hour * 100 + nt.minute
  end
end
