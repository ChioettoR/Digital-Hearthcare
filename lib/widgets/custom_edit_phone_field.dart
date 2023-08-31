import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CustomEditPhoneField extends StatelessWidget {
  final String? initialValue;
  final bool isEditing;
  final TextEditingController myController;

  const CustomEditPhoneField(
      this.initialValue, this.isEditing, this.myController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 60,
        child: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: myController,
          keyboardType: TextInputType.phone,
          enabled: isEditing,
          validator: validatePhoneNumber,
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

  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty || phoneNumber == '-') {
      return null;
    }
    PhoneNumber phoneParsed = PhoneNumber.parse("+39" '$phoneNumber');
    bool valid = phoneParsed.isValid();

    return valid ? null : "Numero non valido";
  }
}
