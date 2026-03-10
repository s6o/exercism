public class JedliksToyCar {
    private int distance = 0;
    private int battery = 100;
    private static int BATTERY_DRAIN = 1;
    private static int DRIVE_LENGTH = 20;

    public static JedliksToyCar buy() {
        return new JedliksToyCar();
    }

    public String distanceDisplay() {
        return "Driven " + distance + " meters";
    }

    public String batteryDisplay() {
        return battery < 1 ? "Battery empty" : "Battery at " + battery + "%";
    }

    public void drive() {
        if (battery > 0) {
            battery -= BATTERY_DRAIN;
            distance += DRIVE_LENGTH;
        }
    }
}
