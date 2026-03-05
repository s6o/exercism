using Xunit.Internal;

public enum Direction
{
    North,
    East,
    South,
    West
}

public class RobotSimulator(Direction direction, int x, int y)
{
    public Direction Direction { get; private set; } = direction;
    public int X { get; private set; } = x;
    public int Y { get; private set; } = y;

    public void Move(string instructions) => instructions.ForEach((ch) =>
    {
        switch (ch)
        {
            case 'R':
                Direction = (Direction)(((int)this.Direction + 1) % 4);
                break;
            case 'L':
                Direction = (Direction)(((int)this.Direction + 3) % 4);
                break;
            case 'A':
                X = Direction switch
                {
                    Direction.East => X + 1,
                    Direction.West => X - 1,
                    _ => X
                };
                Y = Direction switch
                {
                    Direction.North => Y + 1,
                    Direction.South => Y - 1,
                    _ => Y
                };
                break;
            default:
                break;
        }
    });
}