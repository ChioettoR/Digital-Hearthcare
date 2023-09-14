import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_dhc/form_validation.dart';
import 'package:new_dhc/model/user_pss.dart';
import 'package:new_dhc/widgets/custom_dropdown_edit_field.dart';
import 'package:new_dhc/widgets/custom_dropdown_multi_edit_field.dart';
import 'package:new_dhc/widgets/custom_edit_field.dart';
import 'package:new_dhc/widgets/custom_edit_phone_field.dart';

class VolunteerPSSFields extends StatefulWidget {
  final String userCF;

  const VolunteerPSSFields(this.userCF, {super.key});

  @override
  State<VolunteerPSSFields> createState() => VolunteerPSSFieldsState();
}

class VolunteerPSSFieldsState extends State<VolunteerPSSFields> {
  late UserPSS userPSS;
  List boxes = ["box1", "box2", "box3", "box4", "box5", "box6"];

  @override
  void initState() {
    userPSS = UserPSS();
    super.initState();
  }

  @override
  void dispose() {
    userPSS.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("DATI SANITARI DEL PAZIENTE",
              style: TextStyle(
                  color: Colors.redAccent,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          const Divider(height: 0, color: Colors.redAccent),
          const SizedBox(height: 30),
          Wrap(spacing: 10, children: [
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Capacità motoria:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.motorSkills, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Attività lavorativa:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(
                          null, true, userPSS.workingActivity, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Patologie croniche:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomDropdownMultiEditField(
                          null, true, userPSS.chronicPathologies, const [
                        "Allergie SAI (995.3)",
                        "Aneurismi: aorta (441*)",
                        "Aritmie cardiache (427*)",
                        "Insuff. respiratoria cronica (518.83)",
                        "Epilessia (345*)",
                        "Traumi recenti (800*-859*)",
                        "Elementi di sintesi ferromagnetici (RMN): protesi e/o impianti",
                        "Terapia antiaggregante (B01AC*)",
                        "Cardiopatia ischemica (410* 414*)",
                        "Aneurismi: altre sedi (442*)",
                        "Portatore di pacemaker",
                        "Patologia oncologica (140*-239*)",
                        "Epatite virale (070.*)",
                        "Terapia anticoagulante (warfarin/acenocumarolo) (B01AA03/B01AA07)",
                        "Terapia con insulina (A010A*)",
                        "IMA pregresso (412)",
                        "Ipertensione arteriosa (401*-405*)",
                        "Malattie cerebrovascolari (430*-438*)",
                        "Patologie neurologiche (20* 326*)",
                        "Insuff. renale cronica (585)",
                        "Infezione HIV (0.42)",
                        "Inibitori diretti Trombina (B01AE*)"
                      ]),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Organi mancanti:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.missingOrgans, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Trapianti:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.transplants, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Malformazioni rilevanti:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(
                          null, true, userPSS.relevantMalformations, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Reazioni avverse:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(
                          null, true, userPSS.adverseReactions, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Allergie:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.skinAllergies, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Allergie a veleno di imenotteri:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(
                          null, true, userPSS.venomAllergies, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Protesi:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.prosthetics, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Ausili:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.aids, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Patologie in atto:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomDropdownMultiEditField(
                          null, true, userPSS.actualPathologies, const [
                        "Cardiache",
                        "Oculari",
                        "Renali",
                        "Muscolo-scheletriche",
                        "Ipertensione arteriosa",
                        "Otorinolaringoiatriche",
                        "Genitali-urinarie",
                        "Endocrino-metaboliche",
                        "Respiratorie",
                        "Gastroenteriche",
                        "Cutanee",
                        "Psichiatrico-comportamentale"
                      ]),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Terapie farmacologiche croniche:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true,
                          userPSS.chronicPharmacologicalTherapies, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Altre terapie farmacologiche:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true,
                          userPSS.othersPharmacologicalTherapies, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Vaccinazioni:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.vaccinations, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Codice ATS:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.atsCode, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Codici di esenzione:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(
                          null, true, userPSS.exemptionCodes, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Area d\'utenza:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.userArea, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Reti di patologie:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(
                          null, true, userPSS.pathologyNetworks, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Servizio o associazione:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.associations, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Vive solo:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomDropdownEditField(
                          null, true, userPSS.livesAlone, const ['Sì', 'No']),
                      const SizedBox(height: 30),
                    ])),
          ]),
          const Text("DATI DEL MEDICO",
              style: TextStyle(
                  color: Colors.redAccent,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          const Divider(height: 0, color: Colors.redAccent),
          const SizedBox(height: 30),
          Wrap(spacing: 10, children: [
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Cognome:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.mmgLastName, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Nome:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.mmgFirstName, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Codice fiscale:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.mmgCf, false,
                          maxLength: 16, validation: cfValidation),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Data di nascita:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.mmgBirthDate, false,
                          validation: dateValidation,
                          onTapFunction: requestMMGBirthDate),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Email:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.mmgEmail, false,
                          validation: emailValidation),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Pec:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.mmgPec, false,
                          validation: emailValidation),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Telefono:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditPhoneField(
                        null,
                        true,
                        userPSS.mmgPhone,
                      ),
                      const SizedBox(height: 30),
                    ])),
          ]),
          const Text("PARAMETRI DI MONITORAGGIO",
              style: TextStyle(
                  color: Colors.redAccent,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          const Divider(height: 0, color: Colors.redAccent),
          const SizedBox(height: 30),
          Wrap(spacing: 10, children: [
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Peso:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.weight, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Altezza:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.height, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Pressione arteriosa:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.bloodPressure, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'BMI:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.bmi, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Gruppo sanguigno:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomDropdownEditField(null, true, userPSS.bloodGroup,
                          const ['A', 'B', 'AB', '0']),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Fattore Rh:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomDropdownEditField(null, true, userPSS.rhFactor,
                          const ['Positivo', 'Negativo']),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'ADI:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomDropdownEditField(
                          null, true, userPSS.adi, const ['Sì', 'No']),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'ADP:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomDropdownEditField(
                          null, true, userPSS.adp, const ['Sì', 'No']),
                      const SizedBox(height: 30),
                    ])),
          ]),
          const Text("ANAMNESI ED INFORMAZIONI",
              style: TextStyle(
                  color: Colors.redAccent,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          const Divider(height: 0, color: Colors.redAccent),
          const SizedBox(height: 30),
          Wrap(spacing: 10, children: [
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Storia medica:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(
                          null, true, userPSS.medicalHistory, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Anamnesi familiare:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(
                          null, true, userPSS.familyHealthHistory, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Donazione organi:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.organDonation, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Gravidanze e parti:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.pregnancies, false),
                      const SizedBox(height: 30),
                    ])),
            SizedBox(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        textAlign: TextAlign.left,
                        'Fattori di rischio:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomEditField(null, true, userPSS.riskFactors, false),
                      const SizedBox(height: 30),
                    ])),
          ])
        ]);
  }

  requestMMGBirthDate() async {
    //FocusScope.of(context).requestFocus(FocusNode());
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100, DateTime.now().month,
            DateTime.now().day),
        lastDate: DateTime.now());
    if (picked != null) {
      userPSS.mmgBirthDate.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  UserPSS retrieveData() {
    return userPSS;
  }
}
