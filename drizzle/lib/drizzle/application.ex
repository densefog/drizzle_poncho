defmodule Drizzle.Application do
  @moduledoc """
  Main application for Drizzle
  """
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Drizzle.Supervisor]
    Supervisor.start_link(children(target()), opts)
  end

  # List all child processes to be supervised
  def children(_target) do
    [
      # Starts a worker by calling: Drizzle.Worker.start_link(arg)
      {Drizzle.WeatherData, []},
      {Drizzle.IO, %{}},
      {Drizzle.Scheduler, %{}},
      {Drizzle.Forecaster, %{}},
      {Drizzle.TodaysEvents, []}
    ]
  end

  def target() do
    Application.get_env(:drizzle, :target)
  end
end
