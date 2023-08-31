import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'model/citizen.dart';
import 'model/doctor.dart';
import 'model/end_user.dart';
import 'model/volunteer.dart';
import 'screens/emergency_numbers.dart';
import 'screens/homepage.dart';
import 'screens/login.dart';
import 'screens/qr_code_scanner.dart';
import 'screens/volunteer_screen.dart';
import 'services/database_service.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool logged = false;

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        logged = false;
      });
    } else {
      setState(() {
        logged = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (logged) {
      return FutureBuilder<EndUser>(
          future: DatabaseService().getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              EndUser? endUser = snapshot.data;

              if (snapshot.data?.userType == cittadino) {
                return FutureBuilder<List<dynamic>>(
                    future: DatabaseService().getCitizen(endUser!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Citizen citizen = snapshot.data?[0];
                        Volunteer volunteer = snapshot.data?[1];
                        Doctor doctor = snapshot.data?[2];
                        return Homepage(
                            citizen,
                            volunteer,
                            doctor,
                            openQRCodeScannerLogged,
                            openEmergencyNumbersLogged,
                            logout);
                      } else {
                        return const Scaffold(
                            body: Center(child: CircularProgressIndicator()));
                      }
                    });
              } else if (snapshot.data?.userType == volontario) {
                return FutureBuilder<List<Citizen>>(
                    future: DatabaseService().getCitizensList(endUser!.cf),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Citizen>? citizens = snapshot.data;
                        return VolunteerScreen(endUser, citizens, logout);
                      } else {
                        return const Scaffold(
                            body: Center(child: CircularProgressIndicator()));
                      }
                    });
              } else {
                return Login(setLogged, openQRCodeScanner,
                    openEmergencyNumbersNotLogged);
              }
            } else {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
          });
    } else {
      return Login(setLogged, openQRCodeScanner, openEmergencyNumbersNotLogged);
    }
  }

  setLogged() {
    setState(() {
      logged = true;
    });
  }

  openQRCodeScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const QRCodeScanner(logged: true)),
    );
  }

  openQRCodeScannerLogged() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const QRCodeScanner(logged: false)),
    );
  }

  openEmergencyNumbersLogged(Volunteer volunteer, Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmergencyNumbers(
                true,
                volunteer: volunteer,
                doctor: doctor,
              )),
    );
  }

  openEmergencyNumbersNotLogged() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmergencyNumbers(false)),
    );
  }

  logout() async {
    _showLoadingDialog();
  }

  Future<void> _showLoadingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                        'Vuoi eseguire il logout dal sistema e tornare alla schermata di login?')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('INDIETRO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('LOGOUT'),
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                setState(() {
                  logged = false;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
