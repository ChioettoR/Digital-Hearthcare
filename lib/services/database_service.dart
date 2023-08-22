import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_dhc/model/end_user.dart';

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

  Future<EndUser> getUser() {
    return users
        .doc(_auth.getCurrentUser()?.uid)
        .get()
        .then((value) => _userFromFirebase(value));
  }

  EndUser _userFromFirebase(DocumentSnapshot snapshot) {
    return EndUser(
        cf: snapshot['cf'],
        email: snapshot['email'],
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        phone: snapshot['phone'],
        pec: snapshot['pec'],
        photoUrl: snapshot['photoUrl'],
        userType: snapshot['userType']);
  }

  Future<List<dynamic>> getCitizen(EndUser endUser) async {
    List<dynamic> citizenData = [];
    String? cfVolunteer;
    String? cfDoctor;
    String? dateOfBirth;
    String? genre;
    String? domicile;
    String? cityOfBirth;
    String? provinceOfBirth;
    String? idCardNumber;
    String? idCardReleaseCity;
    String? idCardReleaseDate;
    String? idCardExpirationDate;
    String? domicileAddress;
    String? domicileProvince;
    String? domicileCap;
    String? crs;
    String? firstICEContactInfo;
    String? firstICEContactPhone;
    String? secondICEContactInfo;
    String? secondICEContactPhone;

    Volunteer? volunteer;
    Doctor? doctor;
    Map<String, PSS>? citizenMap;
    String? infoCaregiver;
    String? phoneCaregiver;

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

    doctor = await users.where('cf', isEqualTo: cfDoctor).get().then(
        (querySnapshot) => Doctor(
            getFieldQuery(querySnapshot.docs[0], "cf"),
            getFieldQuery(querySnapshot.docs[0], "firstName"),
            getFieldQuery(querySnapshot.docs[0], "lastName"),
            getFieldQuery(querySnapshot.docs[0], "email"),
            getFieldQuery(querySnapshot.docs[0], "pec"),
            getFieldQuery(querySnapshot.docs[0], "phone")));

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

  Map<String, PSS> _citizenFromFirebase(
      QuerySnapshot snapshot, Citizen citizen) {
    Map<String, PSS> data = {};
    PSS patient;
    for (var element in snapshot.docs) {
      patient = PSS(
          citizen: citizen,
          actualPathologies: getFieldQuery(element, "actualPathologies"),
          adi: getFieldQuery(element, "adi"),
          adp: getFieldQuery(element, "adp"),
          adverseReactions: getFieldQuery(element, "adverseReactions"),
          aids: getFieldQuery(element, "aids"),
          bloodGroup: getFieldQuery(element, "bloodGroup"),
          bloodPressure: getFieldQuery(element, "bloodPressure"),
          rhFactor: getFieldQuery(element, "rhFactor"),
          bmi: getFieldQuery(element, "bmi"),
          cf: getFieldQuery(element, "cf"),
          chronicPathologies: getFieldQuery(element, "chronicPathologies"),
          chronicPharmacologicalTherapies:
              getFieldQuery(element, "chronicPharmacologicalTherapies"),
          mmgBirthDate: getFieldQuery(element, "date"),
          mmgEmail: getFieldQuery(element, "email"),
          mmgFirstName: getFieldQuery(element, "firstName"),
          height: getFieldQuery(element, "height"),
          mmgLastName: getFieldQuery(element, "lastName"),
          medicalHistory: getFieldQuery(element, "medicalHistory"),
          missingOrgans: getFieldQuery(element, "missingOrgans"),
          motorSkills: getFieldQuery(element, "motorSkills"),
          organDonation: getFieldQuery(element, "organDonation"),
          othersPharmacologicalTherapies:
              getFieldQuery(element, "othersPharmacologicalTherapies"),
          mmgPec: getFieldQuery(element, "pec"),
          mmgPhone: getFieldQuery(element, "phone"),
          pregnancies: getFieldQuery(element, "pregnancies"),
          prosthetics: getFieldQuery(element, "prosthetics"),
          relevantMalformations:
              getFieldQuery(element, "relevantMalformations"),
          riskFactors: getFieldQuery(element, "riskFactors"),
          skinAllergies: getFieldQuery(element, "skinAllergies"),
          transplants: getFieldQuery(element, "transplants"),
          vaccinations: getFieldQuery(element, "vaccinations"),
          venomAllergies: getFieldQuery(element, "venomAllergies"),
          weight: getFieldQuery(element, "weight"),
          workingActivity: getFieldQuery(element, "workingActivity"),
          familyHealthHistory: getFieldQuery(element, "familyHealthHistory"),
          atsCode: getFieldQuery(element, "atsCode"),
          exemptionCodes: getFieldQuery(element, "exemptionCodes"),
          userArea: getFieldQuery(element, "userArea"),
          pathologyNetworks: getFieldQuery(element, "pathologyNetworks"),
          associations: getFieldQuery(element, "associations"),
          livesAlone: getFieldQuery(element, "livesAlone"));
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
}
