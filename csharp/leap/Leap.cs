public static class Leap
{
    public static bool IsLeapYear(int year) => year switch
    {
        int y when y % 4 == 0 && y % 100 != 0 => true,
        int y when y % 400 == 0 => true,
        _ => false
    };
}