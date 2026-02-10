class WeighingMachine
{
    private double _weight;

    public int Precision { get; init; }

    public double Weight
    {
        get { return _weight; }
        set { _weight = value >= 0 ? value : throw new ArgumentOutOfRangeException(); }
    }

    public double TareAdjustment { get; set; } = 5.0;

    public string DisplayWeight
    {
        get { return String.Format("{0:N" + Precision.ToString() + "}", _weight - TareAdjustment) + " kg"; }
    }

    public WeighingMachine(int precision)
    {
        Precision = precision;
    }
}
