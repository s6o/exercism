public static class CollatzConjecture
{
    public static int Steps(int number)
    {
        if (number < 1) throw new ArgumentOutOfRangeException();
        var count = 0;
        while (number != 1)
        {
            number = int.IsEvenInteger(number) ? number / 2 : number * 3 + 1;
            count += 1;
        }
        return count;
    }
}