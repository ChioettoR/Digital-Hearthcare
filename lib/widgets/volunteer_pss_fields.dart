import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_dhc/form_validation.dart';
import 'package:new_dhc/model/user_pss.dart';
import 'package:new_dhc/widgets/custom_dropdown_edit_field.dart';
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
    return OverflowBar(
        alignment: MainAxisAlignment.start,
        overflowSpacing: 15,
        overflowAlignment: OverflowBarAlignment.start,
        children: [
          SizedBox(
              width: 250,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      textAlign: TextAlign.left,
                      'Peso:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.weight, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Altezza:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.height, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Pressione arteriosa:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.bloodPressure, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'BMI:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.bmi, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Gruppo sanguigno:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomDropdownEditField(
                        null, true, userPSS.bloodGroup, false, const [
                      DropDownValueModel(name: 'A', value: "A"),
                      DropDownValueModel(name: 'B', value: "B"),
                      DropDownValueModel(name: 'AB', value: "AB"),
                      DropDownValueModel(name: '0', value: "0")
                    ]),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Fattore Rh:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomDropdownEditField(
                        null, true, userPSS.rhFactor, false, const [
                      DropDownValueModel(name: 'Positivo', value: "Positivo"),
                      DropDownValueModel(name: 'Negativo', value: "Negativo"),
                    ]),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Patologie in atto:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(
                        null, true, userPSS.actualPathologies, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Patologie croniche:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(
                        null, true, userPSS.chronicPathologies, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Terapie farmacologiche croniche:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true,
                        userPSS.chronicPharmacologicalTherapies, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Altre terapie farmacologiche:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true,
                        userPSS.othersPharmacologicalTherapies, false),
                  ])),
          SizedBox(
              width: 250,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      textAlign: TextAlign.left,
                      'ADI:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomDropdownEditField(
                        null, true, userPSS.adi, false, const [
                      DropDownValueModel(name: 'Sì', value: "Sì"),
                      DropDownValueModel(name: 'No', value: "No"),
                    ]),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'ADP:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomDropdownEditField(
                        null, true, userPSS.adp, false, const [
                      DropDownValueModel(name: 'Sì', value: "Sì"),
                      DropDownValueModel(name: 'No', value: "No"),
                    ]),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Storia medica:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.medicalHistory, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Anamnesi Famigliari:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(
                        null, true, userPSS.familyHealthHistory, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Cognome MMG:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.mmgLastName, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Nome MMG:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.mmgFirstName, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Data di nascita MMG:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.mmgBirthDate, false,
                        validation: dateValidation,
                        onTapFunction: requestMMGBirthDate),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Email MMG:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.mmgEmail, false,
                        validation: emailValidation),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Pec MMG:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.mmgPec, false,
                        validation: emailValidation),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Telefono MMG:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditPhoneField(null, true, userPSS.mmgPhone)
                  ])),
          SizedBox(
              width: 250,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      textAlign: TextAlign.left,
                      'Organi mancanti:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.missingOrgans, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Donazione organi:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.organDonation, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Trapianti:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.transplants, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Gravidanze e parti:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.pregnancies, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Rilevanti malformazioni:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(
                        null, true, userPSS.relevantMalformations, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Fattori di rischio:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.riskFactors, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Reazioni avverse:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(
                        null, true, userPSS.adverseReactions, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Allergie:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.skinAllergies, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Allergie a veleno di imenotteri:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.venomAllergies, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Vaccinazioni:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.vaccinations, false)
                  ])),
          SizedBox(
              width: 250,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      textAlign: TextAlign.left,
                      'Ausili:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.aids, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Protesi:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.prosthetics, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Capacità motoria:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.motorSkills, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Attività lavorativa:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.workingActivity, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Codice ATS:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.atsCode, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Codici di esenzione:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.exemptionCodes, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Area d\'utenza:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.userArea, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Reti di patologie:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(
                        null, true, userPSS.pathologyNetworks, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Servizio o associazione:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomEditField(null, true, userPSS.associations, false),
                    const SizedBox(height: 10),
                    const Text(
                      textAlign: TextAlign.left,
                      'Vive solo:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomDropdownEditField(
                        null, true, userPSS.livesAlone, false, const [
                      DropDownValueModel(name: 'Sì', value: "Sì"),
                      DropDownValueModel(name: 'No', value: "No"),
                    ])
                  ]))
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
