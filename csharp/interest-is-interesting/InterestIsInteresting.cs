static class SavingsAccount
{
    public static float InterestRate(decimal balance)
    {
        if (balance < 0) return 3.213f;
        if (balance >= 0 && balance < 1000) return 0.5f;
        if (balance >= 1000 && balance < 5000) return 1.621f;
        return 2.475f;
    }

    public static decimal Interest(decimal balance)
    {
        decimal ir = (decimal)InterestRate(balance) / 100;
        return balance * ir;
    }

    public static decimal AnnualBalanceUpdate(decimal balance)
    {
        decimal interest = Interest(balance);
        return balance + interest;
    }

    public static int YearsBeforeDesiredBalance(decimal balance, decimal targetBalance)
    {
        int years = 0;
        while (balance < targetBalance)
        {
            balance = AnnualBalanceUpdate(balance);
            years += 1;
        }
        return years;
    }
}
