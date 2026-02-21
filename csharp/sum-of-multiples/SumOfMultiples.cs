public static class SumOfMultiples
{
    public static int Sum(IEnumerable<int> multiples, int max) =>
        multiples.Aggregate<int, int[]>([], (acc, m) =>
        {
            return m switch
            {
                _ when m > max || m <= 0 => [0, .. acc],
                _ => [
                    ..Enumerable.Range(1, max / m).Aggregate<int, int[]>([m], (acc, _) => acc[0] + m < max ? [acc[0] + m, .. acc] : acc),
                    ..acc
                ]
            };
        }).ToHashSet().Sum();
}