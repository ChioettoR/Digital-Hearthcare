import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomEditField extends StatelessWidget {
  final String? initialValue;
  final bool isEditing;
  final TextEditingController myController;
  final dynamic onTapFunction;
  final dynamic validation;
  final bool onlyNumbers;
  final int? maxLength;
  final String? hintText;
  final ScrollController scrollController = ScrollController();

  CustomEditField(
      this.initialValue, this.isEditing, this.myController, this.onlyNumbers,
      {super.key,
      this.onTapFunction,
      this.validation,
      this.maxLength,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 220,
        child: TextFormField(
          scrollController: scrollController,
          readOnly: onTapFunction != null,
          onTapOutside: (_) => scrollController.jumpTo(0),
          onSaved: (newValue) => {if (newValue == "") myController.text = "-"},
          maxLength: !isEditing ? null : maxLength,
          inputFormatters:
              onlyNumbers ? [FilteringTextInputFormatter.digitsOnly] : null,
          controller: myController,
          onTap: onTapFunction ?? clearEmptyFields,
          enabled: isEditing,
          validator: validation,
          decoration: InputDecoration(
            helperText: " ",
            hintText: (initialValue == null || initialValue == "-")
                ? (hintText ?? " ")
                : initialValue,
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
        ));
  }

  clearEmptyFields() {
    if (myController.text == "-") myController.clear();
  }
}
