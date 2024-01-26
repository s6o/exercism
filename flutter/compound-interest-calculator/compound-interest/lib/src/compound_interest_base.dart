/// Its not a good idea to use floats for currency/money amounts!
/// [Why?](https://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency)
///
/// When you compare with compound interest calculators on the web, one should
/// remember that Javascript impl.-s using the number type are doing it wrong.
/// [Javascript Number type](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#number_type)
/// Currency related JS should use [BigInt type](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#bigint_type)
class Currency {
  /// Subunit fractions
  final int precision;

  /// Number of subunits in a unit e.g. 100 cents (subunits) -> 1€
  final int subunits;

  /// Currency symbol e.g. € (euro), $ (dollar)
  final String symbol;

  /// The amount in base (/sub) units with additional fractional precision
  final int units;

  /// Initialize from a (real-world) currency amount e.g. 1€ or 50€.
  Currency.euros(double amount,
      {this.precision = 10000, this.subunits = 100, this.symbol = '€'})
      : units = (amount * subunits * precision).truncate() {
    if (amount < 0) {
      throw ArgumentError(
        'The currency amount must be 0 or greater.',
        'amount',
      );
    }
  }

  /// Initialize from another currency units.
  Currency.units(this.units, Currency c)
      : precision = c.precision,
        subunits = c.subunits,
        symbol = c.symbol;

  /// Formatted amount
  /// A more real-life impl. would use [intl](https://pub.dev/packages/intl)
  String get amount {
    return ((units / precision).roundToDouble() / subunits).toStringAsFixed(2);
  }
}

enum ContribFrequency {
  monthly,
  yearly,
}

/// Generate compound interest aggregates over specified period for a given
/// initial principal and re-occurring periodical contribution (deposit).
///
/// The contribution frequency of the deposit `contribFrequency` is also the
/// compound frequency. Compounding happens at the end of the period.
///
/// [Inspiration](https://www.thecalculatorsite.com/finance/calculators/compoundinterestcalculator.php)
class CompoundInterest {
  /// Initial investment.
  final Currency principal;

  /// Periodical contribution.
  final Currency deposit;

  /// Contribution period and interest compound period.
  final ContribFrequency contribFrequency;

  /// Accumulation period.
  final int growthYears;

  /// Yearly interest rate.
  final double ratePercentage;

  /// Aggregated growth milestones for every compound period.
  late final List<int> aggregates;

  /// Total amount of deposits over the growth period (including the principle).
  late final Currency totalDeposits;

  CompoundInterest({
    required this.principal,
    required this.deposit,
    required this.contribFrequency,
    this.growthYears = 1,
    required this.ratePercentage,
  }) {
    if (principal.precision != deposit.precision ||
        principal.symbol != deposit.symbol) {
      ArgumentError(
        'Initial and deposit amount currencies must match with precision',
        'initialAmount/depositAmount',
      );
    }
    if (growthYears < 1) {
      throw ArgumentError('The minimum growth period is 1 year', 'growthYears');
    }
    if (ratePercentage < 0 || ratePercentage > 100) {
      throw ArgumentError(
          'The rate of return must be between 0-100.', 'ratePercentage');
    }
    ({int count, double rate}) gen = switch (contribFrequency) {
      ContribFrequency.monthly => (
          count: growthYears * 12,
          rate: ratePercentage / 100 / 12
        ),
      ContribFrequency.yearly => (
          count: growthYears,
          rate: ratePercentage / 100
        )
    };
    int depositUnits = principal.units;
    aggregates = [principal.units];
    for (int index = 1; index < gen.count + 1; index++) {
      int interest = ((aggregates[index - 1] * gen.rate)).truncate();
      depositUnits = depositUnits + deposit.units;
      aggregates.insert(
        index,
        aggregates[index - 1] + interest + deposit.units,
      );
    }
    totalDeposits = Currency.units(depositUnits, principal);
  }

  List<String> get amounts =>
      aggregates.map((e) => Currency.units(e, deposit).amount).toList();
}
