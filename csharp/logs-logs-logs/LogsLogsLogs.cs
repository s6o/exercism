enum LogLevel : int
{
    Unknown = 0,
    Trace = 1,
    Debug = 2,
    Info = 4,
    Warning = 5,
    Error = 6,
    Fatal = 42,
}

static class LogLine
{
    public static LogLevel ParseLogLevel(string logLine)
    {
        switch (logLine)
        {
            case string s when s.StartsWith("[TRC]"):
                return LogLevel.Trace;
            case string s when s.StartsWith("[DBG]"):
                return LogLevel.Debug;
            case string s when s.StartsWith("[INF]"):
                return LogLevel.Info;
            case string s when s.StartsWith("[WRN]"):
                return LogLevel.Warning;
            case string s when s.StartsWith("[ERR]"):
                return LogLevel.Error;
            case string s when s.StartsWith("[FTL]"):
                return LogLevel.Fatal;
            default:
                return LogLevel.Unknown;
        }
    }

    public static string OutputForShortLog(LogLevel logLevel, string message)
    {
        return $"{(int)logLevel}:{message}";
    }
}
