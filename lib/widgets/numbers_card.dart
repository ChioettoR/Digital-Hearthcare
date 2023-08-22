import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class NumbersCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subtitle;
  final String number;
  final String email;
  const NumbersCard(
      this.icon, this.title, this.subtitle, this.number, this.email,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: icon,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(
              number,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: _launchPhone,
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(
              email,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: _launchEmail,
          ),
        ],
      ),
    );
  }

  _launchPhone() async {
    String url = 'tel:$number';
    if (number == "Non fornito") {
      Fluttertoast.showToast(
          msg: "Il contatto selezionato non è stato fornito!");
    } else {
      await canLaunchUrl(Uri.parse(url))
          ? await launchUrl(Uri.parse(url))
          : throw 'Could not launch';
    }
  }

  _launchEmail() async {
    String url = 'mailto:$email';
    if (email == "Non fornito") {
      Fluttertoast.showToast(
          msg: "Il contatto selezionato non è stato fornito!");
    } else {
      await canLaunchUrl(Uri.parse(url))
          ? await launchUrl(Uri.parse(url))
          : throw 'Could not launch';
    }
  }
}
