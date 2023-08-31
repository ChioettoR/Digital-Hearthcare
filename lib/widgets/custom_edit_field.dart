import 'package:flutter/material.dart';

class CustomEditField extends StatelessWidget {
  final String initialValue;
  final bool isEditing;
  final TextEditingController myController;
  final dynamic onTapFunction;
  final dynamic validation;

  const CustomEditField(this.initialValue, this.isEditing, this.myController,
      {super.key, this.onTapFunction, this.validation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 60,
        child: TextFormField(
          controller: myController,
          onTap: onTapFunction,
          enabled: isEditing,
          validator: validation,
          decoration: InputDecoration(
            hintText: initialValue,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
          textAlign: TextAlign.left,
        ));
  }
}
