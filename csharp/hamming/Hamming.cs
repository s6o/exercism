public static class Hamming
{
    public static int Distance(string firstStrand, string secondStrand) =>
        firstStrand.Length != secondStrand.Length ? throw new ArgumentException() : firstStrand.Zip(secondStrand).Count(t => t.First != t.Second);
}