import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final Icon icon;
  final dynamic callback;
  const AppBarButton(this.icon, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: callback,
    );
  }
}
