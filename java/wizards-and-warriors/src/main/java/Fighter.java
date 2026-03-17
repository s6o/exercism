class Fighter {

    boolean isVulnerable() {
        return true;
    }

    int getDamagePoints(Fighter fighter) {
        return 1;
    }
}

class Warrior extends Fighter {
    @Override
    boolean isVulnerable() {
        return false;
    }

    @Override
    int getDamagePoints(Fighter fighter) {
        return fighter.isVulnerable() ? 10 : 6;
    }

    @Override
    public String toString() {
        return "Fighter is a Warrior";
    }
}

class Wizard extends Fighter {
    private boolean hasSpell = false;

    @Override
    boolean isVulnerable() {
        return !hasSpell;
    }

    @Override
    int getDamagePoints(Fighter fighter) {
        return hasSpell ? 12 : 3;
    }

    void prepareSpell() {
        this.hasSpell = true;
    }

    @Override
    public String toString() {
        return "Fighter is a Wizard";
    }
}
