class RemoteControlCar
{
    private int _battery;

    private int _distance;
    public int BatteryDrain { get; init; }
    public int Speed { get; init; }

    public RemoteControlCar(int speed, int batteryDrain)
    {
        _battery = 100;
        BatteryDrain = batteryDrain;
        Speed = speed;
    }

    public int Battery() => _battery;

    public bool BatteryDrained() => _battery < BatteryDrain;

    public int DistanceDriven() => _distance;

    public void Drive()
    {
        if (BatteryDrained()) return;
        _distance += Speed;
        _battery -= BatteryDrain;
    }

    public static RemoteControlCar Nitro()
    {
        return new RemoteControlCar(50, 4);
    }
}

class RaceTrack
{
    private int _distance;

    public RaceTrack(int distance) => _distance = distance;

    public bool TryFinishTrack(RemoteControlCar car)
    {
        if (car.BatteryDrained()) return false;

        int maxDistanceLeft = car.Battery() / car.BatteryDrain * car.Speed;
        return maxDistanceLeft >= _distance;
    }
}
