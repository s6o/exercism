public interface IRemoteControlCar
{
    public int DistanceTravelled { get; }
    public void Drive();
};

public class ProductionRemoteControlCar : IRemoteControlCar, IComparable
{
    public int DistanceTravelled { get; private set; }
    public int NumberOfVictories { get; set; }

    public void Drive()
    {
        DistanceTravelled += 10;
    }

    public int CompareTo(object? other) => NumberOfVictories switch
    {
        _ when other == null => 1,
        int d when d < (other as ProductionRemoteControlCar)!.NumberOfVictories => -1,
        int d when d > (other as ProductionRemoteControlCar)!.NumberOfVictories => 1,
        _ => 0
    };
}

public class ExperimentalRemoteControlCar : IRemoteControlCar
{
    public int DistanceTravelled { get; private set; }

    public void Drive()
    {
        DistanceTravelled += 20;
    }
}

public static class TestTrack
{
    public static void Race(IRemoteControlCar car) => car.Drive();

    public static List<ProductionRemoteControlCar> GetRankedCars(ProductionRemoteControlCar prc1, ProductionRemoteControlCar prc2) => [.. new[] { prc1, prc2 }.Order()];
}
