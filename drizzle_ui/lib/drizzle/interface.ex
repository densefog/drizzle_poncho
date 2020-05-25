defmodule Drizzle.DrizzleInterface do
  alias Drizzle.IO, as: DrizzleIO
  alias Drizzle.TodaysEvents, as: DrizzleTodaysEvents

  def deactivate_zone(zone) do
    DrizzleIO.deactivate_zone(zone.atom)
  end

  def activate_zone_for_time(zone, minutes) do
    DrizzleIO.activate_zone_for_time(zone, minutes)
  end

  def todays_events_current_state() do
    DrizzleTodaysEvents.current_state()
  end
end
