# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

import_config "../../drizzle_ui/config/config.exs"

config :drizzle, target: Mix.target()

config :drizzle,
  location: %{latitude: System.get_env("LATITUDE"), longitude: System.get_env("LONGITUDE")},
  utc_offset: -4,
  winter_months: [:jan, :feb, :mar, :apr, :nov, :dec],
  # winter_months: [],
  soil_moisture_sensor: nil,
  # soil_moisture_sensor: %{pin: 26, min: 0, max: 539},
  zone_pins: %{
    zone1: 4,
    zone2: 17,
    zone3: 27,
    zone4: 22,
    zone5: 18,
    zone6: 23,
    zone7: 24,
    zone8: 14
  },
  # watering times are defined as key {start_time, end_time}
  available_watering_times: %{
    # morning: {500, 700},
    evening: {700, 2300}
  },
  # schedule is defined as {zone, watering_time_key, duration_in_minutes}
  schedule: %{
    sun: [
      # {:zone1, :morning, 5},
      # {:zone2, :morning, 5},
      {:zone1, :evening, 0},
      {:zone2, :evening, 0},
      {:zone3, :evening, 0},
      {:zone4, :evening, 0},
      {:zone5, :evening, 0},
      {:zone6, :evening, 0},
      {:zone7, :evening, 0}
    ],
    mon: [
      {:zone1, :evening, 20},
      {:zone2, :evening, 20},
      {:zone3, :evening, 20},
      {:zone4, :evening, 20},
      {:zone5, :evening, 20},
      {:zone6, :evening, 20},
      {:zone7, :evening, 20}
    ],
    tue: [
      {:zone1, :evening, 0},
      {:zone2, :evening, 0},
      {:zone3, :evening, 0},
      {:zone4, :evening, 0},
      {:zone5, :evening, 0},
      {:zone6, :evening, 0},
      {:zone7, :evening, 0}
    ],
    wed: [
      {:zone1, :evening, 20},
      {:zone2, :evening, 20},
      {:zone3, :evening, 20},
      {:zone4, :evening, 20},
      {:zone5, :evening, 20},
      {:zone6, :evening, 20},
      {:zone7, :evening, 20}
    ],
    thu: [
      {:zone1, :evening, 0},
      {:zone2, :evening, 0},
      {:zone3, :evening, 0},
      {:zone4, :evening, 0},
      {:zone5, :evening, 0},
      {:zone6, :evening, 0},
      {:zone7, :evening, 0}
    ],
    fri: [
      {:zone1, :evening, 20},
      {:zone2, :evening, 20},
      {:zone3, :evening, 20},
      {:zone4, :evening, 20},
      {:zone5, :evening, 20},
      {:zone6, :evening, 20},
      {:zone7, :evening, 20}
    ],
    sat: [
      {:zone1, :evening, 0},
      {:zone2, :evening, 0},
      {:zone3, :evening, 0},
      {:zone4, :evening, 0},
      {:zone5, :evening, 0},
      {:zone6, :evening, 0},
      {:zone7, :evening, 0}
    ]
  }

config :darkskyx,
  api_key: System.get_env("DARKSKY_API_KEY"),
  defaults: [
    units: "us",
    lang: "en"
  ]

# Customize non-Elixir parts of the firmware.  See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1585789427"

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

if Mix.target() != :host do
  import_config "target.exs"
end

import_config "#{Mix.target()}.exs"
