import 'package:new_dhc/model/citizen.dart';
import 'package:new_dhc/model/utils.dart';

import '../constants.dart';

class PSS {
  Citizen citizen;
  List<String?> actualPathologies;
  String adi;
  String adp;
  String adverseReactions;
  String aids;
  String bloodGroup;
  String rhFactor;
  String bloodPressure;
  String bmi;
  List<String?> chronicPathologies;
  String chronicPharmacologicalTherapies;
  String mmgBirthDate;
  String mmgEmail;
  String mmgFirstName;
  String height;
  String mmgLastName;
  String medicalHistory;
  String missingOrgans;
  String motorSkills;
  String organDonation;
  String othersPharmacologicalTherapies;
  String mmgPec;
  String mmgPhone;
  String pregnancies;
  String prosthetics;
  String relevantMalformations;
  String riskFactors;
  String skinAllergies;
  String transplants;
  String vaccinations;
  String venomAllergies;
  String weight;
  String workingActivity;
  String familyHealthHistory;
  String atsCode;
  String exemptionCodes;
  String userArea;
  String pathologyNetworks;
  String associations;
  String livesAlone;

  PSS(
      this.citizen,
      this.actualPathologies,
      this.adi,
      this.adp,
      this.adverseReactions,
      this.aids,
      this.bloodGroup,
      this.rhFactor,
      this.bloodPressure,
      this.bmi,
      this.chronicPathologies,
      this.chronicPharmacologicalTherapies,
      this.mmgBirthDate,
      this.mmgEmail,
      this.mmgFirstName,
      this.height,
      this.mmgLastName,
      this.medicalHistory,
      this.missingOrgans,
      this.motorSkills,
      this.organDonation,
      this.othersPharmacologicalTherapies,
      this.mmgPec,
      this.mmgPhone,
      this.pregnancies,
      this.prosthetics,
      this.relevantMalformations,
      this.riskFactors,
      this.skinAllergies,
      this.transplants,
      this.vaccinations,
      this.venomAllergies,
      this.weight,
      this.workingActivity,
      this.familyHealthHistory,
      this.atsCode,
      this.exemptionCodes,
      this.userArea,
      this.pathologyNetworks,
      this.associations,
      this.livesAlone);

  setDoctorsInfo(String mmgFirstName, String mmgLastName, String mmgEmail,
      String mmgPhone) {
    this.mmgFirstName = mmgFirstName;
    this.mmgLastName = mmgLastName;
    this.mmgEmail = mmgEmail;
    this.mmgPhone = mmgPhone;
  }

  String getRhFactor() {
    if (rhFactor == "Positivo") {
      return "+";
    } else {
      return "-";
    }
  }

  String getLifeSavingInformation() {
    String? firstName = citizen.firstName;
    String? lastName = citizen.lastName;
    String? dateOfBirth = citizen.dateOfBirth;
    String? firstICEContactInfo = citizen.firstICEContactInfo;
    String? firstICEContactPhone = citizen.firstICEContactPhone;
    String? secondICEContactInfo = citizen.secondICEContactInfo;
    String? secondICEContactPhone = citizen.secondICEContactPhone;

    return "$datiSalvavita${aCapo}Nome: $firstName$space$lastName${aCapo}Data di nascita: $dateOfBirth${aCapo}Gruppo sanguigno: $bloodGroup${getRhFactor()}${aCapo}Contatto ICE1: $firstICEContactInfo$dash$firstICEContactPhone${aCapo}Contatto ICE2: $secondICEContactInfo$dash$secondICEContactPhone${aCapo}Allergie: $skinAllergies${aCapo}Patologie in atto: ${arrayToString(actualPathologies)}${aCapo}Patologie croniche: ${arrayToString(chronicPathologies)}${aCapo}Terapie: $chronicPharmacologicalTherapies";
  }

  Map<String, String?> toMapPSSSectionZero() {
    return {
      'Nome': "${citizen.firstName} ${citizen.lastName}",
      'Data di nascita': citizen.dateOfBirth,
      'Codice fiscale': citizen.cf,
      'Numero carta d\'identità': citizen.idCardNumber,
      'Comune di rilascio': citizen.idCardReleaseCity,
      'Data di scadenza': citizen.idCardExpirationDate,
      'Carta regionale dei servizi': citizen.crs,
      'Sesso': citizen.genre,
      'Comune di nascita': citizen.cityOfBirth,
      'Provincia di nascita': citizen.provinceOfBirth,
      'Indirizzo di domicilio': citizen.domicileAddress,
      'Comune di domicilio': citizen.domicile,
      'Provincia di domicilio': citizen.domicileProvince,
      'CAP': citizen.domicileCap,
      'Email': citizen.email,
      'Telefono': citizen.phone,
      'Pec': citizen.pec,
      'Attività lavorativa': workingActivity,
    };
  }

  //dati personali
  Map<String, String?> toMapPSSSectionOne() {
    return {
      'Altezza': height,
      'Peso': weight,
      'BMI': bmi,
      'Gruppo sanguigno': "$bloodGroup${getRhFactor()}",
      'Pressione arteriosa': bloodPressure,
      'Donazione organi': organDonation,
      'Gravidanze e parti': pregnancies,
      'Vaccinazioni': vaccinations,
    };
  }

  //contatti
  Map<String, String?> toMapPSSSectionTwo() {
    return {
      "Contatto di emergenza 1":
          "${citizen.firstICEContactInfo} - ${citizen.firstICEContactPhone}",
      "Contatto di emergenza 2":
          "${citizen.secondICEContactInfo} - ${citizen.secondICEContactPhone}",
      "Contatto caregiver":
          "${citizen.infoCaregiver} - ${citizen.phoneCaregiver}",
      'Vive solo': livesAlone,
    };
  }

  //allergie
  Map<String, String?> toMapPSSSectionThree() {
    return {
      'Allergie cutanee, respiratorie e sistemiche': skinAllergies,
      'Allergie a veleno di imenotteri': venomAllergies,
      'Reazioni avverse a farmaci e alimenti': adverseReactions,
    };
  }

  //patologie e terapie
  Map<String, String?> toMapPSSSectionFour() {
    return {
      'Patologie croniche rilevanti': arrayToString(chronicPathologies),
      'Patologie in atto': arrayToString(actualPathologies),
      'Terapie farmacologiche croniche': chronicPharmacologicalTherapies,
      'Terapie farmacologiche': othersPharmacologicalTherapies,
      "Anamnesi familiare": familyHealthHistory,
      'Fattori di rischio': riskFactors,
      'Capacità motoria': motorSkills,
      'Ausili': aids,
      'Protesi': prosthetics,
      'Organi mancanti': missingOrgans,
      'Trapianti': transplants,
      'Malformazioni rilevanti': relevantMalformations,
    };
  }

  //rete sanitaria
  Map<String, String?> toMapPSSSectionFive() {
    return {
      'ADI': adi,
      'ADP': adp,
      'Area d\'utenza': userArea,
      'Codice ATS': atsCode,
      'Codici di esenzione': exemptionCodes,
      'Reti di patologie': pathologyNetworks,
      'Servizio o associazione': associations,
    };
  }

  Map<String, String?> toMapSheetSectionOne() {
    return {
      'Nome e Cognome': citizen.fullName,
      'Data di nascita': citizen.dateOfBirth,
      'Indirizzo': citizen.domicileAddress,
      'Città': citizen.domicile,
      'C.I n°': citizen.idCardNumber,
      'Comune di rilascio': citizen.idCardReleaseCity,
      'Data di rilascio': citizen.idCardReleaseDate,
      'Codice Fiscale': citizen.cf
    };
  }

  Map<String, String?> toMapSheetSectionTwo() {
    return {
      'CRS n°': citizen.crs,
      'Codice di esenzione': exemptionCodes,
      'Codice ATS assistito': atsCode,
      'Medico Curante': "$mmgFirstName $mmgLastName",
      'Telefono': mmgPhone,
      'Email': mmgEmail
    };
  }

  Map<String, String?> toMapSheetSectionThree() {
    return {
      'Nome e Cognome ICE 1': citizen.firstICEContactInfo,
      'Telefono 1': citizen.firstICEContactPhone,
      'Nome e Cognome ICE 2': citizen.secondICEContactInfo,
      'Telefono 2': citizen.secondICEContactPhone
    };
  }

  Map<String, String?> toMapSheetSectionFour() {
    return {
      'Gruppo sanguigno': bloodGroup,
      'Fattore Rh': rhFactor,
      'Patologie': arrayToString(chronicPathologies),
      'Allergie ed intolleranze gravi': skinAllergies
    };
  }

  Map<String, String?> toMapIta() {
    return {
      'Nome': citizen.fullName,
      'Data di nascita': citizen.dateOfBirth,
      'Gruppo sanguigno': "$bloodGroup${getRhFactor()}",
      'Contatto ICE1': citizen.firstICEContactInfo,
      'Contatto ICE2': citizen.secondICEContactInfo,
      'Allergie': skinAllergies,
      'Patologie in atto': arrayToString(actualPathologies),
      'Patologie croniche': arrayToString(chronicPathologies),
      'Terapie': othersPharmacologicalTherapies
    };
  }
}
