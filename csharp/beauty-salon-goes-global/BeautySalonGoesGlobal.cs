using System.Globalization;
using System.Runtime.InteropServices;

public enum Location
{
    NewYork,
    London,
    Paris
}

public enum AlertLevel
{
    Early,
    Standard,
    Late
}

public static class Appointment
{
    private static CultureInfo GetLocationCultureInfo(Location location) => new CultureInfo(location switch
    {
        Location.NewYork => "en-US",
        Location.London => "en-GB",
        Location.Paris => "fr-FR",
        _ => "en-US"
    });
    private static string GetLocationTimeZoneId(Location location) => location switch
    {
        Location.NewYork when RuntimeInformation.IsOSPlatform(OSPlatform.Windows) => "Eastern Standard Time",
        Location.NewYork => "America/New_York",
        Location.London when RuntimeInformation.IsOSPlatform(OSPlatform.Windows) => "GMT Standard Time",
        Location.London => "Europe/London",
        Location.Paris when RuntimeInformation.IsOSPlatform(OSPlatform.Windows) => "W. Europe Standard Time",
        Location.Paris => "Europe/Paris",
        _ when RuntimeInformation.IsOSPlatform(OSPlatform.Windows) => "Eastern Standard Time",
        _ => "America/New_York",
    };

    public static DateTime ShowLocalTime(DateTime dtUtc) => dtUtc.ToLocalTime();

    public static DateTime Schedule(string appointmentDateDescription, Location location)
    {
        DateTime dtLocal = DateTime.Parse(appointmentDateDescription);//, GetLocationCultureInfo(location));
        TimeZoneInfo tzi = TimeZoneInfo.FindSystemTimeZoneById(GetLocationTimeZoneId(location));
        return TimeZoneInfo.ConvertTimeToUtc(dtLocal, tzi);
    }

    public static DateTime GetAlertTime(DateTime appointment, AlertLevel alertLevel)
    {
        return alertLevel switch
        {
            AlertLevel.Early => appointment.AddDays(-1),
            AlertLevel.Standard => appointment.AddMinutes(-105),
            AlertLevel.Late => appointment.AddMinutes(-30),
            _ => appointment
        };
    }

    public static bool HasDaylightSavingChanged(DateTime dt, Location location)
    {
        TimeZoneInfo ti = TimeZoneInfo.FindSystemTimeZoneById(GetLocationTimeZoneId(location));
        return ti.IsDaylightSavingTime(dt) != ti.IsDaylightSavingTime(dt.AddDays(-7));
    }

    public static DateTime NormalizeDateTime(string dtStr, Location location)
    {
        try
        {
            return DateTime.Parse(dtStr, GetLocationCultureInfo(location));
        }
        catch (FormatException)
        {
            return DateTime.MinValue;
        }
    }
}
