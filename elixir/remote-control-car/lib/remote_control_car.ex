defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct(battery_percentage: 100, distance_driven_in_meters: 0, nickname: nil)

  def new(nickname \\ "none") do
    %__MODULE__{nickname: nickname}
  end

  def display_distance(%RemoteControlCar{} = remote_car) do
    "#{remote_car.distance_driven_in_meters} meters"
  end

  def display_battery(%RemoteControlCar{battery_percentage: 0}), do: "Battery empty"
  def display_battery(%RemoteControlCar{battery_percentage: bp}), do: "Battery at #{bp}%"

  def drive(%RemoteControlCar{battery_percentage: bp, distance_driven_in_meters: dm} = rc) do
    if bp > 0 do
      %{rc | battery_percentage: bp - 1, distance_driven_in_meters: dm + 20}
    else
      rc
    end
  end
end
