import 'package:compound_interest/compound_interest.dart';

void main() {
  var ci = CompoundInterest(
    principal: Currency.euros(1),
    deposit: Currency.euros(1),
    contribFrequency: ContribFrequency.monthly,
    ratePercentage: 5,
    growthYears: 1,
  );
  print('Aggregates in units: ${ci.aggregates}');
  print('Amounts in currency: ${ci.amounts}');
}
