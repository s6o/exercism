public class WeatherStation
{
    private Reading reading;
    private List<DateTime> recordDates = [];
    private List<decimal> temperatures = [];

    public void AcceptReading(Reading reading)
    {
        this.reading = reading;
        recordDates.Add(DateTime.Now);
        temperatures.Add(reading.Temperature);
    }

    public void ClearAll()
    {
        reading = new Reading();
        recordDates.Clear();
        temperatures.Clear();
    }

    public decimal LatestTemperature => reading.Temperature;

    public decimal LatestPressure => reading.Pressure;

    public decimal LatestRainfall => reading.Rainfall;

    public bool HasHistory => recordDates.Count > 1;

    public Outlook ShortTermOutlook => reading switch
    {
        Reading r when r.Equals(new Reading()) => throw new ArgumentException(),
        Reading r when r.Pressure < 10m && r.Temperature < 30m => Outlook.Cool,
        Reading r when r.Temperature > 50 => Outlook.Good,
        _ => Outlook.Warm
    };

    public Outlook LongTermOutlook => reading switch
    {
        Reading r when r.WindDirection == WindDirection.Southerly
            || r.WindDirection == WindDirection.Easterly
            && r.Temperature > 20 => Outlook.Good,
        Reading r when r.WindDirection == WindDirection.Northerly => Outlook.Cool,
        Reading r when r.WindDirection == WindDirection.Easterly
            && r.Temperature <= 20 => Outlook.Warm,
        Reading r when r.WindDirection == WindDirection.Westerly => Outlook.Rainy,
        _ => throw new ArgumentException()
    };

    public State RunSelfTest() => reading.Equals(new Reading()) ? State.Bad : State.Good;
}

/*** Please do not modify this struct ***/
public struct Reading
{
    public decimal Temperature { get; }
    public decimal Pressure { get; }
    public decimal Rainfall { get; }
    public WindDirection WindDirection { get; }

    public Reading(decimal temperature, decimal pressure,
        decimal rainfall, WindDirection windDirection)
    {
        Temperature = temperature;
        Pressure = pressure;
        Rainfall = rainfall;
        WindDirection = windDirection;
    }
}

/*** Please do not modify this enum ***/
public enum State
{
    Good,
    Bad
}

/*** Please do not modify this enum ***/
public enum Outlook
{
    Cool,
    Rainy,
    Warm,
    Good
}

/*** Please do not modify this enum ***/
public enum WindDirection
{
    Unknown, // default
    Northerly,
    Easterly,
    Southerly,
    Westerly
}
