import 'package:flutter/material.dart';
import 'package:new_dhc/constants.dart';
import 'package:new_dhc/model/user_data.dart';
import 'package:new_dhc/model/user_pss.dart';
import 'package:new_dhc/widgets/volunteer_pss_fields.dart';
import 'package:new_dhc/services/database_service.dart';
import 'package:new_dhc/wrapper.dart';

class AddPSSScreen extends StatefulWidget {
  final UserData? createdUserData;
  final String? volunteerCF;
  final bool newUser;
  final String? userCF;

  const AddPSSScreen(this.newUser,
      {this.createdUserData, this.volunteerCF, this.userCF, super.key});

  @override
  State<AddPSSScreen> createState() => _AddPSSScreenState();
}

class _AddPSSScreenState extends State<AddPSSScreen> {
  final _editingFormKey = GlobalKey<FormState>();
  final _volunteerPSSFieldsKey = GlobalKey<VolunteerPSSFieldsState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: getCardColor(),
          surfaceTintColor: getCardColor(),
          centerTitle: true,
          title: const Text("Aggiunta PSS"),
          leading: widget.newUser
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Wrapper()),
                            (Route<dynamic> route) => false)
                      }),
          automaticallyImplyLeading: widget.newUser,
        ),
        body: addPSSBody());
  }

  Widget addPSSBody() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
                key: _editingFormKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DATI SANITARI",
                          style: TextStyle(
                              letterSpacing: 1,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                      const SizedBox(height: 32),
                      VolunteerPSSFields(
                          key: _volunteerPSSFieldsKey,
                          widget.newUser
                              ? widget.createdUserData!.cf.text
                              : widget.userCF!),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_editingFormKey.currentState!.validate()) {
                            createData();
                          }
                        },
                        child: const Text('Conferma'),
                      )
                    ]))));
  }

  createData() async {
    UserPSS userPSS = _volunteerPSSFieldsKey.currentState!.retrieveData();

    if (widget.newUser) {
      bool result = await DatabaseService()
          .createUser(widget.createdUserData!, widget.volunteerCF!);
      if (result) {
        await DatabaseService()
            .createPSS(userPSS, widget.createdUserData!.cf.text);
      }
    } else {
      await DatabaseService().createPSS(userPSS, widget.userCF!);
    }

    moveToHomepage();
  }

  moveToHomepage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Wrapper()),
        (Route<dynamic> route) => false);
    if (widget.newUser) widget.createdUserData!.dispose();
  }
}
