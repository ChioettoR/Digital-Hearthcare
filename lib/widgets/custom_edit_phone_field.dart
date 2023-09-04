import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_dhc/form_validation.dart';

class CustomEditPhoneField extends StatelessWidget {
  final String? initialValue;
  final bool isEditing;
  final TextEditingController myController;
  final ScrollController scrollController = ScrollController();

  CustomEditPhoneField(this.initialValue, this.isEditing, this.myController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: TextFormField(
          scrollController: scrollController,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSaved: (newValue) => {if (newValue == "") myController.text = "-"},
          controller: myController,
          keyboardType: TextInputType.phone,
          enabled: isEditing,
          onTapOutside: (_) => scrollController.jumpTo(0),
          onTap: clearEmptyFields,
          validator: validatePhoneNumber,
          decoration: InputDecoration(
            helperText: " ",
            hintText: initialValue == "-" ? "" : initialValue,
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
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

  clearEmptyFields() {
    if (myController.text == "-") myController.clear();
  }
}
