import 'package:flutter/material.dart';
import 'package:new_dhc/constants.dart';
import 'package:new_dhc/screens/add_pss_screen.dart';
import 'package:new_dhc/widgets/volunteer_data_fields.dart';
import 'package:new_dhc/wrapper.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _editingFormKey = GlobalKey<FormState>();
  late VolunteerDataFields volunteerDataFields;
  final _volunteerDataFieldsKey = GlobalKey<VolunteerDataFieldsState>();

  @override
  void initState() {
    volunteerDataFields =
        VolunteerDataFields(null, true, true, key: _volunteerDataFieldsKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: getCardColor(),
        surfaceTintColor: getCardColor(),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Wrapper()),
                      (Route<dynamic> route) => false)
                }),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Aggiunta paziente"),
      ),
      body: addPatientBody(),
    );
  }

  Widget addPatientBody() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
                key: _editingFormKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DATI ANAGRAFICI",
                          style: TextStyle(
                              letterSpacing: 1,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                      const SizedBox(height: 32),
                      volunteerDataFields,
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (!_editingFormKey.currentState!.validate()) {
                            addNewPSS();
                          }
                        },
                        child: const Text('Prosegui'),
                      )
                    ]))));
  }

  addNewPSS() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPSSScreen(true,
              createdUserData:
                  _volunteerDataFieldsKey.currentState!.retrieveData())),
    );
  }
}
