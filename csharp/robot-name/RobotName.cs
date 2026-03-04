public class Robot
{
    private static Dictionary<int, (string name, bool taken)> names = AssignableNames();
    private static Random rnd = new Random();
    private string name;

    private static Dictionary<int, (string name, bool taken)> AssignableNames()
    {
        Dictionary<int, (string name, bool taken)> names = new();
        var index = 0;
        for (var l1 = 65; l1 <= 90; l1++)
        {
            for (var l2 = 65; l2 <= 90; l2++)
            {
                for (var nums = 0; nums <= 999; nums++)
                {
                    var name = $"{Convert.ToChar(l1)}{Convert.ToChar(l2)}{nums:000}";
                    names[index] = (name: name, taken: false);
                    index += 1;
                }
            }
        }
        return names;
    }

    private string FindName()
    {
        int index;
        var tries = 0;
        do
        {
            index = rnd.Next(0, names.Count);
            tries += 1;
        } while (names[index].taken || tries >= names.Count);
        if (tries >= names.Count)
        {
            throw new ArgumentOutOfRangeException("Name pool exausted.");
        }
        names[index] = (names[index].name, taken: true);
        return names[index].name;
    }

    public Robot() => name = FindName();

    public string Name { get => name; }

    public void Reset() => name = FindName();
}