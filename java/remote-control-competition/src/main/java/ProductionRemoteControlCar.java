class ProductionRemoteControlCar implements RemoteControlCar, Comparable<ProductionRemoteControlCar> {
    private int distance = 0;
    private int victories = 0;

    @Override
    public void drive() {
        this.distance += 10;
    }

    @Override
    public int getDistanceTravelled() {
        return this.distance;
    }

    public int getNumberOfVictories() {
        return this.victories;
    }

    public void setNumberOfVictories(int numberOfVictories) {
        this.victories = numberOfVictories;
    }

    @Override
    public int compareTo(ProductionRemoteControlCar other) {
        return Integer.compare(other.victories, this.victories);
    }
}
