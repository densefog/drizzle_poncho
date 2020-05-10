defmodule Drizzle.IO do
  @moduledoc """
  Module for communicating to IO, turning on zones, etc
  """

  use GenServer
  require Logger

  @gpio_module Application.get_env(:drizzle, :gpio_module, Circuits.GPIO)
  @zone_pins Application.get_env(:drizzle, :zone_pins, %{})

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    state =
      Enum.reduce(@zone_pins, state, fn {name, pin}, state ->
        {:ok, output_pid} = register_pin(pin)
        Map.put(state, name, output_pid)
      end)

    {:ok, state}
  end

  def activate_zone(zone) do
    GenServer.call(__MODULE__, {:activate_zone, zone})
  end

  def activate_zone_for_time(zone, minutes) do
    GenServer.call(__MODULE__, {:activate_zone_for_time, zone, minutes})
  end

  def deactivate_zone(zone) do
    GenServer.call(__MODULE__, {:deactivate_zone, zone})
  end

  def handle_call({:activate_zone, zone}, _from, state) do
    Logger.info("Activating zone: #{inspect(zone)}")

    with :ok <- @gpio_module.write(state[zone], 0) do
      {:noreply, state}
    end

    {:reply, :ok, state}
  end

  def handle_call({:activate_zone_for_time, zone, minutes}, _from, state)
      when is_integer(minutes) and is_atom(zone) do
    Logger.info("Activating zone '#{inspect(zone)}' for #{minutes} minutes.")

    with :ok <- @gpio_module.write(state[zone], 0) do
      {:noreply, state}
    end

    Process.send_after(self(), {:deactivate_zone, zone}, minutes * 60 * 1000)

    {:reply, :ok, state}
  end

  def handle_call({:deactivate_zone, zone}, _from, state) do
    Process.send(self(), {:deactivate_zone, zone}, [])

    {:reply, :ok, state}
  end

  def handle_info({:deactivate_zone, zone}, state) do
    Logger.info("Deactivating zone: #{inspect(zone)}")

    with :ok <- @gpio_module.write(state[zone], 1) do
      {:noreply, state}
    end
  end

  defp register_pin(pin) do
    @gpio_module.open(pin, :output, initial_value: 1)
  end

  def read_soil_moisture(_pin) do
    0
    # {:ok, gpio} = @gpio_module.open(pin, :input)
    # moisture = @gpio_module.read(gpio)
    # @gpio_module.close(gpio)
    # moisture
  end
end
