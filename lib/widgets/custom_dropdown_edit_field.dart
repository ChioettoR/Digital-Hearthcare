import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class CustomDropdownEditField extends StatelessWidget {
  final String? initialValue;
  final bool isEditing;
  final SingleValueDropDownController myController;
  final dynamic validation;
  final bool onlyNumbers;
  final int? maxLength;

  const CustomDropdownEditField(
      this.initialValue, this.isEditing, this.myController, this.onlyNumbers,
      {super.key, this.validation, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 50,
        child: DropDownTextField(
          controller: myController,
          clearOption: false,
          listSpace: -30,
          isEnabled: isEditing,
          textFieldDecoration: InputDecoration(
            hintText: initialValue == "-" ? "" : initialValue,
            border: InputBorder.none,
            isDense: true,
          ),
          textStyle: const TextStyle(fontSize: 14.0, color: Colors.black),
          enableSearch: false,
          dropDownIconProperty: IconProperty(size: isEditing ? 14 : 0),
          clearIconProperty: IconProperty(size: isEditing ? 14 : 0),
          // dropdownColor: Colors.green,
          dropDownItemCount: 2,
          dropDownList: const [
            DropDownValueModel(name: 'Uomo', value: "Uomo"),
            DropDownValueModel(name: 'Donna', value: "Donna"),
          ],
        ));
  }

  clearEmptyFields() {
    //if (myController.text == "-") myController.clear();
  }
}
