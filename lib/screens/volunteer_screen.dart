import 'package:flutter/material.dart';
import 'package:new_dhc/model/end_user.dart';
import 'package:new_dhc/model/pss.dart';
import 'package:new_dhc/screens/add_patient_screen.dart';

import '../constants.dart';
import '../model/citizen.dart';
import '../model/searched_citizen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../services/pdf_handler.dart';
import '../widgets/appbar_button.dart';
import '../widgets/volunteer_card.dart';

class VolunteerScreen extends StatefulWidget {
  final EndUser volunteer;
  final List<Citizen>? patients;
  final dynamic changeScreen;
  const VolunteerScreen(this.volunteer, this.patients, this.changeScreen,
      {super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  List<String> qrCodeDataList = [];
  List<String> namesList = [];
  List<String> photosList = [];
  List<String> dateList = [];
  List<SearchedCitizen> patients = [];
  List<SearchedCitizen> queryResult = [];
  List<SearchedCitizen> bodyPatients = [];
  List<Citizen> citizens = [];
  List<PSS> pssCitizens = [];

  @override
  void initState() {
    _initializePatient();
    super.initState();
  }

  _initializePatient() {
    setState(() {
      if (widget.patients != null) {
        for (var element in widget.patients!) {
          patients.add(SearchedCitizen(element, false));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: bodyPatients.length > 1
            ? _buildFloatingButton()
            : const SizedBox.shrink(),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.volunteer.photoUrl != "-"
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.volunteer.photoUrl),
                    ))
                : const SizedBox.shrink(),
          ),
          centerTitle: true,
          title: const Text("Homepage"),
          actions: [
            ElevatedButton(
                onPressed: addNewPatient,
                child: const Icon(Icons.person_add_alt_1)),
            AppBarButton(const Icon(Icons.logout), widget.changeScreen),
          ],
        ),
        body: _searchScreen());
  }

  addNewPatient() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPatientScreen(widget.volunteer.cf)),
    );
  }

  Widget _buildFloatingButton() {
    return SpeedDial(
      icon: Icons.print,
      mini: true,
      children: [
        SpeedDialChild(child: icons[0], onTap: generateMultipleData),
        SpeedDialChild(
          child: icons[1],
          onTap: generateMultipleSheet,
        ),
        SpeedDialChild(
          child: icons[2],
          onTap: generateMultipleCIS,
        ),
        SpeedDialChild(
          child: icons[3],
          onTap: generateMultipleBadge,
        ),
        SpeedDialChild(
          child: icons[4],
          onTap: generateMultipleBracelet,
        ),
      ],
    );
  }

  generateMultipleBadge() {
    _createData();
    Future.delayed(const Duration(seconds: 1), () async {
      await PDFHandler(citizens: citizens, pssCitizens: pssCitizens)
          .openMultipleBadge()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleCIS() {
    _createData();
    Future.delayed(const Duration(seconds: 1), () async {
      await PDFHandler(citizens: citizens, pssCitizens: pssCitizens)
          .openMultipleCIS()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleBracelet() async {
    _createData();
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(citizens: citizens, pssCitizens: pssCitizens)
          .openMultipleBracelet()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleSheet() async {
    _createData();
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(citizens: citizens, pssCitizens: pssCitizens)
          .openMultipleSheet()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  generateMultipleData() async {
    _createData();
    await Future.delayed(const Duration(seconds: 1), () {
      PDFHandler(citizens: citizens, pssCitizens: pssCitizens)
          .openMultipleData()
          .whenComplete(() {
        _resetData();
      });
    });
  }

  _createData() {
    _showLoadingDialog();
    for (int i = 0; i < bodyPatients.length; i++) {
      pssCitizens.add(bodyPatients[i].citizen.data![dateList[i]]!);
      citizens.add(bodyPatients[i].citizen);
    }
  }

  _resetData() {
    pssCitizens.clear();
    citizens.clear();
    Navigator.of(context).pop();
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

  Widget _searchScreen() {
    return Stack(fit: StackFit.expand, children: [
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 66,
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: bodyPatients.length,
              itemBuilder: (context, index) {
                return bodyPatients[index].body
                    ? VolunteerCard(bodyPatients[index].citizen, index,
                        _getDate, _setDate, _removeElement)
                    : const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
      _buildSearchBar(),
    ]);
  }

  String _getDate(int index, String newDate) {
    return dateList[index];
  }

  _setDate(int index, String newDate) {
    setState(() {
      dateList[index] = newDate;
    });
  }

  _removeElement(String tin) {
    bool exit = false;
    for (int i = 0; i < bodyPatients.length; i++) {
      if (bodyPatients[i].citizen.cf == tin) {
        setState(() {
          for (var member in patients) {
            if (member.citizen.cf == tin) {
              member.body = false;
            }
          }
          bodyPatients.remove(bodyPatients[i]);
          citizens.remove(citizens[i]);
          dateList.remove(dateList[i]);
          exit = true;
        });
        if (exit) break;
      }
    }
  }

  FloatingSearchBar _buildSearchBar() {
    return FloatingSearchBar(
      hint: 'Cerca...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      width: MediaQuery.of(context).size.width,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        if (query != "") {
          setState(() {
            queryResult = patients
                .where((element) =>
                    element.citizen.fullName
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    element.citizen.cf
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();
          });
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...createQueryResults(),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> createQueryResults() {
    List<Widget> widgets = [];
    for (var element in queryResult) {
      widgets.add(ListTile(
        title: Text(element.citizen.fullName),
        subtitle: Text(element.citizen.cf),
        trailing: element.body
            ? const SizedBox.shrink()
            : ElevatedButton(
                onPressed: () {
                  setState(() {
                    element.body = true;
                    bodyPatients.add(element);
                    citizens.add(element.citizen);
                    dateList.add(element.citizen.data!.keys.last);
                  });
                },
                child: const Text("Aggiungi")),
      ));
    }
    return widgets;
  }
}
