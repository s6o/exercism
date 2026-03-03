public static class SquareRoot
{
    public static int Root(int number)
    {
        if (number < 1) throw new ArgumentOutOfRangeException();
        if (number == 1) return number;
        (int lower, int upper) search = (lower: 0, upper: number);
        while (search.lower != search.upper - 1)
        {
            int mid = (search.lower + search.upper) / 2;
            search = (mid * mid <= number) switch
            {
                false => (lower: search.lower, upper: mid),
                true => (lower: mid, upper: search.upper),
            }
            ;
        }
        return search.lower;
    }
}
