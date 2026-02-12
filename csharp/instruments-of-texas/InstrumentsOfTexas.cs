public class CalculationException : Exception
{
    private int op1;
    private int op2;

    public CalculationException(int operand1, int operand2, string message, Exception inner) : base(message, inner)
    {
        op1 = operand1;
        op2 = operand2;
    }

    public int Operand1 { get { return op1; } }
    public int Operand2 { get { return op2; } }
}

public class CalculatorTestHarness
{
    private Calculator calculator;

    public CalculatorTestHarness(Calculator calculator)
    {
        this.calculator = calculator;
    }

    public string TestMultiplication(int x, int y)
    {
        try
        {
            this.Multiply(x, y);
            return "Multiply succeeded";
        }
        catch (CalculationException ce) when (ce.Operand1 < 0 && ce.Operand2 < 0)
        {
            return "Multiply failed for negative operands. " + ce.InnerException?.Message;
        }
        catch (CalculationException ce)
        {
            return "Multiply failed for mixed or positive operands. " + ce.InnerException?.Message;
        }
    }

    public void Multiply(int x, int y)
    {
        try
        {
            calculator.Multiply(x, y);
        }
        catch (OverflowException e)
        {
            throw new CalculationException(x, y, "", e);
        }
    }
}


// Please do not modify the code below.
// If there is an overflow in the multiplication operation
// then a System.OverflowException is thrown.
public class Calculator
{
    public int Multiply(int x, int y)
    {
        checked
        {
            return x * y;
        }
    }
}
