public static class ProteinTranslation
{
    private static Dictionary<string, string> codons = new() {
        { "AUG", "Methionine" },
        { "UUU", "Phenylalanine" },
        { "UUC", "Phenylalanine" },
        { "UUA", "Leucine" },
        { "UUG", "Leucine" },
        { "UCU", "Serine" },
        { "UCC", "Serine" },
        { "UCA", "Serine" },
        { "UCG", "Serine" },
        { "UAU", "Tyrosine" },
        { "UAC", "Tyrosine" },
        { "UGU", "Cysteine" },
        { "UGC", "Cysteine" },
        { "UGG", "Tryptophan" },
    };
    private static HashSet<string> stops = new() { "UAA", "UAG", "UGA" };

    public static string[] Proteins(string strand)
    {
        if (strand.Length < 3) return [];
        string[] acids = [];
        var chars = strand.ToArray();
        var index = 0;
        var slice = string.Empty;
        while (index < chars.Length)
        {
            if (slice.Length < 3) slice += chars[index];
            if (slice.Length == 3)
            {
                if (codons.TryGetValue(slice, out var value)) acids = [.. acids, value];
                if (stops.Contains(slice)) break;
                slice = string.Empty;
            }
            index += 1;
        }
        return acids;
    }
}