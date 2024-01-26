import 'package:flutter/material.dart';
import 'package:compound_interest_client/calculator_page.dart';

void main() {
  runApp(const CompoundInterestApp());
}

class CompoundInterestApp extends StatelessWidget {
  const CompoundInterestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compound Interest Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorPage(title: 'Compound Interest Calculator'),
    );
  }
}
