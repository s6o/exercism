import 'dart:async';

import 'package:flutter/material.dart';
import 'package:compound_interest/compound_interest.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, required this.title});

  final String title;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

enum _Field {
  principle,
  contrib,
  deposit,
  rate,
  growth,
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _finalValue = TextEditingController();
  final _totalDeposits = TextEditingController();
  late CompoundInterest _ci;
  late int _aggCount;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ci = CompoundInterest(
      principal: Currency.euros(1),
      deposit: Currency.euros(1),
      contribFrequency: ContribFrequency.monthly,
      ratePercentage: 5,
      growthYears: 1,
    );
    _aggCount = _ci.aggregates.length;
    _finalValue.text =
        Currency.units(_ci.aggregates.last, _ci.principal).amount;
    _totalDeposits.text = _ci.totalDeposits.amount;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _finalValue.dispose();
    _totalDeposits.dispose();
    super.dispose();
  }

  String? _amountValidator(String? value) {
    if (value == null ||
        value.isEmpty ||
        double.tryParse(value) == null ||
        double.tryParse(value)! < 0) {
      return 'A valid amount is 0 or greater.';
    }
    return null;
  }

  String? _interestValidator(String? value) {
    if (value == null ||
        value.isEmpty ||
        double.tryParse(value) == null ||
        double.tryParse(value)! <= 0) {
      return 'Interest rate must be greater than 0.';
    }
    return null;
  }

  String? _yearsValidator(String? value) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.tryParse(value)! < 1) {
      return 'Growth must be 1 or greater.';
    }
    return null;
  }

  void _updateState(_Field field, dynamic value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_formKey.currentState!.validate()) {
        setState(() {
          switch (field) {
            case _Field.principle:
              _ci = CompoundInterest(
                principal: Currency.euros(double.parse(value)),
                deposit: _ci.deposit,
                contribFrequency: _ci.contribFrequency,
                ratePercentage: _ci.ratePercentage,
                growthYears: _ci.growthYears,
              );
              break;
            case _Field.contrib:
              _ci = CompoundInterest(
                principal: _ci.principal,
                deposit: _ci.deposit,
                contribFrequency: value,
                ratePercentage: _ci.ratePercentage,
                growthYears: _ci.growthYears,
              );
              break;
            case _Field.deposit:
              _ci = CompoundInterest(
                principal: _ci.principal,
                deposit: Currency.euros(double.parse(value)),
                contribFrequency: _ci.contribFrequency,
                ratePercentage: _ci.ratePercentage,
                growthYears: _ci.growthYears,
              );
              break;
            case _Field.rate:
              _ci = CompoundInterest(
                principal: _ci.principal,
                deposit: _ci.deposit,
                contribFrequency: _ci.contribFrequency,
                ratePercentage: double.parse(value),
                growthYears: _ci.growthYears,
              );
              break;
            case _Field.growth:
              _ci = CompoundInterest(
                principal: _ci.principal,
                deposit: _ci.deposit,
                contribFrequency: _ci.contribFrequency,
                ratePercentage: _ci.ratePercentage,
                growthYears: int.parse(value),
              );
              break;
          }
          _aggCount = _ci.aggregates.length;
          _finalValue.text =
              Currency.units(_ci.aggregates.last, _ci.principal).amount;
          _totalDeposits.text = _ci.totalDeposits.amount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(
            width: 350,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Initial Investment Amount (Principle)',
                      suffixIcon: Icon(Icons.euro),
                    ),
                    initialValue: _ci.principal.amount,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.right,
                    validator: _amountValidator,
                    onChanged: (value) => _updateState(_Field.principle, value),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    value: _ci.contribFrequency,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contribution Period (Compound Frequency)',
                    ),
                    items: ContribFrequency.values
                        .map<DropdownMenuItem<ContribFrequency>>((value) {
                      return DropdownMenuItem<ContribFrequency>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (ContribFrequency? value) =>
                        _updateState(_Field.contrib, value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contribution Amount (Deposit)',
                      suffixIcon: Icon(Icons.euro),
                    ),
                    initialValue: _ci.deposit.amount,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.right,
                    validator: _amountValidator,
                    onChanged: (value) => _updateState(_Field.deposit, value),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Annual Interest Rate',
                            suffixIcon: Icon(Icons.percent),
                          ),
                          initialValue: _ci.ratePercentage.toString(),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textAlign: TextAlign.right,
                          validator: _interestValidator,
                          onChanged: (value) =>
                              _updateState(_Field.rate, value),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Years of Growth',
                          ),
                          initialValue: _ci.growthYears.toString(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          validator: _yearsValidator,
                          onChanged: (value) =>
                              _updateState(_Field.growth, value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Total Deposits',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      suffixIcon: Icon(Icons.euro),
                    ),
                    controller: _totalDeposits,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Final Future Value',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      suffixIcon: Icon(Icons.euro),
                    ),
                    controller: _finalValue,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    readOnly: true,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListView.builder(
                          itemCount: _aggCount - 1,
                          itemBuilder: (BuildContext ctx, int index) {
                            var i = _aggCount - index - 2;
                            var c =
                                Currency.units(_ci.aggregates[i], _ci.principal)
                                    .amount;
                            return ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              horizontalTitleGap: 0,
                              minVerticalPadding: 2,
                              dense: true,
                              leading: Text('$i'),
                              tileColor: i % 2 == 0
                                  ? Theme.of(context).colorScheme.background
                                  : Theme.of(context).colorScheme.onSecondary,
                              title: Text(c, textAlign: TextAlign.right),
                              trailing: const Icon(
                                Icons.euro,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
