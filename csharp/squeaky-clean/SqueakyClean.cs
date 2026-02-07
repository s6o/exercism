using System.Text;

public static class Identifier
{
    public static string Clean(string identifier)
    {
        if (string.IsNullOrWhiteSpace(identifier)) return "";
        var sb = new StringBuilder();
        var chars = identifier.ToCharArray();
        (char, char) greek = ('α', 'ω');

        var toCamelCase = false;

        foreach (var (ch, index) in chars.Select((ch, index) => (ch, index)))
        {
            if (toCamelCase)
            {
                sb.Append(Char.ToUpper(ch));
                toCamelCase = false;
                continue;
            }
            if (Char.IsWhiteSpace(ch))
            {
                sb.Append('_');
                continue;
            }
            if (Char.IsControl(ch))
            {
                sb.Append("CTRL");
                continue;
            }
            if (ch == '-' && index < chars.Length - 1 && Char.IsLetter(chars[index + 1]))
            {
                toCamelCase = true;
                continue;
            }
            if (ch >= greek.Item1 && ch <= greek.Item2) continue;
            if (!Char.IsLetter(ch)) continue;
            sb.Append(ch);
        }

        return sb.ToString();
    }
}
