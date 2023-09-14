import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:new_dhc/dropdown_editing_controller.dart';

class CustomDropdownEditField extends StatelessWidget {
  final String? initialValue;
  final bool isEditing;
  final DropDownEditingController myController;
  final List<String> dropDownList;

  const CustomDropdownEditField(
      this.initialValue, this.isEditing, this.myController, this.dropDownList,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 220,
        height: 53,
        child: DropdownSearch<String>(
            key: myController.key,
            selectedItem: initialValue,
            dropdownButtonProps: DropdownButtonProps(isVisible: isEditing),
            enabled: isEditing,
            popupProps: const PopupProps.menu(
                showSearchBox: false, showSelectedItems: true),
            items: dropDownList,
            dropdownBuilder: (_, content) => Text(content ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                )),
            onChanged: (value) {
              FocusScope.of(context).requestFocus(FocusNode());
              myController.text = value;
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  hintText: initialValue == "-" ? " " : initialValue,
                  isDense: true),
            )));
  }
}
