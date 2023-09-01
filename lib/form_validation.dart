import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

String? validatePhoneNumber(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty || phoneNumber == '-') {
    return null;
  }
  PhoneNumber phoneParsed = PhoneNumber.parse("+39" '$phoneNumber');
  bool valid = phoneParsed.isValid();

  return valid ? null : "Numero non valido";
}

String? formValidation(String? value) {
  if (value == null || value.isEmpty || value == '-') {
    return null;
  } else if (value.length > 50) {
    return 'Massimo 50 caratteri consentiti';
  }
  return null;
}

String? mandatoryFormValidation(String? value) {
  if (value == null || value.isEmpty || value == '-') {
    return 'Campo obbligatorio';
  } else if (value.length > 50) {
    return 'Massimo 50 caratteri consentiti';
  }
  return null;
}

String? emailValidation(String? value) {
  if (value != null && value.length > 50) {
    return 'Massimo 254 caratteri consentiti';
  } else if (value == null || value.isEmpty || value == '-') {
    return null;
  } else if (!EmailValidator.validate(value)) {
    return 'L\'email inserita non è valida';
  }
  return null;
}

String? mandatoryDateValidation(String? value) {
  if (value == null || value.isEmpty || value == '-') {
    return 'Campo obbligatorio';
  } else {
    try {
      DateFormat('yyyy-MM-dd').parse(value);
      return null;
    } catch (_) {
      return 'La data inserita non è valida';
    }
  }
}

String? dateValidation(String? value) {
  if (value == null || value.isEmpty || value == '-') {
    return null;
  } else {
    try {
      DateFormat('yyyy-MM-dd').parse(value);
      return null;
    } catch (_) {
      return 'La data inserita non è valida';
    }
  }
}
