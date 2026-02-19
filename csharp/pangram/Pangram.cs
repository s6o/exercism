using System.Text.RegularExpressions;

public static class Pangram
{
    public static bool IsPangram(string input) =>
        new Regex(@"[^a-z]").Replace(input.ToLower(), "").ToHashSet().Count == 26;
    // Rybak's
    // "abcdefghijklmnopqrstuvwxyz".All(input.ToLower().Contains);
}
