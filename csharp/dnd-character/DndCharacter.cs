public class DndCharacter
{
    private static Random rnd = new();

    public int Strength { get; }
    public int Dexterity { get; }
    public int Constitution { get; }
    public int Intelligence { get; }
    public int Wisdom { get; }
    public int Charisma { get; }
    public int Hitpoints { get; }

    public DndCharacter()
    {
        Strength = Ability();
        Dexterity = Ability();
        Constitution = Ability();
        Intelligence = Ability();
        Wisdom = Ability();
        Charisma = Ability();
        Hitpoints = 10 + Modifier(Constitution);
    }

    public static int Modifier(int score) => (int)Math.Floor((double)(score - 10) / 2);

    public static int Ability()
    {
        var rolls = new List<int> { rnd.Next(1, 7), rnd.Next(1, 7), rnd.Next(1, 7), rnd.Next(1, 7) };
        return rolls.Sum() - rolls.Min();
    }

    public static DndCharacter Generate() => new();
}
