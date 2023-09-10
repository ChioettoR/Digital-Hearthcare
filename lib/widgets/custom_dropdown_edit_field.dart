import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class CustomDropdownEditField extends StatelessWidget {
  final String? initialValue;
  final bool isEditing;
  final SingleValueDropDownController myController;
  final dynamic validation;
  final bool onlyNumbers;
  final int? maxLength;
  final List<DropDownValueModel> dropDownList;

  const CustomDropdownEditField(this.initialValue, this.isEditing,
      this.myController, this.onlyNumbers, this.dropDownList,
      {super.key, this.validation, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 220,
        height: 53,
        child: DropDownTextField(
          controller: myController,
          clearOption: false,
          listSpace: -30,
          isEnabled: isEditing,
          validator: validation,
          textFieldDecoration: InputDecoration(
            hintText: initialValue == "-" ? " " : initialValue,
            border: InputBorder.none,
            isDense: true,
          ),
          textStyle: const TextStyle(fontSize: 14.0, color: Colors.black),
          enableSearch: false,
          dropDownIconProperty: IconProperty(size: isEditing ? 14 : 0),
          clearIconProperty: IconProperty(size: isEditing ? 14 : 0),
          // dropdownColor: Colors.green,
          dropDownItemCount: 2,
          dropDownList: dropDownList,
        ));
  }
}
