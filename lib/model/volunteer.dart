import '../constants.dart';

class Volunteer {
  String cf;
  String firstName;
  String lastName;
  String email;
  String? pec;
  String? phone;

  Volunteer(
    this.cf,
    this.firstName,
    this.lastName,
    this.email,
    this.pec,
    this.phone,
  );

  String fullName() {
    return firstName + space + lastName;
  }
}
