import 'package:compound_interest/compound_interest.dart';
import 'package:test/test.dart';

void main() {
  test('No principle, no contrib, 1 year, annually', () {
    var ci = CompoundInterest(
      principal: Currency.euros(0),
      deposit: Currency.euros(0),
      contribFrequency: ContribFrequency.yearly,
      ratePercentage: 5,
      growthYears: 1,
    );
    expect(ci.aggregates, [0, 0]);
    expect(ci.amounts, ['0.00', '0.00']);
    expect(ci.totalDeposits.units, 0);
  });

  test('With 1€ principle, no contrib, 5 years, annually', () {
    var ci = CompoundInterest(
      principal: Currency.euros(1),
      deposit: Currency.euros(0),
      contribFrequency: ContribFrequency.yearly,
      ratePercentage: 5,
      growthYears: 5,
    );
    expect(
      ci.aggregates,
      [1000000, 1050000, 1102500, 1157625, 1215506, 1276281],
    );
    expect(ci.amounts, ['1.00', '1.05', '1.10', '1.16', '1.22', '1.28']);
    expect(ci.totalDeposits.amount, '1.00');
  });

  test('With 1€ principle, with contrib 1€, 1 year, montly', () {
    var ci = CompoundInterest(
      principal: Currency.euros(1),
      deposit: Currency.euros(1),
      contribFrequency: ContribFrequency.monthly,
      ratePercentage: 5,
      growthYears: 1,
    );
    expect(ci.totalDeposits.amount, '13.00');
    expect(ci.aggregates, [
      1000000,
      2004166,
      3012516,
      4025068,
      5041839,
      6062846,
      7088107,
      8117640,
      9151463,
      10189594,
      11232050,
      12278850,
      13330011
    ]);
    expect(ci.amounts, [
      '1.00',
      '2.00',
      '3.01',
      '4.03',
      '5.04',
      '6.06',
      '7.09',
      '8.12',
      '9.15',
      '10.19',
      '11.23',
      '12.28',
      '13.33',
    ]);
  });
}
