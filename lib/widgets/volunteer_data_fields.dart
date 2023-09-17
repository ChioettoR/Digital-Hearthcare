import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_dhc/form_validation.dart';
import 'package:new_dhc/model/citizen.dart';
import 'package:new_dhc/model/user_data.dart';
import 'package:new_dhc/widgets/custom_async_edit_field.dart';
import 'package:new_dhc/widgets/custom_dropdown_edit_field.dart';
import 'package:new_dhc/widgets/custom_edit_field.dart';
import 'package:new_dhc/widgets/custom_edit_phone_field.dart';
import 'package:http/http.dart' as http;

class VolunteerDataFields extends StatefulWidget {
  final Citizen? citizen;
  final bool initialIsEditing;
  final bool newData;

  const VolunteerDataFields(this.citizen, this.initialIsEditing, this.newData,
      {super.key});

  @override
  State<VolunteerDataFields> createState() => VolunteerDataFieldsState();
}

class VolunteerDataFieldsState extends State<VolunteerDataFields> {
  late UserData userData;
  late Uint8List? uploadedPhotoBytes;
  late bool isEditing;
  late bool imageRemoved;

  @override
  void initState() {
    userData =
        widget.citizen == null ? UserData.empty() : UserData(widget.citizen!);
    uploadedPhotoBytes = null;
    isEditing = widget.initialIsEditing;
    imageRemoved = false;
    loadPhoto();
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.newData) userData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(spacing: 10, children: [
                SizedBox(
                    width: 250,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing || !widget.newData
                                ? 'CODICE FISCALE:'
                                : 'CODICE FISCALE: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomAsyncEditField(
                            widget.citizen?.cf,
                            widget.newData,
                            userData.cf,
                            false,
                            maxLength: 16,
                            validation: registrationCFValidation,
                            asyncValidation: registrationCFAsyncValidation,
                          ),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing ? 'COGNOME:' : 'COGNOME: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.lastName, isEditing,
                              userData.lastName, false,
                              validation: mandatoryFormValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing ? 'NOME:' : 'NOME: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.firstName, isEditing,
                              userData.firstName, false,
                              validation: mandatoryFormValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing ? 'GENERE:' : 'GENERE: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomDropdownEditField(
                              widget.citizen?.genre,
                              isEditing,
                              userData.genre,
                              const ['Uomo', 'Donna'],
                              validation: mandatoryFormValidation)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing || !widget.newData
                                ? 'EMAIL:'
                                : 'EMAIL: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomAsyncEditField(widget.citizen?.email,
                              widget.newData, userData.email, false,
                              validation: registrationEmailValidation,
                              asyncValidation:
                                  registrationEmailAsyncValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'PEC:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.pec, isEditing,
                              userData.pec, false,
                              validation: emailValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'TELEFONO:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditPhoneField(
                              widget.citizen?.phone, isEditing, userData.phone),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing
                                ? 'DATA DI NASCITA:'
                                : 'DATA DI NASCITA: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.dateOfBirth,
                              isEditing, userData.dateOfBirth, false,
                              onTapFunction: requestBirthDate,
                              validation: mandatoryDateValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing
                                ? 'COMUNE DI NASCITA:'
                                : 'COMUNE DI NASCITA: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.cityOfBirth,
                              isEditing, userData.cityOfBirth, false,
                              validation: mandatoryFormValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing
                                ? 'PROVINCIA DI NASCITA:'
                                : 'PROVINCIA DI NASCITA: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.provinceOfBirth,
                              isEditing, userData.provinceOfBirth, false,
                              maxLength: 3,
                              validation: mandatoryFormValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            !isEditing ? 'DOMICILIO:' : 'DOMICILIO: *',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.domicile, isEditing,
                              userData.domicile, false,
                              validation: mandatoryFormValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'INDIRIZZO DOMICILIO:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.domicileAddress,
                              isEditing, userData.domicileAddress, false),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'PROVINCIA DOMICILIO:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.domicileProvince,
                              isEditing, userData.domicileProvince, false,
                              maxLength: 3),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'CAP DOMICILIO:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.domicileCap,
                              isEditing, userData.domicileCap, true,
                              maxLength: 5, validation: capValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'NOMINATIVO PRIMO ICE:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.firstICEContactInfo,
                              isEditing, userData.firstICEContactInfo, false),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'TELEFONO PRIMO ICE:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditPhoneField(
                              widget.citizen?.firstICEContactPhone,
                              isEditing,
                              userData.firstICEContactPhone),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'NOMINATIVO SECONDO ICE:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.secondICEContactInfo,
                              isEditing, userData.secondICEContactInfo, false),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'TELEFONO SECONDO ICE:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditPhoneField(
                              widget.citizen?.secondICEContactPhone,
                              isEditing,
                              userData.secondICEContactPhone),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'NOMINATIVO CAREGIVER:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.infoCaregiver,
                              isEditing, userData.infoCaregiver, false),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'TELEFONO CAREGIVER:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditPhoneField(widget.citizen?.phoneCaregiver,
                              isEditing, userData.phoneCaregiver),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'CRS:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.crs, isEditing,
                              userData.crs, true),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'NUMERO C.I.:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.idCardNumber,
                              isEditing, userData.idCardNumber, false,
                              maxLength: 9, validation: idCardValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'COMUNE DI RILASCIO C.I.:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.idCardReleaseCity,
                              isEditing, userData.idCardReleaseCity, false),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'DATA RILASCIO C.I.:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.idCardReleaseDate,
                              isEditing, userData.idCardReleaseDate, false,
                              onTapFunction: requestCIReleaseDate,
                              validation: dateValidation),
                          const SizedBox(height: 30)
                        ])),
                SizedBox(
                    width: 250,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            'SCADENZA C.I.:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomEditField(widget.citizen?.idCardExpirationDate,
                              isEditing, userData.idCardExpirationDate, false,
                              onTapFunction: requestCIExpirationDate,
                              validation: dateValidation),
                          const SizedBox(height: 30)
                        ])),
              ]),
              SizedBox(
                  width: 250,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                textAlign: TextAlign.left,
                                'FOTO:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              Visibility(
                                  visible: isEditing,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: ElevatedButton(
                                    onPressed: pickImage,
                                    child: const Text('Carica foto'),
                                  )),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Visibility(
                                visible: isEditing &&
                                    !imageRemoved &&
                                    (uploadedPhotoBytes != null ||
                                        userData.photoBytes != null),
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                    ),
                                    onPressed: removeImage,
                                    child: const Icon(
                                      Icons.delete,
                                    )),
                              ))
                            ]),
                        const SizedBox(height: 10),
                        uploadedPhotoBytes != null && !imageRemoved
                            ? SizedBox(
                                height: 200,
                                child: Image(
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                    image: MemoryImage(uploadedPhotoBytes!)))
                            //If the user hasn't upload an image, check if there's a storaged image.
                            //If so, shows that image, otherwhise shows nothing.
                            : userData.photoBytes != null && !imageRemoved
                                ? SizedBox(
                                    height: 200,
                                    child: Image(
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain,
                                        image:
                                            MemoryImage(userData.photoBytes!)))
                                : const Text(
                                    textAlign: TextAlign.left,
                                    'Nessuna foto caricata',
                                  ),
                        const SizedBox(height: 30)
                      ])),
            ]));
  }

  UserData retrieveData() {
    userData.savePhotoBytes(uploadedPhotoBytes, imageRemoved);
    return userData;
  }

  setEditing(bool isEditing) {
    setState(() {
      this.isEditing = isEditing;
    });
  }

  saveFields() {
    setState(() {
      userData.savePhotoBytes(uploadedPhotoBytes, imageRemoved);
      userData.saveCitizenFields();
      isEditing = false;
      imageRemoved = false;
    });
  }

  resetFields() {
    setState(() {
      userData.reset();
      uploadedPhotoBytes = null;
      if (userData.photoBytes == null) loadPhoto();
      isEditing = false;
      imageRemoved = false;
    });
  }

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        setState(() {
          imageRemoved = false;
          uploadedPhotoBytes = fileBytes;
        });
      }
    }
  }

  removeImage() {
    setState(() {
      uploadedPhotoBytes = null;
      imageRemoved = true;
    });
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
}
