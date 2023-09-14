import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownEditingController {
  late String value;
  final key = GlobalKey<DropdownSearchState<String>>();

  reset(String? resetValue) {
    key.currentState!.changeSelectedItem(resetValue);
  }

  String get text {
    return value;
  }

  set text(String? newText) {
    value = newText ?? "";
  }

  DropDownEditingController({String? text}) {
    this.text = text;
  }
}
