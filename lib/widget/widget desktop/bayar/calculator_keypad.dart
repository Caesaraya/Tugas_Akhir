import 'package:flutter/material.dart';
import 'calculator_button.dart';

class CalculatorKeypad extends StatelessWidget {
  final Function(String) onButtonPressed;

  const CalculatorKeypad({
    super.key,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              CalculatorButton(
                text: "1",
                onPressed: () => onButtonPressed("1"),
              ),
              CalculatorButton(
                text: "2",
                onPressed: () => onButtonPressed("2"),
              ),
              CalculatorButton(
                text: "3",
                onPressed: () => onButtonPressed("3"),
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                text: "4",
                onPressed: () => onButtonPressed("4"),
              ),
              CalculatorButton(
                text: "5",
                onPressed: () => onButtonPressed("5"),
              ),
              CalculatorButton(
                text: "6",
                onPressed: () => onButtonPressed("6"),
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                text: "7",
                onPressed: () => onButtonPressed("7"),
              ),
              CalculatorButton(
                text: "8",
                onPressed: () => onButtonPressed("8"),
              ),
              CalculatorButton(
                text: "9",
                onPressed: () => onButtonPressed("9"),
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                text: "0",
                onPressed: () => onButtonPressed("0"),
              ),
              CalculatorButton(
                text: "000",
                onPressed: () => onButtonPressed("000"),
              ),
              CalculatorButton(
                text: "X",
                onPressed: () => onButtonPressed("X"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}