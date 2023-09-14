import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:new_dhc/constants.dart';
import 'package:new_dhc/dropdown_editing_controller.dart';

class CustomDropdownMultiEditField extends StatelessWidget {
  final List<String>? initialValues;
  final bool isEditing;
  final DropDownEditingController myController;
  final List<String> dropDownList;

  const CustomDropdownMultiEditField(
      this.initialValues, this.isEditing, this.myController, this.dropDownList,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 220,
        height: 53,
        child: DropdownSearch<String>.multiSelection(
            clearButtonProps: const ClearButtonProps(isVisible: true),
            selectedItems: initialValues ?? [],
            dropdownButtonProps: DropdownButtonProps(isVisible: isEditing),
            enabled: isEditing,
            popupProps: const PopupPropsMultiSelection.menu(
                showSearchBox: false, showSelectedItems: true),
            items: dropDownList,
            dropdownBuilder: (_, content) => Text(fromListToString(content),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                )),
            onChanged: (value) {
              FocusScope.of(context).requestFocus(FocusNode());
              myController.text = fromListToString(value);
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  hintText: initialValues == null
                      ? ""
                      : fromListToString(initialValues!),
                  isDense: true),
            )));
  }
}
