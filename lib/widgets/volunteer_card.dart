import 'package:flutter/material.dart';
import 'package:new_dhc/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
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
            subtitle: Text(widget.citizen.cf!),
          ),
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
              widget.citizen.phone!,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: _launchPhone,
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(
              widget.citizen.email!,
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
