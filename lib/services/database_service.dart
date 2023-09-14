import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:new_dhc/model/end_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:new_dhc/model/user_data.dart';
import 'package:new_dhc/model/user_pss.dart';
import 'package:new_dhc/model/utils.dart';

import '../constants.dart';
import '../model/citizen.dart';
import '../model/doctor.dart';
import '../model/volunteer.dart';
import '../model/pss.dart';
import 'auth_service.dart';

class DatabaseService {
  final AuthService _auth = AuthService();

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference patients =
      FirebaseFirestore.instance.collection('patients');

  final firebaseStorageRef = FirebaseStorage.instance.ref();

  Future<EndUser> getUser() {
    return users
        .doc(_auth.getCurrentUser()?.uid)
        .get()
        .then((value) => _userFromFirebase(value));
  }

  EndUser _userFromFirebase(DocumentSnapshot snapshot) {
    return EndUser(
        getField(snapshot, 'cf'),
        getField(snapshot, 'email'),
        getField(snapshot, 'firstName'),
        getField(snapshot, 'lastName'),
        getField(snapshot, 'photoUrl'),
        getField(snapshot, 'pec'),
        getField(snapshot, 'phone'),
        getField(snapshot, 'userType'));
  }

  Future<List<dynamic>> getCitizen(EndUser endUser) async {
    List<dynamic> citizenData = [];
    late String cfVolunteer;
    late String cfDoctor;
    late String dateOfBirth;
    late String genre;
    late String domicile;
    late String cityOfBirth;
    late String provinceOfBirth;
    late String idCardNumber;
    late String idCardReleaseCity;
    late String idCardReleaseDate;
    late String idCardExpirationDate;
    late String domicileAddress;
    late String domicileProvince;
    late String domicileCap;
    late String crs;
    late String firstICEContactInfo;
    late String firstICEContactPhone;
    late String secondICEContactInfo;
    late String secondICEContactPhone;

    Volunteer? volunteer;
    Doctor? doctor;
    Map<String, PSS>? citizenMap;
    late String infoCaregiver;
    late String phoneCaregiver;

    await patients.doc(endUser.cf).get().then((value) => {
          cfVolunteer = getField(value, "cfVolunteer"),
          cfDoctor = getField(value, "cfDoctor"),
          dateOfBirth = getField(value, "dateOfBirth"),
          cityOfBirth = getField(value, "cityOfBirth"),
          provinceOfBirth = getField(value, "provinceOfBirth"),
          idCardNumber = getField(value, "idCardNumber"),
          idCardReleaseCity = getField(value, "idCardReleaseCity"),
          idCardReleaseDate = getField(value, "idCardReleaseDate"),
          idCardExpirationDate = getField(value, "idCardExpirationDate"),
          genre = getField(value, "genre"),
          domicile = getField(value, "domicile"),
          domicileAddress = getField(value, "domicileAddress"),
          domicileProvince = getField(value, "domicileProvince"),
          domicileCap = getField(value, "domicileCap"),
          crs = getField(value, "crs"),
          firstICEContactInfo = getField(value, "firstICEContactInfo"),
          firstICEContactPhone = getField(value, "firstICEContactPhone"),
          secondICEContactInfo = getField(value, "secondICEContactInfo"),
          secondICEContactPhone = getField(value, "secondICEContactPhone"),
          infoCaregiver = getField(value, "infoCaregiver"),
          phoneCaregiver = getField(value, "phoneCaregiver"),
          dateOfBirth = getField(value, "dateOfBirth"),
        });

    Citizen citizen = Citizen(
        endUser.cf,
        endUser.email,
        endUser.firstName,
        endUser.lastName,
        endUser.photoUrl,
        endUser.pec,
        endUser.phone,
        cfVolunteer,
        cfDoctor,
        dateOfBirth,
        cityOfBirth,
        provinceOfBirth,
        idCardNumber,
        idCardReleaseCity,
        idCardReleaseDate,
        idCardExpirationDate,
        genre,
        domicile,
        domicileAddress,
        domicileProvince,
        domicileCap,
        crs,
        firstICEContactInfo,
        firstICEContactPhone,
        secondICEContactInfo,
        secondICEContactPhone,
        infoCaregiver,
        phoneCaregiver,
        citizenMap);

    await patients.doc(endUser.cf).collection('pss').get().then((value) {
      citizenMap = _citizenFromFirebase(value, citizen);
    });

    citizen.data = citizenMap;

    citizenData.add(citizen);

    volunteer = await users.where('cf', isEqualTo: cfVolunteer).get().then(
        (querySnapshot) => Volunteer(
            getFieldQuery(querySnapshot.docs[0], "cf"),
            getFieldQuery(querySnapshot.docs[0], "firstName"),
            getFieldQuery(querySnapshot.docs[0], "lastName"),
            getFieldQuery(querySnapshot.docs[0], "email"),
            getFieldQuery(querySnapshot.docs[0], "pec"),
            getFieldQuery(querySnapshot.docs[0], "phone")));

    citizenData.add(volunteer);

    try {
      doctor = await users.where('cf', isEqualTo: cfDoctor).get().then(
          (querySnapshot) => Doctor(
              getFieldQuery(querySnapshot.docs[0], "cf"),
              getFieldQuery(querySnapshot.docs[0], "firstName"),
              getFieldQuery(querySnapshot.docs[0], "lastName"),
              getFieldQuery(querySnapshot.docs[0], "email"),
              getFieldQuery(querySnapshot.docs[0], "pec"),
              getFieldQuery(querySnapshot.docs[0], "phone")));
    } catch (_) {
      doctor = Doctor(cfDoctor, "-", "-", "-", "-", "-");
    }

    citizenData.add(doctor);

    for (var v in citizenMap!.values) {
      v.setDoctorsInfo(
          doctor!.firstName, doctor.lastName, doctor.email, doctor.phone);
    }

    return citizenData;
  }

  String getField(DocumentSnapshot document, String field) {
    try {
      document.get(FieldPath([field]));
    } catch (e) {
      return "-";
    }
    return document[field] == "" ? "-" : document[field];
  }

  String getFieldQuery(QueryDocumentSnapshot document, String field) {
    try {
      document.get(FieldPath([field]));
    } catch (e) {
      return "-";
    }
    return document[field] == "" ? "-" : document[field];
  }

  List<String> getFieldArrayQuery(
      QueryDocumentSnapshot document, String field) {
    try {
      document.get(FieldPath([field]));
    } catch (e) {
      return ["-"];
    }
    return List<String>.from(document[field].isEmpty ? ["-"] : document[field]);
  }

  Map<String, PSS> _citizenFromFirebase(
      QuerySnapshot snapshot, Citizen citizen) {
    Map<String, PSS> data = {};
    PSS patient;

    for (var element in snapshot.docs) {
      patient = PSS(
          citizen,
          getFieldArrayQuery(element, "actualPathologies"),
          getFieldQuery(element, "adi"),
          getFieldQuery(element, "adp"),
          getFieldQuery(element, "adverseReactions"),
          getFieldQuery(element, "aids"),
          getFieldQuery(element, "bloodGroup"),
          getFieldQuery(element, "rhFactor"),
          getFieldQuery(element, "bloodPressure"),
          getFieldQuery(element, "bmi"),
          getFieldArrayQuery(element, "chronicPathologies"),
          getFieldQuery(element, "chronicPharmacologicalTherapies"),
          getFieldQuery(element, "date"),
          getFieldQuery(element, "email"),
          getFieldQuery(element, "firstName"),
          getFieldQuery(element, "height"),
          getFieldQuery(element, "lastName"),
          getFieldQuery(element, "medicalHistory"),
          getFieldQuery(element, "missingOrgans"),
          getFieldQuery(element, "motorSkills"),
          getFieldQuery(element, "organDonation"),
          getFieldQuery(element, "othersPharmacologicalTherapies"),
          getFieldQuery(element, "pec"),
          getFieldQuery(element, "phone"),
          getFieldQuery(element, "pregnancies"),
          getFieldQuery(element, "prosthetics"),
          getFieldQuery(element, "relevantMalformations"),
          getFieldQuery(element, "riskFactors"),
          getFieldQuery(element, "skinAllergies"),
          getFieldQuery(element, "transplants"),
          getFieldQuery(element, "vaccinations"),
          getFieldQuery(element, "venomAllergies"),
          getFieldQuery(element, "weight"),
          getFieldQuery(element, "workingActivity"),
          getFieldQuery(element, "familyHealthHistory"),
          getFieldQuery(element, "atsCode"),
          getFieldQuery(element, "exemptionCodes"),
          getFieldQuery(element, "userArea"),
          getFieldQuery(element, "pathologyNetworks"),
          getFieldQuery(element, "associations"),
          getFieldQuery(element, "livesAlone"));
      data.addAll({fromMillisecondsToDate(element.id): patient});
    }
    return data;
  }

  Future<List<Citizen>> getCitizensList(String cf) async {
    Map<String, PSS>? citizensMap = {};
    String emptyString = "";

    return await populateCitizensFields(
        await patients.where("cfVolunteer", isEqualTo: cf).get().then(
              (value) => value.docs
                  .map((e) => Citizen(
                      e.id,
                      emptyString,
                      emptyString,
                      emptyString,
                      emptyString,
                      emptyString,
                      emptyString,
                      cf,
                      getFieldQuery(e, "cfDoctor"),
                      getFieldQuery(e, "dateOfBirth"),
                      getFieldQuery(e, "cityOfBirth"),
                      getFieldQuery(e, "provinceOfBirth"),
                      getFieldQuery(e, "idCardNumber"),
                      getFieldQuery(e, "idCardReleaseCity"),
                      getFieldQuery(e, "idCardReleaseDate"),
                      getFieldQuery(e, "idCardExpirationDate"),
                      getFieldQuery(e, "genre"),
                      getFieldQuery(e, "domicile"),
                      getFieldQuery(e, "domicileAddress"),
                      getFieldQuery(e, "domicileProvince"),
                      getFieldQuery(e, "domicileCap"),
                      getFieldQuery(e, "crs"),
                      getFieldQuery(e, "firstICEContactInfo"),
                      getFieldQuery(e, "firstICEContactPhone"),
                      getFieldQuery(e, "secondICEContactInfo"),
                      getFieldQuery(e, "secondICEContactPhone"),
                      getFieldQuery(e, "infoCaregiver"),
                      getFieldQuery(e, "phoneCaregiver"),
                      citizensMap))
                  .toList(),
            ));
  }

  Future<List<Citizen>> populateCitizensFields(
      List<Citizen> citizensList) async {
    for (Citizen element in citizensList) {
      await patients.doc(element.cf).collection('pss').get().then((value) {
        element.data = _citizenFromFirebase(value, element);
      });

      await users.where("cf", isEqualTo: element.cf).get().then((value) {
        element.email = getField(value.docs[0], "email");
        element.firstName = getField(value.docs[0], "firstName");
        element.lastName = getField(value.docs[0], "lastName");
        element.photoUrl = getField(value.docs[0], "photoUrl");
        element.pec = getField(value.docs[0], "pec");
        element.phone = getField(value.docs[0], "phone");
      });
    }
    return citizensList;
  }

  editCitizenFields(Citizen newCitizen, Uint8List? photoBytes) async {
    DocumentSnapshot snapshot =
        await users.where('cf', isEqualTo: newCitizen.cf).get().then((value) {
      return value.docs[0];
    });

    setField(snapshot, "firstName", newCitizen.firstName);
    setField(snapshot, "lastName", newCitizen.lastName);
    setField(snapshot, "phone", newCitizen.phone);
    setField(snapshot, "pec", newCitizen.pec);

    if (photoBytes != null) {
      await firebaseStorageRef
          .child("images/${newCitizen.cf}")
          .putData(photoBytes)
          .then((_) async => setField(
              snapshot,
              "photoUrl",
              await firebaseStorageRef
                  .child("images/${newCitizen.cf}")
                  .getDownloadURL()));
    }

    snapshot = await patients.doc(newCitizen.cf).get().then((value) {
      return value;
    });

    setField(snapshot, "genre", newCitizen.genre);
    setField(snapshot, "dateOfBirth", newCitizen.dateOfBirth);
    setField(snapshot, "cityOfBirth", newCitizen.cityOfBirth);
    setField(snapshot, "domicile", newCitizen.domicile);
    setField(snapshot, "infoCaregiver", newCitizen.infoCaregiver);
    setField(snapshot, "phoneCaregiver", newCitizen.phoneCaregiver);
    setField(snapshot, "provinceOfBirth", newCitizen.provinceOfBirth);
    setField(snapshot, "idCardNumber", newCitizen.idCardNumber);
    setField(snapshot, "idCardReleaseCity", newCitizen.idCardReleaseCity);
    setField(snapshot, "idCardReleaseDate", newCitizen.idCardReleaseDate);
    setField(snapshot, "idCardExpirationDate", newCitizen.idCardExpirationDate);
    setField(snapshot, "domicileAddress", newCitizen.domicileAddress);
    setField(snapshot, "domicileProvince", newCitizen.domicileProvince);
    setField(snapshot, "domicileCap", newCitizen.domicileCap);
    setField(snapshot, "crs", newCitizen.crs);
    setField(snapshot, "firstICEContactInfo", newCitizen.firstICEContactInfo);
    setField(snapshot, "firstICEContactPhone", newCitizen.firstICEContactPhone);
    setField(snapshot, "secondICEContactInfo", newCitizen.secondICEContactInfo);
    setField(
        snapshot, "secondICEContactPhone", newCitizen.secondICEContactPhone);
  }

  setField(DocumentSnapshot document, String field, dynamic fieldValue) {
    document.reference.update({field: fieldValue == "-" ? "" : fieldValue});
  }

  createField(DocumentSnapshot document, String field, dynamic fieldValue) {
    document.reference.set({field: fieldValue == "-" ? "" : fieldValue});
  }

  createPSS(UserPSS userPSS, String userCF) async {
    DocumentSnapshot pssSnapshot = await patients
        .doc(userCF)
        .collection('pss')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .get()
        .then((value) {
      return value;
    });

    createField(pssSnapshot, "actualPathologies",
        stringToArray(userPSS.actualPathologies.text));

    setField(pssSnapshot, "adi", userPSS.adi.text);
    setField(pssSnapshot, "adp", userPSS.adp.text);
    setField(pssSnapshot, "adverseReactions", userPSS.adverseReactions.text);
    setField(pssSnapshot, "aids", userPSS.aids.text);
    setField(pssSnapshot, "bloodGroup", userPSS.bloodGroup.text);
    setField(pssSnapshot, "rhFactor", userPSS.rhFactor.text);
    setField(pssSnapshot, "bloodPressure", userPSS.bloodPressure.text);
    setField(pssSnapshot, "bmi", userPSS.bmi.text);
    setField(pssSnapshot, "chronicPathologies",
        stringToArray(userPSS.chronicPathologies.text));
    setField(pssSnapshot, "chronicPharmacologicalTherapies",
        userPSS.chronicPharmacologicalTherapies.text);
    setField(pssSnapshot, "date", userPSS.mmgBirthDate.text);
    setField(pssSnapshot, "email", userPSS.mmgEmail.text);
    setField(pssSnapshot, "firstName", userPSS.mmgFirstName.text);
    setField(pssSnapshot, "height", userPSS.height.text);
    setField(pssSnapshot, "lastName", userPSS.mmgLastName.text);
    setField(pssSnapshot, "medicalHistory", userPSS.medicalHistory.text);
    setField(pssSnapshot, "missingOrgans", userPSS.missingOrgans.text);
    setField(pssSnapshot, "motorSkills", userPSS.motorSkills.text);
    setField(pssSnapshot, "organDonation", userPSS.organDonation.text);
    setField(pssSnapshot, "othersPharmacologicalTherapies",
        userPSS.othersPharmacologicalTherapies.text);
    setField(pssSnapshot, "pec", userPSS.mmgPec.text);
    setField(pssSnapshot, "phone", userPSS.mmgPhone.text);
    setField(pssSnapshot, "pregnancies", userPSS.pregnancies.text);
    setField(pssSnapshot, "prosthetics", userPSS.prosthetics.text);
    setField(pssSnapshot, "relevantMalformations",
        userPSS.relevantMalformations.text);
    setField(pssSnapshot, "riskFactors", userPSS.riskFactors.text);
    setField(pssSnapshot, "skinAllergies", userPSS.skinAllergies.text);
    setField(pssSnapshot, "transplants", userPSS.transplants.text);
    setField(pssSnapshot, "vaccinations", userPSS.vaccinations.text);
    setField(pssSnapshot, "venomAllergies", userPSS.venomAllergies.text);
    setField(pssSnapshot, "weight", userPSS.weight.text);
    setField(pssSnapshot, "workingActivity", userPSS.workingActivity.text);
    setField(
        pssSnapshot, "familyHealthHistory", userPSS.familyHealthHistory.text);
    setField(pssSnapshot, "atsCode", userPSS.atsCode.text);
    setField(pssSnapshot, "exemptionCodes", userPSS.exemptionCodes.text);
    setField(pssSnapshot, "userArea", userPSS.userArea.text);
    setField(pssSnapshot, "pathologyNetworks", userPSS.pathologyNetworks.text);
    setField(pssSnapshot, "associations", userPSS.associations.text);
    setField(pssSnapshot, "livesAlone", userPSS.livesAlone.text);
  }

  Future<bool> createUser(UserData userData, String cfVolunteer) async {
    String? newUserUid = await AuthService().createUser(userData.email.text);
    if (newUserUid != null) {
      await users.doc(newUserUid).get().then((value) => {
            createField(value, "cf", userData.cf.text),
            setField(value, "email", userData.email.text),
            setField(value, "firstName", userData.firstName.text),
            setField(value, "lastName", userData.lastName.text),
            setField(value, "pec", userData.pec.text),
            setField(value, "phone", userData.phone.text),
            setField(value, "photoUrl", userData.photoUrl),
            setField(value, "userType", "cittadino"),
          });
      await patients.doc(userData.cf.text).get().then((value) => {
            createField(value, "cfVolunteer", cfVolunteer),
            setField(value, "cityOfBirth", userData.cityOfBirth.text),
            setField(value, "crs", userData.crs.text),
            setField(value, "dateOfBirth", userData.dateOfBirth.text),
            setField(value, "domicile", userData.domicile.text),
            setField(value, "domicileAddress", userData.domicileAddress.text),
            setField(value, "domicileCap", userData.domicileCap.text),
            setField(value, "domicileProvince", userData.domicileProvince.text),
            setField(value, "firstICEContactInfo",
                userData.firstICEContactInfo.text),
            setField(value, "firstICEContactPhone",
                userData.firstICEContactPhone.text),
            setField(value, "secondICEContactInfo",
                userData.secondICEContactInfo.text),
            setField(value, "secondICEContactPhone",
                userData.secondICEContactPhone.text),
            setField(value, "genre", userData.genre.text),
            setField(value, "idCardExpirationDate",
                userData.idCardExpirationDate.text),
            setField(value, "idCardNumber", userData.idCardNumber.text),
            setField(
                value, "idCardReleaseCity", userData.idCardReleaseCity.text),
            setField(value, "infoCaregiver", userData.infoCaregiver.text),
            setField(value, "phoneCaregiver", userData.phoneCaregiver.text),
            setField(value, "provinceOfBirth", userData.provinceOfBirth.text),
          });
      return true;
    }
    return false;
  }

  deleteUser(String userCF) async {}

  Future<bool> checkIfCFInUse(String cf) async {
    var doc = await patients.doc(cf).get();
    return doc.exists;
  }
}
