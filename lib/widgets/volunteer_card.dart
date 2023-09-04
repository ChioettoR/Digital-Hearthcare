import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_dhc/constants.dart';
import 'package:new_dhc/form_validation.dart';
import 'package:new_dhc/model/user_data.dart';
import 'package:new_dhc/widgets/custom_dropdown_edit_field.dart';
import 'package:new_dhc/widgets/custom_edit_field.dart';
import 'package:new_dhc/widgets/custom_edit_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

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
  late Uint8List? uploadedPhotoBytes;

  @override
  void initState() {
    userData = UserData(widget.citizen);
    uploadedPhotoBytes = null;
    loadPhoto();
    isEditing = false;
    currentDate = widget.citizen.data!.keys.last;
    super.initState();
  }

  loadPhoto() async {
    if (userData.photoUrl != "-") {
      Uint8List bytes =
          (await http.get(Uri.parse(userData.photoUrl))).bodyBytes;
      setState(() {
        userData.photoBytes = bytes;
      });
    }
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
                        autovalidateMode: AutovalidateMode.disabled,
                        key: _editingFormKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OverflowBar(
                                  alignment: MainAxisAlignment.start,
                                  overflowSpacing: 10,
                                  overflowAlignment: OverflowBarAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 250,
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
                                                  false,
                                                  validation:
                                                      mandatoryFormValidation),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  validation:
                                                      mandatoryFormValidation),
                                              const SizedBox(height: 10),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'CODICE FISCALE:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomEditField(
                                                widget.citizen.cf,
                                                false,
                                                userData.cf,
                                                false,
                                                maxLength: 16,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                textAlign: TextAlign.left,
                                                !isEditing
                                                    ? 'GENERE:'
                                                    : 'GENERE: *',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CustomDropdownEditField(
                                                  widget.citizen.genre,
                                                  isEditing,
                                                  userData.genre,
                                                  false),
                                              const SizedBox(height: 10),
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
                                                userData.email,
                                                false,
                                              ),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  validation: emailValidation),
                                              const SizedBox(height: 10),
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
                                        width: 250,
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
                                                  false,
                                                  onTapFunction:
                                                      requestBirthDate,
                                                  validation:
                                                      mandatoryDateValidation),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  validation:
                                                      mandatoryFormValidation),
                                              const SizedBox(height: 10),
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
                                                  widget
                                                      .citizen.provinceOfBirth,
                                                  isEditing,
                                                  userData.provinceOfBirth,
                                                  false,
                                                  maxLength: 3,
                                                  validation:
                                                      mandatoryFormValidation),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  validation:
                                                      mandatoryFormValidation),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  validation: formValidation),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  maxLength: 3,
                                                  validation: formValidation),
                                              const SizedBox(height: 10),
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
                                                  true,
                                                  maxLength: 5,
                                                  validation: capValidation)
                                            ])),
                                    SizedBox(
                                        width: 250,
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
                                                  false,
                                                  validation: formValidation),
                                              const SizedBox(height: 10),
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
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  validation: formValidation),
                                              const SizedBox(height: 10),
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
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  validation: formValidation),
                                              const SizedBox(height: 10),
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
                                              const SizedBox(height: 10),
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
                                                  true,
                                                  validation: formValidation)
                                            ])),
                                    SizedBox(
                                        width: 250,
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
                                                  false,
                                                  maxLength: 9,
                                                  validation: formValidation),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  validation: formValidation),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  onTapFunction:
                                                      requestCIReleaseDate,
                                                  validation: dateValidation),
                                              const SizedBox(height: 10),
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
                                                  false,
                                                  onTapFunction:
                                                      requestCIExpirationDate,
                                                  validation: dateValidation),
                                              const SizedBox(height: 10),
                                              const Text(
                                                textAlign: TextAlign.left,
                                                'FOTO: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                  height: 220,
                                                  child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: SizedBox(
                                                          height: 200,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                    height: 5),
                                                                //Check if the user has uploaded an image. If so, shows that image.
                                                                uploadedPhotoBytes !=
                                                                        null
                                                                    ? Expanded(
                                                                        child: Image(
                                                                            fit: BoxFit
                                                                                .fitHeight,
                                                                            image: MemoryImage(
                                                                                uploadedPhotoBytes!)))
                                                                    //If the user hasn't upload an image, check if there's a storaged image.
                                                                    //If so, shows that image, otherwhise shows nothing.
                                                                    : userData.photoBytes !=
                                                                            null
                                                                        ? Expanded(
                                                                            child:
                                                                                Image(fit: BoxFit.fitHeight, image: MemoryImage(userData.photoBytes!)))
                                                                        : const SizedBox.shrink(),
                                                                const SizedBox(
                                                                    height: 10),
                                                                isEditing
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            pickImage,
                                                                        child: const Text(
                                                                            'Carica foto'),
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink()
                                                              ]))))
                                            ])),
                                  ]),
                              const SizedBox(height: 20),
                              isEditing
                                  ? OverflowBar(
                                      spacing: 20,
                                      overflowSpacing: 20,
                                      alignment: MainAxisAlignment.start,
                                      children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_editingFormKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _editingFormKey.currentState!
                                                      .save();
                                                  userData.saveCitizenFields(
                                                      uploadedPhotoBytes);
                                                  isEditing = false;
                                                });
                                              }
                                            },
                                            child: const Text(
                                                'Conferma Modifiche'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _editingFormKey.currentState!
                                                    .reset();
                                                userData.reset();
                                                uploadedPhotoBytes = null;
                                                isEditing = false;
                                              });
                                            },
                                            child:
                                                const Text('Annulla Modifiche'),
                                          )
                                        ])
                                  : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isEditing = true;
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

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        setState(() {
          uploadedPhotoBytes = fileBytes;
        });
      }
    }
  }

  requestBirthDate() async {
    if (userData.dateOfBirth.text == "-") {
      userData.dateOfBirth.clear();
    }
    //FocusScope.of(context).requestFocus(FocusNode());
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
    if (userData.idCardReleaseDate.text == "-") {
      userData.idCardReleaseDate.clear();
    }
    //FocusScope.of(context).requestFocus(FocusNode());
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
    if (userData.idCardExpirationDate.text == "-") {
      userData.idCardExpirationDate.clear();
    }
    //FocusScope.of(context).requestFocus(FocusNode());
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
