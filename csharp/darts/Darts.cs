public static class Darts
{
    public static int Score(double x, double y) => (x, y) switch
    {
        (var px, var py) when (Math.Pow(px, 2) + Math.Pow(py, 2)) <= Math.Pow(1, 2) => 10,
        (var px, var py) when (Math.Pow(px, 2) + Math.Pow(py, 2)) <= Math.Pow(5, 2) => 5,
        (var px, var py) when (Math.Pow(px, 2) + Math.Pow(py, 2)) <= Math.Pow(10, 2) => 1,
        _ => 0
    };
}
