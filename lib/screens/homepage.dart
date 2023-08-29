import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_dhc/constants.dart';
import 'package:new_dhc/services/pdf_handler.dart';
import 'package:new_dhc/services/qr_code_handler.dart';
import 'package:new_dhc/widgets/appbar_button.dart';
import 'package:new_dhc/widgets/function_button.dart';

import '../model/citizen.dart';
import '../model/doctor.dart';
import '../model/volunteer.dart';
import '../widgets/function_card.dart';

class Homepage extends StatefulWidget {
  final Citizen citizen;
  final Volunteer volunteer;
  final Doctor doctor;
  final dynamic openQRCodeScanner;
  final dynamic openEmergencyNumbers;
  final dynamic logout;
  const Homepage(this.citizen, this.volunteer, this.doctor,
      this.openQRCodeScanner, this.openEmergencyNumbers, this.logout,
      {super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String qrCodeData;
  late String currentDate;

  @override
  void initState() {
    _initializeCitizen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.citizen.photoUrl != null &&
                          widget.citizen.photoUrl!.isNotEmpty &&
                          widget.citizen.photoUrl! != "-"
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.citizen.photoUrl!),
                          ))
                      : const SizedBox.shrink()),
              title: const Text("Homepage"),
              actions: [
                Tooltip(
                    message: "Numeri Utili",
                    child: AppBarButton(
                        const Icon(Icons.contact_phone_outlined),
                        openContacts)),
                kIsWeb
                    ? const SizedBox.shrink()
                    : Tooltip(
                        message: "QR Code Scanner",
                        child: AppBarButton(const Icon(Icons.qr_code_scanner),
                            widget.openQRCodeScanner)),
                _buildDateMenu(),
                Tooltip(
                    message: "Logout",
                    child:
                        AppBarButton(const Icon(Icons.logout), widget.logout)),
              ],
              bottom: TabBar(
                tabs: (kIsWeb &&
                        MediaQuery.of(context).size.width >
                            MediaQuery.of(context).size.height)
                    ? [
                        const Tab(icon: Icon(Icons.qr_code), text: "Codice QR"),
                        const Tab(icon: Icon(Icons.info), text: "Informazioni"),
                      ]
                    : [
                        const Tab(
                            icon: Tooltip(
                                message: "Codice QR",
                                child: Icon(Icons.qr_code))),
                        const Tab(
                            icon: Tooltip(
                                message: "Informazioni",
                                child: Icon(Icons.info))),
                      ],
              ),
            ),
            body: TabBarView(children: [
              _qrCodeScreen(qrCodeData),
              _functionalitiesScreen(),
            ])));
  }

  PopupMenuButton _buildDateMenu() {
    return PopupMenuButton(
      tooltip: "Storico",
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
          qrCodeData = widget.citizen.data![value]!.getLifeSavingInformation();
        });
      },
    );
  }

  _initializeCitizen() {
    setState(() {
      currentDate = widget.citizen.data!.keys.last;
      qrCodeData =
          widget.citizen.data![currentDate]!.getLifeSavingInformation();
    });
  }

  Widget _qrCodeScreen(String qrData) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: QRCodeHandler().generateQRCode(qrData),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                FunctionButton(openQRCode, const Icon(Icons.image), "Apri"),
                FunctionButton(
                    saveQRCodeToGallery, const Icon(Icons.save), "Salva"),
                FunctionButton(printQRCode, const Icon(Icons.print), "Stampa"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _functionalitiesScreen() {
    return (kIsWeb &&
            MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height)
        ? ListView(
            children: [
              Row(
                children: [
                  Flexible(
                    child: FunctionCard(
                        icons[0],
                        images[0],
                        functionalities[0],
                        subtitles[0],
                        descriptions[0],
                        openData,
                        downloadData,
                        printData,
                        shareData),
                  ),
                  Flexible(
                    child: FunctionCard(
                        icons[1],
                        images[1],
                        functionalities[1],
                        subtitles[1],
                        descriptions[1],
                        openSheet,
                        downloadSheet,
                        printSheet,
                        shareSheet),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: FunctionCard(
                        icons[2],
                        images[2],
                        functionalities[2],
                        subtitles[2],
                        descriptions[2],
                        openCIS,
                        downloadCIS,
                        printCIS,
                        shareCIS),
                  ),
                  Flexible(
                    child: FunctionCard(
                        icons[3],
                        images[3],
                        functionalities[3],
                        subtitles[3],
                        descriptions[3],
                        openBadge,
                        downloadBadge,
                        printBadge,
                        shareBadge),
                  ),
                  Flexible(
                    child: FunctionCard(
                        icons[4],
                        images[4],
                        functionalities[4],
                        subtitles[4],
                        descriptions[4],
                        openBracelet,
                        downloadBracelet,
                        printBracelet,
                        shareBracelet),
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: Scrollbar(
              child: ListView(
                children: [
                  FunctionCard(
                      icons[0],
                      images[0],
                      functionalities[0],
                      subtitles[0],
                      descriptions[0],
                      openData,
                      downloadData,
                      printData,
                      shareData),
                  FunctionCard(
                      icons[1],
                      images[1],
                      functionalities[1],
                      subtitles[1],
                      descriptions[1],
                      openSheet,
                      downloadSheet,
                      printSheet,
                      shareSheet),
                  FunctionCard(
                      icons[2],
                      images[2],
                      functionalities[2],
                      subtitles[2],
                      descriptions[2],
                      openCIS,
                      downloadCIS,
                      printCIS,
                      shareCIS),
                  FunctionCard(
                      icons[3],
                      images[3],
                      functionalities[3],
                      subtitles[3],
                      descriptions[3],
                      openBadge,
                      downloadBadge,
                      printBadge,
                      shareBadge),
                  FunctionCard(
                      icons[4],
                      images[4],
                      functionalities[4],
                      subtitles[4],
                      descriptions[4],
                      openBracelet,
                      downloadBracelet,
                      printBracelet,
                      shareBracelet),
                ],
              ),
            ),
          );
  }

  //callback functions
  openQRCode() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      QRCodeHandler().openQRCode(qrCodeData).whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  saveQRCodeToGallery() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      QRCodeHandler().saveQRCodeToGallery(qrCodeData).whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  printQRCode() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .printQRCode()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  openData() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .openData()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  downloadData() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .downloadData()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  printData() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .printData()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  shareData() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .shareData()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  openBracelet() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .openBracelet()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  downloadBracelet() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .downloadBracelet()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  printBracelet() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .printBracelet()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  shareBracelet() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(pssCitizen: widget.citizen.data?[currentDate])
          .shareBracelet()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  openBadge() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .openBadge()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  downloadBadge() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .downloadBadge()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  printBadge() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .printBadge()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  shareBadge() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .shareBadge()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  openCIS() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .openCIS()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  downloadCIS() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .downloadCIS()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  printCIS() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .printCIS()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  shareCIS() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .shareCIS()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  openSheet() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .openSheet()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  downloadSheet() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .downloadSheet()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  printSheet() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .printSheet()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  shareSheet() async {
    _setProcessing(true);
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(
              citizen: widget.citizen,
              pssCitizen: widget.citizen.data?[currentDate])
          .shareSheet()
          .whenComplete(() {
        _setProcessing(false);
      });
    });
  }

  openContacts() {
    widget.openEmergencyNumbers(widget.volunteer, widget.doctor);
  }

  _setProcessing(bool status) {
    status ? _showLoadingDialog() : Navigator.of(context).pop();
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
