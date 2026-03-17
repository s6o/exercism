public class LogLine {
    private String logLine = "";

    public LogLine(String logLine) {
        this.logLine = logLine;
    }

    public LogLevel getLogLevel() {
        String ll = logLine.split("]:")[0].trim().substring(1);
        return LogLevel.of(ll);
    }

    public String getOutputForShortLog() {
        return getLogLevel().level() + ":" + logLine.split("]:")[1].trim();
    }
}
