import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:new_dhc/dropdown_editing_controller.dart';
import 'package:new_dhc/model/citizen.dart';
import 'package:new_dhc/services/database_service.dart';

class UserData {
  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController cf;
  late DropDownEditingController genre;
  late TextEditingController dateOfBirth;
  late TextEditingController cityOfBirth;
  late TextEditingController provinceOfBirth;
  late TextEditingController idCardNumber;
  late TextEditingController idCardReleaseCity;
  late TextEditingController idCardReleaseDate;
  late TextEditingController idCardExpirationDate;
  late TextEditingController domicile;
  late TextEditingController domicileAddress;
  late TextEditingController domicileProvince;
  late TextEditingController domicileCap;
  late TextEditingController crs;
  late TextEditingController email;
  late TextEditingController pec;
  late TextEditingController phone;
  late TextEditingController firstICEContactInfo;
  late TextEditingController firstICEContactPhone;
  late TextEditingController secondICEContactInfo;
  late TextEditingController secondICEContactPhone;
  late TextEditingController infoCaregiver;
  late TextEditingController phoneCaregiver;
  late String photoUrl;
  late Uint8List? photoBytes;

  late Citizen? currentCitizen;

  UserData(Citizen citizen) {
    currentCitizen = citizen;
    firstName = TextEditingController(text: citizen.firstName);
    lastName = TextEditingController(text: citizen.lastName);
    cf = TextEditingController(text: citizen.cf);
    genre = DropDownEditingController(text: citizen.genre);
    dateOfBirth = TextEditingController(text: citizen.dateOfBirth);
    cityOfBirth = TextEditingController(text: citizen.cityOfBirth);
    provinceOfBirth = TextEditingController(text: citizen.provinceOfBirth);
    idCardNumber = TextEditingController(text: citizen.idCardNumber);
    idCardReleaseCity = TextEditingController(text: citizen.idCardReleaseCity);
    idCardReleaseDate = TextEditingController(text: citizen.idCardReleaseDate);
    idCardExpirationDate =
        TextEditingController(text: citizen.idCardExpirationDate);
    domicile = TextEditingController(text: citizen.domicile);
    domicileAddress = TextEditingController(text: citizen.domicileAddress);
    domicileProvince = TextEditingController(text: citizen.domicileProvince);
    domicileCap = TextEditingController(text: citizen.domicileCap);
    crs = TextEditingController(text: citizen.crs);
    email = TextEditingController(text: citizen.email);
    pec = TextEditingController(text: citizen.pec);
    phone = TextEditingController(text: citizen.phone);
    firstICEContactInfo =
        TextEditingController(text: citizen.firstICEContactInfo);
    firstICEContactPhone =
        TextEditingController(text: citizen.firstICEContactPhone);
    secondICEContactInfo =
        TextEditingController(text: citizen.secondICEContactInfo);
    secondICEContactPhone =
        TextEditingController(text: citizen.secondICEContactPhone);
    infoCaregiver = TextEditingController(text: citizen.infoCaregiver);
    phoneCaregiver = TextEditingController(text: citizen.phoneCaregiver);
    photoUrl = citizen.photoUrl;
    photoBytes = null;
  }

  UserData.empty() {
    currentCitizen = null;
    firstName = TextEditingController();
    lastName = TextEditingController();
    cf = TextEditingController();
    genre = DropDownEditingController();
    dateOfBirth = TextEditingController();
    cityOfBirth = TextEditingController();
    provinceOfBirth = TextEditingController();
    idCardNumber = TextEditingController();
    idCardReleaseCity = TextEditingController();
    idCardReleaseDate = TextEditingController();
    idCardExpirationDate = TextEditingController();
    domicile = TextEditingController();
    domicileAddress = TextEditingController();
    domicileProvince = TextEditingController();
    domicileCap = TextEditingController();
    crs = TextEditingController();
    email = TextEditingController();
    pec = TextEditingController();
    phone = TextEditingController();
    firstICEContactInfo = TextEditingController();
    firstICEContactPhone = TextEditingController();
    secondICEContactInfo = TextEditingController();
    secondICEContactPhone = TextEditingController();
    infoCaregiver = TextEditingController();
    phoneCaregiver = TextEditingController();
    photoUrl = "-";
    photoBytes = null;
  }

  saveCitizenFields(Uint8List? uploadedPhotoBytes, bool imageRemoved) {
    photoBytes = imageRemoved ? null : uploadedPhotoBytes ?? photoBytes;

    currentCitizen!.firstName = firstName.text;
    currentCitizen!.lastName = lastName.text;
    currentCitizen!.genre = genre.text;
    currentCitizen!.dateOfBirth = dateOfBirth.text;
    currentCitizen!.cityOfBirth = cityOfBirth.text;
    currentCitizen!.domicile = domicile.text;
    currentCitizen!.pec = pec.text;
    currentCitizen!.phone = phone.text;
    currentCitizen!.infoCaregiver = infoCaregiver.text;
    currentCitizen!.phoneCaregiver = phoneCaregiver.text;
    currentCitizen!.provinceOfBirth = provinceOfBirth.text;
    currentCitizen!.idCardNumber = idCardNumber.text;
    currentCitizen!.idCardReleaseCity = idCardReleaseCity.text;
    currentCitizen!.idCardReleaseDate = idCardReleaseDate.text;
    currentCitizen!.idCardExpirationDate = idCardExpirationDate.text;
    currentCitizen!.domicileAddress = domicileAddress.text;
    currentCitizen!.domicileProvince = domicileProvince.text;
    currentCitizen!.domicileCap = domicileCap.text;
    currentCitizen!.crs = crs.text;
    currentCitizen!.firstICEContactInfo = firstICEContactInfo.text;
    currentCitizen!.firstICEContactPhone = firstICEContactPhone.text;
    currentCitizen!.secondICEContactInfo = secondICEContactInfo.text;
    currentCitizen!.secondICEContactPhone = secondICEContactPhone.text;
    currentCitizen!.photoUrl = imageRemoved ? "-" : photoUrl;

    DatabaseService().editCitizenFields(currentCitizen!, photoBytes);
  }

  reset() {
    firstName.text = currentCitizen!.firstName;
    lastName.text = currentCitizen!.lastName;
    genre.reset(currentCitizen!.genre);
    dateOfBirth.text = currentCitizen!.dateOfBirth;
    cityOfBirth.text = currentCitizen!.cityOfBirth;
    domicile.text = currentCitizen!.domicile;
    pec.text = currentCitizen!.pec;
    phone.text = currentCitizen!.phone;
    infoCaregiver.text = currentCitizen!.infoCaregiver;
    phoneCaregiver.text = currentCitizen!.phoneCaregiver;
    provinceOfBirth.text = currentCitizen!.provinceOfBirth;
    idCardNumber.text = currentCitizen!.idCardNumber;
    idCardReleaseCity.text = currentCitizen!.idCardReleaseCity;
    idCardReleaseDate.text = currentCitizen!.idCardReleaseDate;
    idCardExpirationDate.text = currentCitizen!.idCardExpirationDate;
    domicileAddress.text = currentCitizen!.domicileAddress;
    domicileProvince.text = currentCitizen!.domicileProvince;
    domicileCap.text = currentCitizen!.domicileCap;
    crs.text = currentCitizen!.crs;
    firstICEContactInfo.text = currentCitizen!.firstICEContactInfo;
    firstICEContactPhone.text = currentCitizen!.firstICEContactPhone;
    secondICEContactInfo.text = currentCitizen!.secondICEContactInfo;
    secondICEContactPhone.text = currentCitizen!.secondICEContactPhone;
    photoUrl = currentCitizen!.photoUrl;
  }

  dispose() {
    firstName.dispose();
    lastName.dispose();
    cf.dispose();
    dateOfBirth.dispose();
    cityOfBirth.dispose();
    provinceOfBirth.dispose();
    idCardNumber.dispose();
    idCardReleaseCity.dispose();
    idCardReleaseDate.dispose();
    idCardExpirationDate.dispose();
    domicile.dispose();
    domicileAddress.dispose();
    domicileProvince.dispose();
    domicileCap.dispose();
    crs.dispose();
    email.dispose();
    pec.dispose();
    phone.dispose();
    firstICEContactInfo.dispose();
    firstICEContactPhone.dispose();
    secondICEContactInfo.dispose();
    secondICEContactPhone.dispose();
    infoCaregiver.dispose();
    phoneCaregiver.dispose();
  }
}
