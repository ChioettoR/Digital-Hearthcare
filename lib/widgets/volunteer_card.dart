import 'package:flutter/material.dart';
import 'package:new_dhc/constants.dart';
import 'package:new_dhc/model/user_data.dart';
import 'package:new_dhc/widgets/custom_edit_field.dart';
import 'package:new_dhc/widgets/custom_edit_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';

import '../model/citizen.dart';
import '../services/pdf_handler.dart';
import 'function_button.dart';

class VolunteerCard extends StatefulWidget {
  final Citizen citizen;
  final int index;
  final dynamic getDate;
  final dynamic setDate;
  final dynamic removePatient;

  const VolunteerCard(
      this.citizen, this.index, this.getDate, this.setDate, this.removePatient,
      {super.key});

  @override
  State<VolunteerCard> createState() => _VolunteerCardState();
}

class _VolunteerCardState extends State<VolunteerCard> {
  late String currentDate;
  bool isEditing = false;
  late UserData userData;
  final _editingFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    userData = UserData(widget.citizen);
    isEditing = false;
    currentDate = widget.citizen.data!.keys.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton(
                  icon: const Icon(Icons.calendar_today),
                  initialValue: currentDate,
                  itemBuilder: (BuildContext context) {
                    return widget.citizen.data!.keys.map((element) {
                      return PopupMenuItem(
                        value: element,
                        child: Text(element),
                      );
                    }).toList();
                  },
                  onSelected: (value) {
                    setState(() {
                      currentDate = value;
                      widget.setDate(widget.index, value);
                    });
                  },
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: remove),
              ],
            ),
            title: Text(widget.citizen.fullName),
            subtitle: Text(widget.citizen.cf),
          ),
          ExpansionTile(
              title: const Text("Dati anagrafici"),
              leading: const Icon(Icons.boy_rounded),
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 32, 16),
                    child: Form(
                        key: _editingFormKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OverflowBar(
                                  alignment: MainAxisAlignment.start,
                                  overflowSpacing: 8.0,
                                  spacing: 50,
                                  overflowAlignment: OverflowBarAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 200,
                                        height: 560,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.left,
                                                !isEditing
                                                    ? 'COGNOME:'
                                                    : 'COGNOME: *',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.lastName,
                                                  isEditing,
                                                  userData.lastName,
                                                  validation:
                                                      mandatoryFormValidation),
                                              Text(
                                                textAlign: TextAlign.left,
                                                !isEditing
                                                    ? 'NOME:'
                                                    : 'NOME: *',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.firstName,
                                                  isEditing,
                                                  userData.firstName,
                                                  validation:
                                                      mandatoryFormValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'CODICE FISCALE:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(widget.citizen.cf,
                                                  false, userData.cf),
                                              Text(
                                                textAlign: TextAlign.left,
                                                !isEditing
                                                    ? 'GENERE:'
                                                    : 'GENERE: *',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.genre,
                                                  isEditing,
                                                  userData.genre),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'EMAIL:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.email,
                                                  false,
                                                  userData.email),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'PEC:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.pec,
                                                  isEditing,
                                                  userData.pec,
                                                  validation: emailValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'TELEFONO:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditPhoneField(
                                                  widget.citizen.phone,
                                                  isEditing,
                                                  userData.phone)
                                            ])),
                                    SizedBox(
                                        width: 200,
                                        height: 560,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.left,
                                                !isEditing
                                                    ? 'DATA DI NASCITA:'
                                                    : 'DATA DI NASCITA: *',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.dateOfBirth,
                                                  isEditing,
                                                  userData.dateOfBirth,
                                                  onTapFunction:
                                                      requestBirthDate,
                                                  validation:
                                                      mandatoryDateValidation),
                                              Text(
                                                textAlign: TextAlign.left,
                                                !isEditing
                                                    ? 'COMUNE DI NASCITA:'
                                                    : 'COMUNE DI NASCITA: *',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.cityOfBirth,
                                                  isEditing,
                                                  userData.cityOfBirth,
                                                  validation:
                                                      mandatoryFormValidation),
                                              Text(
                                                textAlign: TextAlign.left,
                                                !isEditing
                                                    ? 'PROVINCIA DI NASCITA:'
                                                    : 'PROVINCIA DI NASCITA: *',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.cityOfBirth,
                                                  isEditing,
                                                  userData.provinceOfBirth,
                                                  validation:
                                                      mandatoryFormValidation),
                                              Text(
                                                textAlign: TextAlign.left,
                                                !isEditing
                                                    ? 'DOMICILIO:'
                                                    : 'DOMICILIO: *',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.domicile,
                                                  isEditing,
                                                  userData.domicile,
                                                  validation:
                                                      mandatoryFormValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'INDIRIZZO DOMICILIO:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget
                                                      .citizen.domicileAddress,
                                                  isEditing,
                                                  userData.domicileAddress,
                                                  validation: formValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'PROVINCIA DOMICILIO:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget
                                                      .citizen.domicileProvince,
                                                  isEditing,
                                                  userData.domicileProvince,
                                                  validation: formValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'CAP DOMICILIO:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.domicileCap,
                                                  isEditing,
                                                  userData.domicileCap,
                                                  validation: formValidation)
                                            ])),
                                    SizedBox(
                                        width: 200,
                                        height: 560,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'NOMINATIVO PRIMO ICE:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen
                                                      .firstICEContactInfo,
                                                  isEditing,
                                                  userData.firstICEContactInfo,
                                                  validation:
                                                      extendedFormValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'TELEFONO PRIMO ICE:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditPhoneField(
                                                  widget.citizen
                                                      .firstICEContactPhone,
                                                  isEditing,
                                                  userData
                                                      .firstICEContactPhone),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'NOMINATIVO SECONDO ICE:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen
                                                      .secondICEContactInfo,
                                                  isEditing,
                                                  userData.secondICEContactInfo,
                                                  validation:
                                                      extendedFormValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'TELEFONO SECONDO ICE:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditPhoneField(
                                                  widget.citizen
                                                      .secondICEContactPhone,
                                                  isEditing,
                                                  userData
                                                      .secondICEContactPhone),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'NOMINATIVO CAREGIVER:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.infoCaregiver,
                                                  isEditing,
                                                  userData.infoCaregiver,
                                                  validation:
                                                      extendedFormValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'TELEFONO CAREGIVER:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditPhoneField(
                                                  widget.citizen.phoneCaregiver,
                                                  isEditing,
                                                  userData.phoneCaregiver),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'CRS:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.crs,
                                                  isEditing,
                                                  userData.crs,
                                                  validation: formValidation)
                                            ])),
                                    SizedBox(
                                        width: 200,
                                        height: 560,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'NUMERO C.I.:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen.idCardNumber,
                                                  isEditing,
                                                  userData.idCardNumber,
                                                  validation: formValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'COMUNE DI RILASCIO C.I.:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen
                                                      .idCardReleaseCity,
                                                  isEditing,
                                                  userData.idCardReleaseCity,
                                                  validation: formValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'DATA RILASCIO C.I.:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen
                                                      .idCardReleaseDate,
                                                  isEditing,
                                                  userData.idCardReleaseDate,
                                                  onTapFunction:
                                                      requestCIReleaseDate,
                                                  validation: dateValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'SCADENZA C.I.:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                  widget.citizen
                                                      .idCardExpirationDate,
                                                  isEditing,
                                                  userData.idCardExpirationDate,
                                                  onTapFunction:
                                                      requestCIExpirationDate,
                                                  validation: dateValidation),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'FOTO: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                  child: Image(
                                                      image: NetworkImage(widget
                                                          .citizen.photoUrl)))
                                            ]))
                                  ]),
                              const SizedBox(height: 20),
                              isEditing
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_editingFormKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  isEditing = false;
                                                });
                                              }
                                            },
                                            child: const Text(
                                                'Conferma Modifiche'),
                                          ),
                                          const SizedBox(width: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isEditing = false;
                                                userData.reset();
                                                _editingFormKey.currentState!
                                                    .reset();
                                              });
                                            },
                                            child:
                                                const Text('Annulla Modifiche'),
                                          )
                                        ])
                                  : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isEditing = !isEditing;
                                        });
                                      },
                                      child: const Text('Modifica'),
                                    )
                            ])))
              ]),
          ExpansionTile(
            title: const Text("Documenti cittadino"),
            leading: const Icon(Icons.insert_drive_file),
            children: [
              ListTile(
                leading: icons[0],
                title: Text(subtitles[0]),
                trailing: FunctionButton(
                    printData, const Icon(Icons.print), "Stampa"),
              ),
              ListTile(
                leading: icons[1],
                title: Text(functionalities[1]),
                trailing: FunctionButton(
                    printSheet, const Icon(Icons.print), "Stampa"),
              ),
              ListTile(
                leading: icons[2],
                title: Text(functionalities[2]),
                trailing:
                    FunctionButton(printCIS, const Icon(Icons.print), "Stampa"),
              ),
              ListTile(
                leading: icons[3],
                title: Text(functionalities[3]),
                trailing: FunctionButton(
                    printBadge, const Icon(Icons.print), "Stampa"),
              ),
              ListTile(
                leading: icons[4],
                title: Text(functionalities[4]),
                trailing: FunctionButton(
                    printBracelet, const Icon(Icons.print), "Stampa"),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(
              widget.citizen.phone,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: _launchPhone,
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(
              widget.citizen.email,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: _launchEmail,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Ultimo aggiornamento: ${widget.citizen.data?.keys.last}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? extendedFormValidation(String? value) {
    if (value == null || value.isEmpty || value == '-') {
      return null;
    } else if (value.length > 100) {
      return 'Massimo 100 caratteri consentiti';
    }
    return null;
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
    if (value == null || value.isEmpty || value == '-') {
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

  requestBirthDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100, DateTime.now().month,
            DateTime.now().day),
        lastDate: DateTime.now());
    if (picked != null) {
      userData.dateOfBirth.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  requestCIReleaseDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100, DateTime.now().month,
            DateTime.now().day),
        lastDate: DateTime.now());
    if (picked != null) {
      userData.idCardReleaseDate.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  requestCIExpirationDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 100, DateTime.now().month,
            DateTime.now().day));
    if (picked != null) {
      userData.idCardExpirationDate.text =
          DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  printData() async {
    _showLoadingDialog();
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .printData()
          .whenComplete(() {
        Navigator.of(context).pop();
      });
    });
  }

  printBadge() async {
    _showLoadingDialog();
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .printBadge()
          .whenComplete(() {
        Navigator.of(context).pop();
      });
    });
  }

  printCIS() async {
    _showLoadingDialog();
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .printCIS()
          .whenComplete(() {
        Navigator.of(context).pop();
      });
    });
  }

  printBracelet() async {
    _showLoadingDialog();
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .printBracelet()
          .whenComplete(() {
        Navigator.of(context).pop();
      });
    });
  }

  printSheet() async {
    _showLoadingDialog();
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .printSheet()
          .whenComplete(() {
        Navigator.of(context).pop();
      });
    });
  }

  _launchPhone() async {
    String url = 'tel:${widget.citizen.phone}';
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw 'Could not launch';
  }

  _launchEmail() async {
    String url = 'mailto:${widget.citizen.email}';
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw 'Could not launch';
  }

  remove() {
    widget.removePatient(widget.citizen.cf);
  }

  Future<void> _showLoadingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.upload_file),
                ),
                Center(child: Text('Generazione documento in corso...')),
              ],
            ),
          ),
        );
      },
    );
  }
}
