public struct CurrencyAmount(decimal amount, string currency)
{
    private decimal amount = amount;
    private string currency = currency;

    /* Fix compiler warnings: 
     * - 'CurrencyAmount' defines operator == or operator != but does not override Object.Equals(object o)
     * - 'CurrencyAmount' defines operator == or operator != but does not override Object.GetHashCode()
     */
    public override bool Equals(object? other) => GetHashCode() == other?.GetHashCode();
    public override int GetHashCode() => HashCode.Combine(amount.GetHashCode(), currency.GetHashCode());

    public static bool operator ==(CurrencyAmount a, CurrencyAmount b) =>
        a.currency == b.currency ? a.amount == b.amount : throw new ArgumentException();

    public static bool operator !=(CurrencyAmount a, CurrencyAmount b) =>
        a.currency == b.currency ? a.amount != b.amount : throw new ArgumentException();

    public static bool operator <(CurrencyAmount a, CurrencyAmount b) =>
        a.currency == b.currency ? a.amount < b.amount : throw new ArgumentException();

    public static bool operator >(CurrencyAmount a, CurrencyAmount b) =>
        a.currency == b.currency ? a.amount > b.amount : throw new ArgumentException();

    public static CurrencyAmount operator +(CurrencyAmount a, CurrencyAmount b) =>
        a.currency == b.currency ? new CurrencyAmount(a.amount + b.amount, a.currency) : throw new ArgumentException();

    public static CurrencyAmount operator -(CurrencyAmount a, CurrencyAmount b) =>
        a.currency == b.currency ? new CurrencyAmount(a.amount - b.amount, a.currency) : throw new ArgumentException();

    public static CurrencyAmount operator *(CurrencyAmount a, CurrencyAmount b) =>
        a.currency == b.currency ? new CurrencyAmount(a.amount * b.amount, a.currency) : throw new ArgumentException();

    public static CurrencyAmount operator /(CurrencyAmount a, CurrencyAmount b) => (a.currency == b.currency) switch
    {
        true when b.amount > 0 => new CurrencyAmount(a.amount / b.amount, a.currency),
        true when b.amount == 0 => throw new ArgumentException("Second amount causing division by zero"),
        _ => throw new ArgumentException("Currencies don't match")
    };

    public static implicit operator double(CurrencyAmount ca) => (double)ca.amount;
    public static implicit operator decimal(CurrencyAmount ca) => ca.amount;
}
