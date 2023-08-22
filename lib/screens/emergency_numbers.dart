import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:humanitarian_icons/humanitarian_icons.dart';
import 'package:new_dhc/wrapper.dart';

import '../model/doctor.dart';
import '../model/volunteer.dart';
import '../widgets/emergency_number_tile.dart';
import '../widgets/numbers_card.dart';

class EmergencyNumbers extends StatelessWidget {
  final Volunteer? volunteer;
  final Doctor? doctor;
  final bool logged;
  const EmergencyNumbers(this.logged, {super.key, this.volunteer, this.doctor});

  @override
  Widget build(BuildContext context) {
    return logged
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: const Text("Numeri Utili"),
                bottom: TabBar(
                  tabs: (kIsWeb &&
                          MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height)
                      ? [
                          const Tab(
                              icon: Icon(Icons.add_call), text: "Contatti"),
                          const Tab(
                              icon: Icon(Icons.warning_rounded),
                              text: "Emergenza"),
                        ]
                      : [
                          const Tab(icon: Icon(Icons.add_call)),
                          const Tab(icon: Icon(Icons.warning_rounded)),
                        ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildContacts(context),
                  _buildEmergency(context),
                ],
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              leading: BackButton(
                  onPressed: () => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Wrapper()),
                            (Route<dynamic> route) => false)
                      }),
              title: const Text("Numeri di Emergenza"),
            ),
            body: _buildEmergency(context),
          );
  }

  Widget _buildContacts(context) {
    return (kIsWeb &&
            MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height)
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/contacts-web.png"),
              ),
              Flexible(
                  child: Scrollbar(
                child: ListView(
                  children: [
                    NumbersCard(
                        const Icon(Icons.local_hospital),
                        doctor!.fullName(),
                        "Medico di base",
                        doctor!.phone == "-" ? "Non fornito" : doctor!.phone!,
                        doctor!.email == "-" ? "Non fornito" : doctor!.email),
                    NumbersCard(
                        const Icon(Icons.work),
                        volunteer!.fullName(),
                        "Volontario comunale",
                        volunteer!.phone == "-"
                            ? "Non fornito"
                            : volunteer!.phone!,
                        volunteer!.email == "-"
                            ? "Non fornito"
                            : volunteer!.email)
                  ],
                ),
              ))
            ],
          )
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/contacts.png"),
              ),
              NumbersCard(
                  const Icon(Icons.local_hospital),
                  doctor!.fullName(),
                  "Medico di base",
                  doctor!.phone == "-" ? "Non fornito" : doctor!.phone!,
                  doctor!.email == "-" ? "Non fornito" : doctor!.email),
              NumbersCard(
                  const Icon(Icons.work),
                  volunteer!.fullName(),
                  "Volontario comunale",
                  volunteer!.phone == "-" ? "Non fornito" : volunteer!.phone!,
                  volunteer!.email == "-" ? "Non fornito" : volunteer!.email)
            ],
          );
  }

  Widget _buildEmergency(context) {
    return (kIsWeb &&
            MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height)
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/emergency-web.png"),
              ),
              Flexible(
                  child: Scrollbar(
                      child: ListView(
                children: const [
                  EmergencyNumberTile(
                      Icon(HumanitarianIcons.community_building),
                      "112",
                      "Carabinieri"),
                  EmergencyNumberTile(Icon(HumanitarianIcons.police_station),
                      "113", "Polizia di Stato"),
                  EmergencyNumberTile(
                      Icon(HumanitarianIcons.fire), "115", "Vigili del Fuoco"),
                  EmergencyNumberTile(Icon(HumanitarianIcons.emergency_telecom),
                      "117", "Guardia di Finanza"),
                  EmergencyNumberTile(Icon(HumanitarianIcons.ambulance), "118",
                      "Emergenza Sanitaria"),
                ],
              )))
            ],
          )
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/emergency.png"),
              ),
              const EmergencyNumberTile(
                  Icon(HumanitarianIcons.community_building),
                  "112",
                  "Carabinieri"),
              const EmergencyNumberTile(Icon(HumanitarianIcons.police_station),
                  "113", "Polizia di Stato"),
              const EmergencyNumberTile(
                  Icon(HumanitarianIcons.fire), "115", "Vigili del Fuoco"),
              const EmergencyNumberTile(
                  Icon(HumanitarianIcons.emergency_telecom),
                  "117",
                  "Guardia di Finanza"),
              const EmergencyNumberTile(Icon(HumanitarianIcons.ambulance),
                  "118", "Emergenza Sanitaria"),
            ],
          );
  }
}
