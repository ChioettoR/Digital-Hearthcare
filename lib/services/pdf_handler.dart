import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_dhc/model/pss.dart';
import 'package:path/path.dart' as path;
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:new_dhc/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../model/citizen.dart';

class PDFHandler {
  final String qrCode = "qr_code";
  final String data = "dati";
  final String bracelet = "braccialetto";
  final String cis = "cis";
  final String badge = "badge";
  final String sheet = "scheda";

  final pdf = Document();
  final Citizen? citizen;
  final PSS? pssCitizen;
  final List<Citizen>? citizens;
  final List<PSS>? pssCitizens;

  PDFHandler({this.citizens, this.pssCitizens, this.citizen, this.pssCitizen});

  printQRCode() async {
    await _createQRCode();
    await _printPDF(qrCode);
  }

  _createQRCode() async {
    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(5),
        build: (Context context) {
          return Padding(
              padding: const EdgeInsets.all(2),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            "Codice QR di ${citizen!.firstName} ${citizen!.lastName}")),
                    BarcodeWidget(
                      data: pssCitizen!.getLifeSavingInformation(),
                      width: 150,
                      height: 150,
                      barcode: Barcode.qrCode(),
                    )
                  ])));
        }));
  }

  openData() async {
    await _createData();
    if (kIsWeb) {
      await _openPDFWeb(data);
    } else {
      await _savePDF(data);
      await _openPDF(data);
    }
  }

  openMultipleData() async {
    await _createMultipleData();
    if (kIsWeb) {
      await _openPDFWeb(data);
    } else {
      await _savePDF(data);
      await _openPDF(data);
    }
  }

  downloadData() async {
    await _createData();
    if (kIsWeb) {
      await _downloadPDFWeb(data);
    } else {
      await _downloadPDF(data);
    }
  }

  shareData() async {
    await _createData();
    if (kIsWeb) {
      await _sharePDFWeb(data);
    } else {
      await _sharePDF(data);
    }
  }

  printData() async {
    await _createData();
    await _printPDF(data);
  }

  _createData() {
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Profilo sanitario sintetico".toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(aCapo),
              ..._createPSS(pssCitizen!),
            ])
          ];
        }));
  }

  _createMultipleData() {
    for (int i = 0; i < pssCitizens!.length; i++) {
      pdf.addPage(MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (Context context) => [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Profilo sanitario sintetico".toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(aCapo),
                  ..._createPSS(pssCitizens![i]),
                ])
              ]));
    }
  }

  List<Widget> _createPSS(PSS pss) {
    List<Widget> widgets = [];
    widgets.add(
        Text("DATI ANAGRAFICI", style: TextStyle(fontWeight: FontWeight.bold)));
    pss.toMapPSSSectionZero().forEach((key, value) {
      widgets.add(RichText(
          text: TextSpan(
              text: "$key: ",
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
            TextSpan(
              text: (value != "") ? value : "-",
              style: TextStyle(fontWeight: FontWeight.normal),
            )
          ])));
    });
    widgets.add(Text(aCapo));
    widgets.add(
        Text("DATI PERSONALI", style: TextStyle(fontWeight: FontWeight.bold)));
    pss.toMapPSSSectionOne().forEach((key, value) {
      widgets.add(RichText(
          text: TextSpan(
              text: "$key: ",
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
            TextSpan(
              text: (value != "") ? value : "-",
              style: TextStyle(fontWeight: FontWeight.normal),
            )
          ])));
    });
    widgets.add(Text(aCapo));
    widgets
        .add(Text("CONTATTI", style: TextStyle(fontWeight: FontWeight.bold)));
    pss.toMapPSSSectionTwo().forEach((key, value) {
      widgets.add(RichText(
          text: TextSpan(
              text: "$key: ",
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
            TextSpan(
              text: (value != "") ? value : "-",
              style: TextStyle(fontWeight: FontWeight.normal),
            )
          ])));
    });
    widgets.add(Text(aCapo));
    widgets
        .add(Text("ALLERGIE", style: TextStyle(fontWeight: FontWeight.bold)));
    pss.toMapPSSSectionThree().forEach((key, value) {
      widgets.add(RichText(
          text: TextSpan(
              text: "$key: ",
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
            TextSpan(
              text: (value != "") ? value : "-",
              style: TextStyle(fontWeight: FontWeight.normal),
            )
          ])));
    });
    widgets.add(Text(aCapo));
    widgets.add(Text("PATOLOGIE E TERAPIE",
        style: TextStyle(fontWeight: FontWeight.bold)));
    pss.toMapPSSSectionFour().forEach((key, value) {
      widgets.add(RichText(
          text: TextSpan(
              text: "$key: ",
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
            TextSpan(
              text: (value != "") ? value : "-",
              style: TextStyle(fontWeight: FontWeight.normal),
            )
          ])));
    });
    widgets.add(Text(aCapo));
    widgets.add(
        Text("RETE SANITARIA", style: TextStyle(fontWeight: FontWeight.bold)));
    pss.toMapPSSSectionFive().forEach((key, value) {
      widgets.add(RichText(
          text: TextSpan(
              text: "$key: ",
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
            TextSpan(
              text: (value != "") ? value : "-",
              style: TextStyle(fontWeight: FontWeight.normal),
            )
          ])));
    });
    return widgets;
  }

  //braccialetto
  openBracelet() async {
    await _createBracelet();
    if (kIsWeb) {
      await _openPDFWeb(bracelet);
    } else {
      await _savePDF(bracelet);
      await _openPDF(bracelet);
    }
  }

  openMultipleBracelet() async {
    await _createMultipleBracelet();
    if (kIsWeb) {
      await _openPDFWeb(bracelet);
    } else {
      await _savePDF(bracelet);
      await _openPDF(bracelet);
    }
  }

  downloadBracelet() async {
    await _createBracelet();
    if (kIsWeb) {
      await _downloadPDFWeb(bracelet);
    } else {
      await _downloadPDF(bracelet);
    }
  }

  shareBracelet() async {
    await _createBracelet();
    if (kIsWeb) {
      await _sharePDFWeb(bracelet);
    } else {
      await _sharePDF(bracelet);
    }
  }

  printBracelet() async {
    await _createBracelet();
    await _printPDF(bracelet);
  }

  _createBracelet() async {
    //21.7mm x 114.5mm
    final municipioTre =
        (await rootBundle.load('assets/logos/municipio_tre.png'))
            .buffer
            .asUint8List();
    final comuneMilano =
        (await rootBundle.load('assets/logos/comune_milano.png'))
            .buffer
            .asUint8List();
    final mvi =
        (await rootBundle.load('assets/logos/mvi.png')).buffer.asUint8List();
    final polimi = (await rootBundle.load('assets/logos/polimi2.png'))
        .buffer
        .asUint8List();
    final areu =
        (await rootBundle.load('assets/logos/areu2.jpg')).buffer.asUint8List();
    final centodiciotto =
        (await rootBundle.load('assets/logos/118.jpg')).buffer.asUint8List();
    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(0),
        build: (Context context) {
          return Row(children: [
            Container(
                decoration:
                    BoxDecoration(border: Border.all(color: PdfColors.black)),
                child: Row(children: [
                  _braceletLogo(municipioTre),
                  _braceletLogo(comuneMilano),
                  _braceletLogo(mvi),
                  _braceletLogo(polimi),
                  SizedBox(
                    width: (PdfPageFormat.a4.width / 1.83) / 7,
                    height: PdfPageFormat.a4.height / 13.68,
                    child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: BarcodeWidget(
                          data: pssCitizen!.getLifeSavingInformation(),
                          width: (PdfPageFormat.a4.width / 1.83) / 7,
                          height: PdfPageFormat.a4.height / 13.68,
                          barcode: Barcode.qrCode(),
                        )),
                  ),
                  _braceletLogo(areu),
                  _braceletLogo(centodiciotto),
                ])),
          ]);
        }));
  }

  Future<Uint8List> imageTask(String image) async {
    return (await rootBundle.load(image)).buffer.asUint8List();
  }

  _createMultipleBracelet() async {
    final municipioTre =
        (await rootBundle.load('assets/logos/municipio_tre.png'))
            .buffer
            .asUint8List();
    final comuneMilano =
        (await rootBundle.load('assets/logos/comune_milano.png'))
            .buffer
            .asUint8List();
    final mvi =
        (await rootBundle.load('assets/logos/mvi.png')).buffer.asUint8List();
    final polimi = (await rootBundle.load('assets/logos/polimi2.png'))
        .buffer
        .asUint8List();
    final areu =
        (await rootBundle.load('assets/logos/areu2.jpg')).buffer.asUint8List();
    final centodiciotto =
        (await rootBundle.load('assets/logos/118.jpg')).buffer.asUint8List();
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(0),
        build: (Context context) => [
              ...generateBracelets(
                  municipioTre, comuneMilano, mvi, polimi, areu, centodiciotto),
            ]));
  }

  List<Widget> generateBracelets(
      municipioTre, comuneMilano, mvi, polimi, areu, centodiciotto) {
    List<Widget> widgets = [];
    for (int i = 0; i < pssCitizens!.length; i++) {
      widgets.add(Row(children: [
        Container(
            decoration:
                BoxDecoration(border: Border.all(color: PdfColors.black)),
            child: Row(children: [
              _braceletLogo(municipioTre),
              _braceletLogo(comuneMilano),
              _braceletLogo(mvi),
              _braceletLogo(polimi),
              SizedBox(
                width: (PdfPageFormat.a4.width / 1.83) / 7,
                height: PdfPageFormat.a4.height / 13.68,
                child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: BarcodeWidget(
                      data: pssCitizens![i].getLifeSavingInformation(),
                      width: (PdfPageFormat.a4.width / 1.83) / 7,
                      height: PdfPageFormat.a4.height / 13.68,
                      barcode: Barcode.qrCode(),
                    )),
              ),
              _braceletLogo(areu),
              _braceletLogo(centodiciotto),
            ])),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(citizens![i].fullName))
      ]));
      widgets.add(
        SizedBox(height: 10),
      );
    }
    return widgets;
  }

  Container _braceletLogo(image) {
    return Container(
        width: (PdfPageFormat.a4.width / 1.83) / 7,
        height: PdfPageFormat.a4.height / 13.68,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Image(MemoryImage(image), fit: BoxFit.fitWidth),
        ));
  }

  openSheet() async {
    await _createSheet();
    if (kIsWeb) {
      await _openPDFWeb(sheet);
    } else {
      await _savePDF(sheet);
      await _openPDF(sheet);
    }
  }

  openMultipleSheet() async {
    await _createMultipleSheet();
    if (kIsWeb) {
      await _openPDFWeb(sheet);
    } else {
      await _savePDF(sheet);
      await _openPDF(sheet);
    }
  }

  downloadSheet() async {
    await _createSheet();
    if (kIsWeb) {
      await _downloadPDFWeb(sheet);
    } else {
      await _downloadPDF(sheet);
    }
  }

  shareSheet() async {
    await _createSheet();
    if (kIsWeb) {
      await _sharePDFWeb(sheet);
    } else {
      await _sharePDF(sheet);
    }
  }

  printSheet() async {
    await _createSheet();
    await _printPDF(sheet);
  }

  _createSheet() async {
    final comuneMilano =
        (await rootBundle.load('assets/logos/comune_milano.png'))
            .buffer
            .asUint8List();
    final mvi =
        (await rootBundle.load('assets/logos/mvi.png')).buffer.asUint8List();

    Uint8List profile;
    if (citizen!.photoUrl != null &&
        citizen!.photoUrl!.isNotEmpty &&
        citizen!.photoUrl! != "-") {
      final http.Response profileImage =
          await http.get(Uri.parse(citizen!.photoUrl!));
      profile = profileImage.bodyBytes;
    } else {
      ByteData byteData =
          await rootBundle.load('assets/images/photoPlaceholder.png');
      profile = byteData.buffer.asUint8List();
    }

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(0),
        build: (Context context) {
          return ListView(children: [
            _sheetOne(comuneMilano, mvi),
            _sheetTwo(profile, pssCitizen!)
          ]);
        }));
  }

  _createMultipleSheet() async {
    final comuneMilano =
        (await rootBundle.load('assets/logos/comune_milano.png'))
            .buffer
            .asUint8List();
    final mvi =
        (await rootBundle.load('assets/logos/mvi.png')).buffer.asUint8List();
    List<Uint8List> photosList = [];

    for (int i = 0; i < citizens!.length; i++) {
      if (citizens![i].photoUrl != null &&
          citizens![i].photoUrl!.isNotEmpty &&
          citizens![i].photoUrl! != "-") {
        final http.Response profileImage =
            await http.get(Uri.parse(citizens![i].photoUrl!));
        photosList.add(profileImage.bodyBytes);
      } else {
        ByteData byteData =
            await rootBundle.load('assets/images/photoPlaceholder.png');
        photosList.add(byteData.buffer.asUint8List());
      }
    }

    for (int i = 0; i < pssCitizens!.length; i++) {
      pdf.addPage(Page(
          pageFormat: PdfPageFormat.a4,
          margin: const EdgeInsets.all(0),
          build: (Context context) {
            return ListView(children: [
              _sheetOne(comuneMilano, mvi),
              _sheetTwo(photosList[i], pssCitizens![i])
            ]);
          }));
    }
  }

  Widget _sheetOne(comuneMilano, mvi) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
                width: (PdfPageFormat.a4.width / 1.83) / 7,
                height: PdfPageFormat.a4.height / 13.68,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image(MemoryImage(comuneMilano), fit: BoxFit.fitWidth),
                )),
            Column(children: [
              Container(
                  color: PdfColors.red,
                  height: 8,
                  width: PdfPageFormat.a4.width / 10 * 8),
              Text("cittadini più coinvolti & più sicuri".toUpperCase()),
            ]),
            Container(
                width: (PdfPageFormat.a4.width / 1.83) / 7,
                height: PdfPageFormat.a4.height / 13.68,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image(MemoryImage(mvi), fit: BoxFit.fitWidth),
                ))
          ]),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Container(
                  color: PdfColors.lightBlue,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Scheda Salvavita"),
                      ])))
        ]));
  }

  Widget _sheetTwo(profile, PSS pssCitizen) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: PdfColors.black)),
            child: Column(children: [
              _partOne(pssCitizen),
              Divider(color: PdfColors.black),
              _partTwo(pssCitizen, profile),
              Divider(color: PdfColors.black),
              _partThree(pssCitizen),
              Divider(color: PdfColors.black),
              _partFour(pssCitizen),
            ])));
  }

  Widget _partOne(PSS pss) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text("INFORMAZIONI PERSONALI",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._createKeysSheet(pss.toMapSheetSectionOne())
                          ]),
                    ),
                    SizedBox(width: 30),
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._createValuesSheet(pss.toMapSheetSectionOne())
                          ]),
                    ),
                  ])
                ]),
                BarcodeWidget(
                  data: pss.getLifeSavingInformation(),
                  width: (PdfPageFormat.a4.width / 14) * 2,
                  height: (PdfPageFormat.a4.width / 14) * 2,
                  barcode: Barcode.qrCode(),
                )
              ])
            ])));
  }

  Widget _partTwo(PSS pss, profile) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text("DATI ATS - MILANO",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._createKeysSheet(pss.toMapSheetSectionTwo())
                          ]),
                    ),
                    SizedBox(width: 30),
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._createValuesSheet(pss.toMapSheetSectionTwo())
                          ]),
                    ),
                  ])
                ]),
                Container(
                    width: 60,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Image(MemoryImage(profile), fit: BoxFit.fitWidth),
                    ))
              ])
            ])));
  }

  Widget _partThree(PSS pss) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text("CONTATTI DI EMERGENZA - ICE",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._createKeysSheet(pss.toMapSheetSectionThree())
                          ]),
                    ),
                    SizedBox(width: 30),
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._createValuesSheet(pss.toMapSheetSectionThree())
                          ]),
                    ),
                  ])
                ]),
              ])
            ])));
  }

  Widget _partFour(PSS pss) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text("INFORMAZIONI MEDICHE SALVAVITA",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._createKeysSheet(pss.toMapSheetSectionFour())
                          ]),
                    ),
                    SizedBox(width: 30),
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._createValuesSheet(pss.toMapSheetSectionFour())
                          ]),
                    ),
                  ])
                ]),
              ])
            ])));
  }

  List<Widget> _createKeysSheet(Map<String, String?> map) {
    List<Widget> widgets = [];
    map.forEach((key, value) {
      widgets.add(Text("$key:"));
    });
    return widgets;
  }

  List<Widget> _createValuesSheet(Map<String, String?> map) {
    List<Widget> widgets = [];
    map.forEach((key, value) {
      widgets.add(Text(value!));
    });
    return widgets;
  }

  //badge
  openBadge() async {
    await _createBadge();
    if (kIsWeb) {
      await _openPDFWeb(badge);
    } else {
      await _savePDF(badge);
      await _openPDF(badge);
    }
  }

  openMultipleBadge() async {
    await _createMultipleBadge();
    if (kIsWeb) {
      await _openPDFWeb(badge);
    } else {
      await _savePDF(badge);
      await _openPDF(badge);
    }
  }

  downloadBadge() async {
    await _createBadge();
    if (kIsWeb) {
      await _downloadPDFWeb(badge);
    } else {
      await _downloadPDF(badge);
    }
  }

  shareBadge() async {
    await _createBadge();
    if (kIsWeb) {
      await _sharePDFWeb(badge);
    } else {
      await _sharePDF(badge);
    }
  }

  printBadge() async {
    await _createBadge();
    await _printPDF(badge);
  }

  _createBadge() async {
    final mvi =
        (await rootBundle.load('assets/logos/mvi.png')).buffer.asUint8List();
    final ice =
        (await rootBundle.load('assets/logos/ice.png')).buffer.asUint8List();

    Uint8List profile;
    if (citizen!.photoUrl != null &&
        citizen!.photoUrl!.isNotEmpty &&
        citizen!.photoUrl! != "-") {
      final http.Response profileImage =
          await http.get(Uri.parse(citizen!.photoUrl!));
      profile = profileImage.bodyBytes;
    } else {
      ByteData byteData =
          await rootBundle.load('assets/images/photoPlaceholder.png');
      profile = byteData.buffer.asUint8List();
    }

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(0),
        build: (Context context) {
          return _blockFour(mvi, ice, profile, pssCitizen!);
        }));
  }

  _createMultipleBadge() async {
    final mvi =
        (await rootBundle.load('assets/logos/mvi.png')).buffer.asUint8List();
    final ice =
        (await rootBundle.load('assets/logos/ice.png')).buffer.asUint8List();

    List<Uint8List> photosList = [];

    for (int i = 0; i < citizens!.length; i++) {
      if (citizens![i].photoUrl != null &&
          citizens![i].photoUrl!.isNotEmpty &&
          citizens![i].photoUrl! != "-") {
        final http.Response profileImage =
            await http.get(Uri.parse(citizens![i].photoUrl!));
        photosList.add(profileImage.bodyBytes);
      } else {
        ByteData byteData =
            await rootBundle.load('assets/images/photoPlaceholder.png');
        photosList.add(byteData.buffer.asUint8List());
      }
    }

    for (int i = 0; i < pssCitizens!.length; i++) {
      pdf.addPage(Page(
          pageFormat: PdfPageFormat.a4,
          margin: const EdgeInsets.all(0),
          build: (Context context) {
            return _blockFour(mvi, ice, photosList[i], pssCitizens![i]);
          }));
    }
  }

  //cis
  openCIS() async {
    await _createCIS();
    if (kIsWeb) {
      await _openPDFWeb(cis);
    } else {
      await _savePDF(cis);
      await _openPDF(cis);
    }
  }

  openMultipleCIS() async {
    await _createMultipleCIS();
    if (kIsWeb) {
      await _openPDFWeb(cis);
    } else {
      await _savePDF(cis);
      await _openPDF(cis);
    }
  }

  downloadCIS() async {
    await _createCIS();
    if (kIsWeb) {
      await _downloadPDFWeb(cis);
    } else {
      await _downloadPDF(cis);
    }
  }

  shareCIS() async {
    await _createCIS();
    if (kIsWeb) {
      await _sharePDFWeb(cis);
    } else {
      await _sharePDF(cis);
    }
  }

  printCIS() async {
    await _createCIS();
    await _printPDF(cis);
  }

  _createCIS() async {
    final centodiciotto =
        (await rootBundle.load('assets/logos/118.jpg')).buffer.asUint8List();
    final centododici =
        (await rootBundle.load('assets/logos/112.png')).buffer.asUint8List();
    final comuneMilano =
        (await rootBundle.load('assets/logos/comune_milano2.png'))
            .buffer
            .asUint8List();
    final mvi =
        (await rootBundle.load('assets/logos/mvi.png')).buffer.asUint8List();
    final areu =
        (await rootBundle.load('assets/logos/areu2.jpg')).buffer.asUint8List();
    final simeu =
        (await rootBundle.load('assets/logos/simeu.png')).buffer.asUint8List();
    final omceo =
        (await rootBundle.load('assets/logos/omceo.jpg')).buffer.asUint8List();
    final ice =
        (await rootBundle.load('assets/logos/ice.png')).buffer.asUint8List();

    Uint8List profile;
    if (citizen!.photoUrl != null &&
        citizen!.photoUrl!.isNotEmpty &&
        citizen!.photoUrl! != "-") {
      final http.Response profileImage =
          await http.get(Uri.parse(citizen!.photoUrl!));
      profile = profileImage.bodyBytes;
    } else {
      ByteData byteData =
          await rootBundle.load('assets/images/photoPlaceholder.png');
      profile = byteData.buffer.asUint8List();
    }

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(0),
        build: (Context context) {
          return GridView(
              crossAxisCount: 2,
              childAspectRatio:
                  (PdfPageFormat.a4.height / 2) / (PdfPageFormat.a4.width / 2),
              children: [
                _blockOne(centodiciotto, centododici),
                _blockTwo(comuneMilano, mvi, areu, simeu, omceo),
                _blockThree(pssCitizen!),
                _blockFour(mvi, ice, profile, pssCitizen!),
              ]);
        }));
  }

  _createMultipleCIS() async {
    final centodiciotto =
        (await rootBundle.load('assets/logos/118.jpg')).buffer.asUint8List();
    final centododici =
        (await rootBundle.load('assets/logos/112.png')).buffer.asUint8List();
    final comuneMilano =
        (await rootBundle.load('assets/logos/comune_milano2.png'))
            .buffer
            .asUint8List();
    final mvi =
        (await rootBundle.load('assets/logos/mvi.png')).buffer.asUint8List();
    final areu =
        (await rootBundle.load('assets/logos/areu2.jpg')).buffer.asUint8List();
    final simeu =
        (await rootBundle.load('assets/logos/simeu.png')).buffer.asUint8List();
    final omceo =
        (await rootBundle.load('assets/logos/omceo.jpg')).buffer.asUint8List();
    final ice =
        (await rootBundle.load('assets/logos/ice.png')).buffer.asUint8List();
    List<Uint8List> photosList = [];

    for (int i = 0; i < citizens!.length; i++) {
      if (citizens![i].photoUrl != null &&
          citizens![i].photoUrl!.isNotEmpty &&
          citizens![i].photoUrl! != "-") {
        final http.Response profileImage =
            await http.get(Uri.parse(citizens![i].photoUrl!));
        photosList.add(profileImage.bodyBytes);
      } else {
        ByteData byteData =
            await rootBundle.load('assets/images/photoPlaceholder.png');
        photosList.add(byteData.buffer.asUint8List());
      }
    }

    for (int i = 0; i < pssCitizens!.length; i++) {
      pdf.addPage(Page(
          pageFormat: PdfPageFormat.a4,
          margin: const EdgeInsets.all(0),
          build: (Context context) {
            return GridView(
                crossAxisCount: 2,
                childAspectRatio: (PdfPageFormat.a4.height / 2) /
                    (PdfPageFormat.a4.width / 2),
                children: [
                  _blockOne(centodiciotto, centododici),
                  _blockTwo(comuneMilano, mvi, areu, simeu, omceo),
                  _blockThree(pssCitizens![i]),
                  _blockFour(mvi, ice, photosList[i], pssCitizens![i]),
                ]);
          }));
    }
  }

  Container _blockOne(centodiciotto, centododici) {
    return Container(
        width: PdfPageFormat.a4.width / 2,
        height: PdfPageFormat.a4.height / 2,
        child: Column(children: [
          Container(
              height: PdfPageFormat.a4.height / 10,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: (PdfPageFormat.a4.width / 2) / 3,
                        child: Image(MemoryImage(centodiciotto),
                            fit: BoxFit.fitWidth)),
                    Container(
                        width: (PdfPageFormat.a4.width / 2) / 3,
                        child: Image(MemoryImage(centododici),
                            fit: BoxFit.fitWidth)),
                  ])),
          Container(
              height: (PdfPageFormat.a4.height / 10) * 3,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "-la CIS contiene tutte le informazioni/dati che sono stati inseriti nella SAPP*"),
                        RichText(
                          text: TextSpan(
                              text: 'la CIS è fornita ',
                              style: TextStyle(fontWeight: FontWeight.normal),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'gratuitamente',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: " all'utilizzatore e ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'senza alcuna garanzia esplicita o implicita.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                    ]),
                              ]),
                        ),
                        Text(
                            "-la responsabilità della correttezza e validità delle informazioni/dati non può essere ascritta all'autore della SAPP"),
                        Text(
                            "-le informazioni ed i dati inseriti vengono memorizzati in forma anonima e per meri fini statistici"),
                        Text(
                            "-è cura dell'interessato ripresentarsi ogniqualvolta ci sia una variazione dei dati e comunque ogni SEI MESI",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]))),
          Container(
              height: PdfPageFormat.a4.height / 10,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("*SAPP (Social APPlication)"),
                        Text("www.iltelefoninoiltuosalvavita.org"),
                        /* SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Empowered by G7 Soluzioni Informatiche")
                            ]), */
                      ])))
        ]));
  }

  Container _blockTwo(comuneMilano, mvi, areu, simeu, omceo) {
    return Container(
        width: PdfPageFormat.a4.width / 2,
        height: PdfPageFormat.a4.height / 2,
        child: Column(children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: PdfColors.black)),
            height: PdfPageFormat.a4.height / 10,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: (PdfPageFormat.a4.width / 2) / 2,
                          child: Image(MemoryImage(comuneMilano),
                              fit: BoxFit.fitWidth)),
                      Container(
                          width: (PdfPageFormat.a4.width / 2) / 4,
                          child: Image(MemoryImage(mvi), fit: BoxFit.fitWidth)),
                    ])),
          ),
          Container(
              height: (PdfPageFormat.a4.height / 10) * 3,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text("PROGETTO",
                            style: const TextStyle(color: PdfColors.red)),
                        Text("CITTADINI",
                            style: const TextStyle(color: PdfColors.red)),
                        Text("Più coinvolti & più sicuri".toUpperCase(),
                            style: const TextStyle(color: PdfColors.red)),
                        SizedBox(height: 20),
                        Text("C.I.S.",
                            style: const TextStyle(
                                fontSize: 35, color: PdfColors.red)),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                              text: 'C',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: PdfColors.red),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "arta d'",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: PdfColors.red),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'I',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: PdfColors.red),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'dentità ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: PdfColors.red),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'S',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: PdfColors.red),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'alvavita',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: PdfColors
                                                                  .red),
                                                        ),
                                                      ]),
                                                ]),
                                          ]),
                                    ]),
                              ]),
                        ),
                      ]))),
          Container(
              height: PdfPageFormat.a4.height / 10,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: (PdfPageFormat.a4.width / 2) / 3,
                        child: Image(MemoryImage(areu), fit: BoxFit.fitWidth)),
                    Container(
                        width: (PdfPageFormat.a4.width / 2) / 3,
                        child: Image(MemoryImage(simeu), fit: BoxFit.fitWidth)),
                    Container(
                        width: (PdfPageFormat.a4.width / 2) / 4,
                        child: Image(MemoryImage(omceo), fit: BoxFit.fitWidth)),
                  ]))
        ]));
  }

  Container _blockThree(PSS pss) {
    return Container(
        width: PdfPageFormat.a4.width / 2,
        height: PdfPageFormat.a4.height / 2,
        child: Column(children: [
          Container(
            width: PdfPageFormat.a4.width / 2,
            height: (PdfPageFormat.a4.height / 10) * 4,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("DATI SALVAVITA",
                    style: const TextStyle(color: PdfColors.red)),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: PdfPageFormat.a4.width / 4 - 8,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [..._createKeys(pss)]),
                        ),
                        Container(
                          width: PdfPageFormat.a4.width / 4 - 8,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [..._createValues(pss)]),
                        ),
                      ])),
            ]),
          ),
          /* Container(
              width: PdfPageFormat.a4.width / 2,
              height: PdfPageFormat.a4.height / 10,
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Documenti e codici utilizzati:".toUpperCase(),
                            style: TextStyle(fontSize: 8)),
                        Text(
                            "C.I.N° AB123456, Emesso da: Milano, il: 31/12/2020",
                            style: TextStyle(fontSize: 8)),
                        Text("CRS N° 321654987; C.F.:MRRRSS54XABF123",
                            style: TextStyle(fontSize: 8)),
                        Text("Codici ATS: Assistito: ; Esenzioni: ",
                            style: TextStyle(fontSize: 8)),
                        Text(
                            "Informazioni mediche Salvavita condivide son SIMEU a novembre 2015",
                            style: TextStyle(fontSize: 8)),
                        SizedBox(height: 10),
                        Text("cdm10021501903", style: TextStyle(fontSize: 8)),
                      ]))) */
        ]));
  }

  Container _blockFour(mvi, ice, Uint8List photo, PSS pss) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
        width: PdfPageFormat.a4.width / 2,
        height: PdfPageFormat.a4.height / 2,
        child: Column(children: [
          Container(
              color: PdfColors.black,
              height: PdfPageFormat.a4.height / 10,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: (PdfPageFormat.a4.width / 2) / 4,
                        child: Image(MemoryImage(mvi), fit: BoxFit.fitWidth)),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: const TextSpan(
                                text: 'I',
                                style: TextStyle(
                                    fontSize: 18, color: PdfColors.red),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'N',
                                      style: TextStyle(
                                          fontSize: 18, color: PdfColors.white),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' C',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: PdfColors.red),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'ASO',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: PdfColors.white),
                                              ),
                                            ]),
                                      ]),
                                ]),
                          ),
                          Text(
                            "di",
                            style: const TextStyle(
                                fontSize: 18, color: PdfColors.white),
                          ),
                          RichText(
                            text: const TextSpan(
                                text: 'E',
                                style: TextStyle(
                                    fontSize: 18, color: PdfColors.red),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'MERGENZA',
                                    style: TextStyle(
                                        fontSize: 18, color: PdfColors.white),
                                  ),
                                ]),
                          ),
                        ]),
                    Container(
                        width: (PdfPageFormat.a4.width / 2) / 4,
                        child: Image(MemoryImage(ice), fit: BoxFit.fitWidth)),
                  ])),
          Container(
              decoration:
                  BoxDecoration(border: Border.all(color: PdfColors.black)),
              height: PdfPageFormat.a4.height / 10,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("ICE1: ${citizen!.firstICEContactPhone}",
                                  style: const TextStyle(
                                      fontSize: 18, color: PdfColors.orange)),
                              Text("ICE2: ${citizen!.secondICEContactPhone}",
                                  style: const TextStyle(
                                      fontSize: 18, color: PdfColors.orange))
                            ])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                          height: (PdfPageFormat.a4.height / 10),
                          width: (PdfPageFormat.a4.width / 10),
                          child:
                              Image(MemoryImage(photo), fit: BoxFit.fitWidth)),
                    )
                  ])),
          Container(
              height: (PdfPageFormat.a4.height / 10) * 3,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                BarcodeWidget(
                  data: pss.getLifeSavingInformation(),
                  width: (PdfPageFormat.a4.width / 10) * 2,
                  height: (PdfPageFormat.a4.height / 10) * 2,
                  barcode: Barcode.qrCode(),
                )
              ])),
        ]));
  }

  List<Widget> _createKeys(PSS pss) {
    List<Widget> widgets = [];
    pss.toMapIta().forEach((key, value) {
      widgets.add(Text(key, style: TextStyle(fontWeight: FontWeight.bold)));
    });
    return widgets;
  }

  List<Widget> _createValues(PSS pss) {
    List<Widget> widgets = [];
    pss.toMapIta().forEach((key, value) {
      widgets.add(Text("$value"));
    });
    return widgets;
  }

  //general
  openOnlinePDF(String name) async {
    await canLaunchUrl(Uri.parse(name))
        ? await launchUrl(Uri.parse(name))
        : throw 'Could not launch';
  }

  Future _savePDF(String name) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/$name.pdf");
    file.writeAsBytesSync(await pdf.save(), flush: true);
  }

  _openPDF(String name) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      File file = File("$documentPath/$name.pdf");
      await OpenFile.open(file.path, type: "application/pdf");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _openPDFWeb(String name) async {
    try {
      final bytes = await pdf.save();
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, "_blank");
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static Future<void> task(Document pdfFile) async {
    final bytes = await pdfFile.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "_blank");
    html.Url.revokeObjectUrl(url);
  }

  _downloadPDF(String name) async {
    String nome = DateTime.now().millisecondsSinceEpoch.toString();
    String downloadPath;
    try {
      downloadPath = (await DownloadsPath.downloadsDirectory())?.path ??
          "Downloads path doesn't exist";
    } catch (e) {
      downloadPath = 'Failed to get downloads paths';
    }

    final savePath = path.join(downloadPath, "$nome.pdf");
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/$nome.pdf");
    var filePDF = await pdf.save();
    file.writeAsBytesSync(filePDF, mode: FileMode.append);
    await file.copy(savePath);
    Fluttertoast.showToast(msg: "Downloaded!");
  }

  _downloadPDFWeb(String name) async {
    try {
      final bytes = await pdf.save();
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = '$name.pdf';
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _sharePDF(String name) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/$name.pdf");
    var filePDF = await pdf.save();
    file.writeAsBytesSync(filePDF);
    Printing.sharePdf(bytes: filePDF, filename: '$name.pdf');
  }

  _sharePDFWeb(String name) async {
    final bytes = await pdf.save();
    Printing.layoutPdf(onLayout: (_) => bytes);
  }

  _printPDF(String name) async {
    Uint8List bytes = await pdf.save();
    Printing.layoutPdf(onLayout: (_) => bytes);
  }
}
