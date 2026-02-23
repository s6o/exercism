public class SpaceAge
{
    private double earthYearSecs = 31557600.00;
    private double ageSeconds;

    private double InYears(double coefficient) => Math.Round((ageSeconds / earthYearSecs) / coefficient, 2);

    public SpaceAge(int seconds) => ageSeconds = seconds;

    public double OnEarth() => InYears(1.0);

    public double OnMercury() => InYears(0.2408467);

    public double OnVenus() => InYears(0.61519726);

    public double OnMars() => InYears(1.8808158);

    public double OnJupiter() => InYears(11.862615);

    public double OnSaturn() => InYears(29.447498);

    public double OnUranus() => InYears(84.016846);

    public double OnNeptune() => InYears(164.79132);
}