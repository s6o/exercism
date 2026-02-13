using System.Text.RegularExpressions;

public class LogParser
{
    private string isLogPattern = @"^\[(TRC|DBG|INF|WRN|ERR|FTL)\].+$";
    private string splitPattern = @"\<[\^\*=-]*\>";
    private string pwdPattern = @"(?i)\""password\""";
    private string eofPattern = @"end-of-line\d+";
    private string weakPattern = @"(?i)(\bpassword\w+\b?)";

    public bool IsValidLine(string text) => new Regex(isLogPattern).IsMatch(text);

    public string[] SplitLogLine(string text) => Regex.Split(text, splitPattern);

    public int CountQuotedPasswords(string lines) => Regex.Split(lines, pwdPattern).Count();

    public string RemoveEndOfLineText(string line) => Regex.Replace(line, eofPattern, string.Empty);

    public string[] ListLinesWithPasswords(string[] lines) =>
        lines.Aggregate([], (string[] acc, string line) => [.. acc, Regex.Matches(line, weakPattern).Aggregate($"--------: {line}", (string acc, Match m) => $"{m.Value}: {line}")]);
}
