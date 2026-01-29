public static class LogAnalysis
{
    public static string SubstringAfter(this string str, string substr)
    {
        return str[(str.IndexOf(substr) + substr.Length)..];
    }

    public static string SubstringBetween(this string str, string s1, string s2)
    {
        return str[..str.IndexOf(s2)].SubstringAfter(s1);
    }

    public static string Message(this string str)
    {
        return str.SubstringAfter("]:").Trim();
    }

    public static string LogLevel(this string str)
    {
        return str.SubstringBetween("[", "]:");
    }
}