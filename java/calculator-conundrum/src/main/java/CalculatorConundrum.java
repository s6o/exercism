import java.lang.ArithmeticException;

class CalculatorConundrum {
    public String calculate(int operand1, int operand2, String operation) {
        int result = 0;
        if (operation == null) {
            throw new IllegalArgumentException("Operation cannot be null");
        }
        if (operation.isEmpty()) {
            throw new IllegalArgumentException("Operation cannot be empty");
        }
        switch (operation) {
            case "+":
                result = operand1 + operand2;
                break;
            case "*":
                result = operand1 * operand2;
                break;
            case "/":
                if (operand2 == 0) {
                    throw new IllegalOperationException("Division by zero is not allowed", new ArithmeticException());
                }
                result = operand1 / operand2;
                break;
            default:
                throw new IllegalOperationException("Operation '" + operation + "' does not exist");
        }
        return operand1 + " " + operation + " " + operand2 + " = " + result;
    }
}
