import 'dart:math';

List<String> stringToArray(String stringToConvert) {
  List<String> splitStrings = stringToConvert.split(",");
  for (int i = 0; i < splitStrings.length; i++) {
    splitStrings[i] = splitStrings[i].trim();
  }
  return splitStrings;
}

String arrayToString(List<String?> array) {
  String convertedString = "";

  for (int i = 0; i < array.length; i++) {
    convertedString += (i > 0 ? ", " : "") + (array[i] ?? "-");
  }

  return convertedString;
}

String generateRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
}
