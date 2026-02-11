using System.Globalization;

public static class HighSchoolSweethearts
{
    private static string template = @"
    ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     {0}. {1}.  +  {2}. {3}.     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
    ";
    public static string DisplaySingleLine(string studentA, string studentB) =>
        String.Format("{0,29} ♡ {1,-29}", studentA, studentB);

    public static string DisplayBanner(string studentA, string studentB)
    {
        string[] args = [
            .. studentA.Trim().Split(' ').Select(n => n[0..1]),
            .. studentB.Trim().Split(' ').Select(n => n[0..1])
        ];
        return String.Format(template, args);
    }

    public static string DisplayGermanExchangeStudents(string studentA
        , string studentB, DateTime start, float hours)
    {
        var template = "{0} and {1} have been dating since {2:d} - that's {3:N2} hours";
        return string.Format(new CultureInfo("de-DE"), template, studentA, studentB, start, hours);
    }
}
