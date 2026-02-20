public static class Raindrops
{
    public static string Convert(int number)
    {
        var result = "";
        if (number % 3 == 0) result += "Pling";
        if (number % 5 == 0) result += "Plang";
        if (number % 7 == 0) result += "Plong";
        return result == "" ? number.ToString() : result;
    }

    public static string ConvertF(int number)
    {
        var sounds = new List<(int, string)> {
            (3, "Pling"),
            (5, "Plang"),
            (7, "Plong")
        }.Select((t) => number % t.Item1 == 0 ? t.Item2 : "").Aggregate("", (acc, s) => acc + s);
        return String.IsNullOrWhiteSpace(sounds) ? number.ToString() : sounds;
    }
}