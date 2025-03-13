library assurance_sdk;

import 'package:assurance_sdk/screens/input_page.dart';
import 'package:assurance_sdk/screens/test_screen.dart';
import 'package:flutter/material.dart';

/// Une classe pour effectuer des calculs simples.
class Calculator {
  /// Ajoute 1 à la valeur fournie.
  int addOne(int value) => value + 1;
}

/// Un widget de test pour vérifier le fonctionnement du SDK.
class AssuranceTestWidget extends StatefulWidget {
  @override
  _AssuranceTestWidgetState createState() => _AssuranceTestWidgetState();
}

class _AssuranceTestWidgetState extends State<AssuranceTestWidget> {
  final Calculator calculator = Calculator();
  int _result = 0;

  void _calculate() {
    setState(() {
      _result = calculator.addOne(_result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Input and Display App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputPage(),
    );
  }
}
