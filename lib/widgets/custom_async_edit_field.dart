import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAsyncEditField extends StatefulWidget {
  final String? initialValue;
  final bool isEditing;
  final TextEditingController myController;
  final dynamic onTapFunction;
  final dynamic validation;
  final dynamic asyncValidation;
  final bool onlyNumbers;
  final int? maxLength;
  final String? hintText;
  final ScrollController scrollController = ScrollController();

  CustomAsyncEditField(
      this.initialValue, this.isEditing, this.myController, this.onlyNumbers,
      {super.key,
      this.onTapFunction,
      this.validation,
      this.asyncValidation,
      this.maxLength,
      this.hintText});

  @override
  State<CustomAsyncEditField> createState() => _CustomAsyncEditFieldState();
}

class _CustomAsyncEditFieldState extends State<CustomAsyncEditField> {
  bool asyncValidationPassed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 220,
        child: TextFormField(
          scrollController: widget.scrollController,
          readOnly: widget.onTapFunction != null,
          onTapOutside: (_) => widget.scrollController.jumpTo(0),
          onSaved: (newValue) =>
              {if (newValue == "") widget.myController.text = "-"},
          maxLength: !widget.isEditing ? null : widget.maxLength,
          inputFormatters: widget.onlyNumbers
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          controller: widget.myController,
          onTap: widget.onTapFunction ?? clearEmptyFields,
          enabled: widget.isEditing,
          validator: (value) {
            return widget.validation(
                value, widget.initialValue, asyncValidationPassed);
          },
          onChanged: (value) async {
            asyncValidationPassed = false;
            final check = await widget.asyncValidation(value);
            setState(() {
              asyncValidationPassed = check;
            });
          },
          decoration: InputDecoration(
            helperText: " ",
            hintText:
                (widget.initialValue == null || widget.initialValue == "-")
                    ? (widget.hintText ?? " ")
                    : widget.initialValue,
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
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
    if (widget.myController.text == "-") widget.myController.clear();
  }
}
