public static class SimpleCalculator
{
    public static string Calculate(int operand1, int operand2, string? operation)
    {
        if (operation == "/" && operand2 == 0)
            return "Division by zero is not allowed.";

        var result = operation switch
        {
            null => throw new ArgumentNullException(),
            "" => throw new ArgumentException(),
            "*" => operand1 * operand2,
            "/" => operand1 / operand2,
            "+" => operand1 + operand2,
            _ => throw new ArgumentOutOfRangeException()
        };
        return $"{operand1} {operation} {operand2} = {result}";
    }
}
