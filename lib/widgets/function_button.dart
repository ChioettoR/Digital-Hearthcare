import 'package:flutter/material.dart';

class FunctionButton extends StatelessWidget {
  final dynamic onPressed;
  final Icon icon;
  final String label;
  const FunctionButton(this.onPressed, this.icon, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onPressed, icon: icon, label: Text(label));
  }
}
