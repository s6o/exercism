abstract class Character
{
    private string _characterType;
    protected Character(string characterType)
    {
        _characterType = characterType;
    }

    public abstract int DamagePoints(Character target);

    public virtual bool Vulnerable() => false;

    public override string ToString() => $"Character is a {_characterType}";
}

class Warrior : Character
{
    public Warrior() : base("Warrior") { }

    public override int DamagePoints(Character target) => target.Vulnerable() ? 10 : 6;
}

class Wizard : Character
{
    private bool _hasSpell = false;
    public Wizard() : base("Wizard") { }

    public override int DamagePoints(Character target)
    {
        var points = _hasSpell ? 12 : 3;
        _hasSpell = false;
        return points;
    }

    public override bool Vulnerable() => _hasSpell == false;

    public void PrepareSpell() => _hasSpell = true;
}
