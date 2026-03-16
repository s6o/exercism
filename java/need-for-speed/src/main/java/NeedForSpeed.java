class NeedForSpeed {
    private int battery;
    private int batteryDrain;
    private int driven;
    private int speed;

    NeedForSpeed(int speed, int batteryDrain) {
        this.battery = 100;
        this.batteryDrain = batteryDrain;
        this.driven = 0;
        this.speed = speed;
    }

    public boolean batteryDrained() {
        return battery < batteryDrain;
    }

    public int distanceDriven() {
        return driven;
    }

    public int distanceLeft() {
        return (battery / batteryDrain) * speed;
    }

    public void drive() {
        if (battery >= batteryDrain) {
            battery -= batteryDrain;
            driven += speed;
        }
    }

    public static NeedForSpeed nitro() {
        return new NeedForSpeed(50, 4);
    }
}

class RaceTrack {
    private int distance;

    RaceTrack(int distance) {
        this.distance = distance;
    }

    public boolean canFinishRace(NeedForSpeed car) {
        return !car.batteryDrained() && car.distanceLeft() >= distance;
    }
}
