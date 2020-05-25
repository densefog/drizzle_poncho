defmodule Drizzle.MockInterface do
  def deactivate_zone(_zone), do: :ok

  def activate_zone_for_time(_zone, _minutes), do: :ok

  def todays_events_current_state(), do: []
end
