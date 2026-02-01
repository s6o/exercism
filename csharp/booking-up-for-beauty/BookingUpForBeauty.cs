using System.Globalization;

static class Appointment
{
    public static DateTime Schedule(string appointmentDateDescription)
    {
        return DateTime.Parse(appointmentDateDescription);
    }

    public static bool HasPassed(DateTime appointmentDate)
    {
        return appointmentDate.ToUniversalTime() < DateTime.Now.ToUniversalTime();
    }

    public static bool IsAfternoonAppointment(DateTime appointmentDate)
    {
        return appointmentDate.TimeOfDay.Hours >= 12 && appointmentDate.TimeOfDay.Hours < 18;
    }

    public static string Description(DateTime appointmentDate)
    {
        string dstr = appointmentDate.ToString("d", CultureInfo.CreateSpecificCulture("en-US"));
        string tstr = appointmentDate.ToString("T", CultureInfo.CreateSpecificCulture("en-US"));
        return $"You have an appointment on {dstr} {tstr}.";
    }

    public static DateTime AnniversaryDate()
    {
        int year = DateTime.Now.Year;
        return new DateTime(year, 9, 15, 0, 0, 0);
    }
}
