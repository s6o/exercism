public class RemoteControlCar
{
    private int batteryPercentage = 100;
    private int distanceDrivenInMeters = 0;
    private string[] sponsors = [];
    private int latestSerialNum = 0;

    public void Drive()
    {
        if (batteryPercentage > 0)
        {
            batteryPercentage -= 10;
            distanceDrivenInMeters += 2;
        }
    }

    public void SetSponsors(params string[] sponsors) => this.sponsors = [.. sponsors];

    public string DisplaySponsor(int sponsorNum) => sponsors[sponsorNum] ?? "";

    public bool GetTelemetryData(ref int serialNum, out int batteryPercentage, out int distanceDrivenInMeters)
    {
        switch (latestSerialNum)
        {
            case int ls when serialNum > ls:
                latestSerialNum = serialNum;
                batteryPercentage = this.batteryPercentage;
                distanceDrivenInMeters = this.distanceDrivenInMeters;
                return true;

            default:
                serialNum = latestSerialNum;
                batteryPercentage = -1;
                distanceDrivenInMeters = -1;
                return false;
        }
    }

    public static RemoteControlCar Buy() => new();
}

public class TelemetryClient(RemoteControlCar car)
{
    private readonly RemoteControlCar car = car;

    public string GetBatteryUsagePerMeter(int serialNum) => car.GetTelemetryData(ref serialNum, out int batteryPercentage, out int distance) switch
    {
        true when distance > 0 => $"usage-per-meter={(100 - batteryPercentage) / distance}",
        _ => "no data"
    };
}
