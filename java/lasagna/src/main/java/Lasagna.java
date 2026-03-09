public class Lasagna {
    private static int PREP_TIME_PER_LAYER = 2;
    private static int BAKE_TIME = 40;

    public int expectedMinutesInOven() {
        return BAKE_TIME;
    };

    public int remainingMinutesInOven(int ovenMinutes) {
        return expectedMinutesInOven() - ovenMinutes;
    }

    public int preparationTimeInMinutes(int layers) {
        return layers * PREP_TIME_PER_LAYER;
    }

    public int totalTimeInMinutes(int layers, int ovenMinutes) {
        return preparationTimeInMinutes(layers) + ovenMinutes;
    }
}
