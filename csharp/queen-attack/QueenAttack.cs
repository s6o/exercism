public class Queen
{
    public Queen(int row, int column)
    {
        if (row < 0 || row > 7 || column < 0 || column > 7) throw new ArgumentOutOfRangeException();
        Row = row;
        Column = column;
    }

    public int Row { get; }
    public int Column { get; }
}

public static class QueenAttack
{
    public static bool CanAttack(Queen white, Queen black) => (white, black) switch
    {
        (Queen w, Queen b) when w.Row == b.Row || w.Column == b.Column => true,
        (Queen w, Queen b) when Math.Abs(w.Row - b.Row) == Math.Abs(w.Column - b.Column) => true,
        _ => false
    };

    public static Queen Create(int row, int column) => new(row, column);
}