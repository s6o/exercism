public struct Coord(ushort x, ushort y)
{
    public ushort X { get; } = x;
    public ushort Y { get; } = y;
    public bool Equals(Coord other) => X == other.X && Y == other.Y;
}

public struct Plot(Coord topLeft, Coord topRight, Coord btmLeft, Coord btmRight)
{
    public Coord TopLeft { get; } = topLeft;
    public Coord TopRight { get; } = topRight;
    public Coord BottomLeft { get; } = btmLeft;
    public Coord BottomRight { get; } = btmRight;

    public bool Equals(Plot other) => TopLeft.Equals(other.TopLeft) && TopRight.Equals(other.TopRight) && BottomLeft.Equals(other.BottomLeft) && BottomRight.Equals(other.BottomRight);
}


public class ClaimsHandler
{
    private HashSet<Plot> claims = [];

    private int MaxSide(Plot p) => new int[]
    {
        Math.Abs(p.TopLeft.X - p.TopRight.X),
        Math.Abs(p.BottomLeft.X - p.BottomRight.X),
        Math.Abs(p.TopLeft.Y - p.BottomLeft.Y),
        Math.Abs(p.TopRight.Y - p.BottomRight.Y),
    }.Max();

    public void StakeClaim(Plot plot) => claims.Add(plot);

    public bool IsClaimStaked(Plot plot) => claims.Contains(plot);

    public bool IsLastClaim(Plot plot) => claims.Last().Equals(plot);

    public Plot GetClaimWithLongestSide() => claims.Aggregate(claims.First(), (current, plot) => MaxSide(plot) > MaxSide(current) ? plot : current);
}
