public static class Gigasecond
{
    public static DateTime Add(DateTime moment)
    {
        long gs = 1000000000;
        return moment.AddSeconds(gs);
    }
}