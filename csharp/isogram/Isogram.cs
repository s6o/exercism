using System.Text.RegularExpressions;

public static partial class Isogram
{
    public static bool IsIsogram(string word) =>
        word.ToLower().Where(char.IsLetter).ToHashSet().Count == word.ToLower().Count(char.IsLetter);

    public static bool IsIsogram1st(string word)
    {
        var cleaned = new Regex(@"\s+|\-+").Replace(word.ToLower(), "");
        return cleaned.ToHashSet().Count == cleaned.Length;
    }

    // With compile time generated Regex
    public static bool IsIsogram2nd(string word)
    {
        var cleaned = MyRegex().Replace(word.ToLower(), "");
        return cleaned.ToHashSet().Count == cleaned.Length;
    }

    [GeneratedRegex(@"\s+|\-+")]
    private static partial Regex MyRegex();

}
