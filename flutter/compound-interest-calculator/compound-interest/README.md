# Compound Interest calculations

This library provides the `CompoundInterest` class to calculate investment results
over a period of years by compounding interest yearly or monthly. An aggregated
value is provided for every compound period.

## Usage

```dart
import 'package:compound_interest/compound_interest.dart';

void main() {
  var ci = CompoundInterest(
    principal: Currency.euros(100),
    deposit: Currency.euros(100),
    contribFrequency: ContribFrequency.monthly,
    ratePercentage: 5,
    growthYears: 10,
  );
  print('Aggregates in units: ${ci.aggregates}');
  print('Amounts in currency: ${ci.amounts}');
}
```
