public class CarsAssemble {
    private static int PRODUCTION_RATE = 221;

    public double productionRatePerHour(int speed) {
        if (speed >= 1 && speed <= 4) {
            return speed * PRODUCTION_RATE;
        } else if (speed >= 5 && speed <= 8) {
            return speed * PRODUCTION_RATE * 0.9;
        } else if (speed == 9) {
            return speed * PRODUCTION_RATE * 0.8;
        } else {
            return speed * PRODUCTION_RATE * 0.77;
        }
    }

    public int workingItemsPerMinute(int speed) {
        return (int) productionRatePerHour(speed) / 60;
    }
}
