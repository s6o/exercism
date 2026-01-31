public class Player
{
    private Random rnd = new Random();

    public int RollDie()
    {
        return rnd.Next(1, 19);
    }

    public double GenerateSpellStrength()
    {
        return 100 * rnd.NextDouble();
    }
}