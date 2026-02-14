public class RemoteControlCar
{
    private enum SpeedUnits
    {
        MetersPerSecond,
        CentimetersPerSecond
    }

    private struct Speed
    {
        public decimal Amount { get; }
        public SpeedUnits SpeedUnits { get; }

        public Speed(decimal amount, SpeedUnits speedUnits)
        {
            Amount = amount;
            SpeedUnits = speedUnits;
        }

        public override string ToString()
        {
            string unitsString = "meters per second";
            if (SpeedUnits == SpeedUnits.CentimetersPerSecond)
            {
                unitsString = "centimeters per second";
            }

            return Amount + " " + unitsString;
        }
    }

    public interface ITelemetry
    {
        public void Calibrate();
        public bool SelfTest();
        public void ShowSponsor(string sponsorName);
        public void SetSpeed(decimal amount, string unitsString);
    }

    private class DefaultTelemetry(RemoteControlCar car) : ITelemetry
    {
        private RemoteControlCar car { get; init; } = car;

        public void Calibrate() { }

        public bool SelfTest() => true;

        public void ShowSponsor(string sponsorName) => car.CurrentSponsor = sponsorName;

        public void SetSpeed(decimal amount, string unitsString)
        {
            SpeedUnits speedUnits = SpeedUnits.MetersPerSecond;
            if (unitsString == "cps")
            {
                speedUnits = SpeedUnits.CentimetersPerSecond;
            }
            car.currentSpeed = new Speed(amount, speedUnits);
        }
    }

    public ITelemetry Telemetry;

    public RemoteControlCar() => Telemetry = new DefaultTelemetry(this);

    public string CurrentSponsor { get; private set; } = "";

    private Speed currentSpeed;

    public string GetSpeed()
    {
        return currentSpeed.ToString();
    }
}

