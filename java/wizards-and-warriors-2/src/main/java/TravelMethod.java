public enum TravelMethod {
    WALKING,
    HORSEBACK;

    public String withPrefix() {
        String prefix = "";
        switch (this) {
            case WALKING:
                prefix = "by";
                break;
            case HORSEBACK:
                prefix = "on";
                break;
        }
        return prefix + " " + this.name().toLowerCase();
    }
}
