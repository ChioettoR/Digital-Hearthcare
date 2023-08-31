import 'package:new_dhc/model/end_user.dart';
import 'package:new_dhc/model/pss.dart';

class Citizen extends EndUser {
  String cfVolunteer;
  String cfDoctor;
  String dateOfBirth;
  String cityOfBirth;
  String provinceOfBirth;
  String idCardNumber;
  String idCardReleaseCity;
  String idCardReleaseDate;
  String idCardExpirationDate;
  String genre;
  String domicile;
  String domicileAddress;
  String domicileProvince;
  String domicileCap;
  String crs;
  String firstICEContactInfo;
  String firstICEContactPhone;
  String secondICEContactInfo;
  String secondICEContactPhone;
  String infoCaregiver;
  String phoneCaregiver;
  Map<String, PSS>? data;

  Citizen(
      String cf,
      String email,
      String firstName,
      String lastName,
      String photoUrl,
      String pec,
      String phone,
      this.cfVolunteer,
      this.cfDoctor,
      this.dateOfBirth,
      this.cityOfBirth,
      this.provinceOfBirth,
      this.idCardNumber,
      this.idCardReleaseCity,
      this.idCardReleaseDate,
      this.idCardExpirationDate,
      this.genre,
      this.domicile,
      this.domicileAddress,
      this.domicileProvince,
      this.domicileCap,
      this.crs,
      this.firstICEContactInfo,
      this.firstICEContactPhone,
      this.secondICEContactInfo,
      this.secondICEContactPhone,
      this.infoCaregiver,
      this.phoneCaregiver,
      this.data)
      : super(
            cf, email, firstName, lastName, photoUrl, pec, phone, 'cittadino');

  String get fullName {
    return "$firstName $lastName";
  }
}
