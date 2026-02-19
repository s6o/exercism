public static class ReverseString
{
    public static string Reverse(string input) => input.Aggregate("", (r, s) => s + r);
}