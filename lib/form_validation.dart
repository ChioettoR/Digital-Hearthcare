import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:new_dhc/services/auth_service.dart';
import 'package:new_dhc/services/database_service.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

String? validatePhoneNumber(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty || phoneNumber == '-') {
    return null;
  }
  PhoneNumber phoneParsed = PhoneNumber.parse("+39" '$phoneNumber');
  bool valid = phoneParsed.isValid();

  return valid ? null : "Numero non valido";
}

String? registrationEmailValidation(
    String? value, String? initialValue, bool asyncValidationPassed) {
  if (value == null || value.isEmpty || value == '-') {
    return 'Campo obbligatorio';
  } else if (value.length > 254) {
    return 'Massimo 254 caratteri consentiti';
  } else if (!EmailValidator.validate(value)) {
    return 'L\'email inserita non è valida';
  } else if (initialValue != null && value == initialValue) {
    return null;
  } else if (!asyncValidationPassed) {
    return 'L\'email inserita è già in uso';
  }
  return null;
}

String? registrationCFValidation(
    String? value, String? initialValue, bool asyncValidationPassed) {
  if (value == null || value.isEmpty || value == '-') {
    return 'Campo obbligatorio';
  } else if (value.length < 16) {
    return 'Inserire 16 caratteri';
  } else if (initialValue != null && value == initialValue) {
    return null;
  } else if (!asyncValidationPassed) {
    return 'Il CF inserito è già in uso';
  }
  return null;
}

Future<bool?> registrationEmailAsyncValidation(String value) async {
  return (!await AuthService().checkIfEmailInUse(value));
}

Future<bool?> registrationCFAsyncValidation(String value) async {
  return (!await DatabaseService().checkIfCFInUse(value));
}

String? mandatoryFormValidation(String? value) {
  if (value == null || value.isEmpty || value == '-') {
    return 'Campo obbligatorio';
  }
  return null;
}

String? cfValidation(String? value) {
  if (value != null && value.isNotEmpty && value.length < 16) {
    return 'Inserire 16 caratteri';
  }
  return null;
}

String? mandatoryEmailValidation(String? value) {
  if (value == null || value.isEmpty || value == '-') {
    return 'Campo obbligatorio';
  } else if (value.length > 254) {
    return 'Massimo 254 caratteri consentiti';
  } else if (!EmailValidator.validate(value)) {
    return 'L\'email inserita non è valida';
  }
  return null;
}

String? emailValidation(String? value) {
  if (value != null && value.length > 254) {
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

String? capValidation(String? value) {
  if (value != null && value.isNotEmpty && value.length < 5) {
    return 'Inserire 5 cifre';
  }
  return null;
}

String? idCardValidation(String? value) {
  if (value != null && value.isNotEmpty && value.length < 9) {
    return 'Inserire 9 cifre';
  }
  return null;
}
