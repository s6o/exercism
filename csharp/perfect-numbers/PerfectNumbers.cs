public enum Classification
{
    Perfect = 0,
    Abundant = 1,
    Deficient = -1
}

public static class PerfectNumbers
{
    private static int[] Divisors(int number)
    {
        var searchRange = Enumerable.Range(1, (int)number / 2);
        return searchRange.Aggregate<int, int[]>([], (acc, sn) => number % sn == 0 ? [.. acc, sn] : acc);
    }

    public static Classification Classify(int number) =>
        number > 0 ? (Classification)Divisors(number).Sum().CompareTo(number) : throw new ArgumentOutOfRangeException();

    public static Classification ClassifyInitial(int number) => number switch
    {
        int n when n > 0 && Divisors(n).Sum() == number => Classification.Perfect,
        int n when n > 0 && Divisors(n).Sum() > number => Classification.Abundant,
        int n when n > 0 && Divisors(n).Sum() < number => Classification.Deficient,
        _ => throw new ArgumentOutOfRangeException()
    };
}
