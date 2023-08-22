import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNumberTile extends StatelessWidget {
  final Icon icon;
  final String number;
  final String description;
  const EmergencyNumberTile(this.icon, this.number, this.description,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: icon,
        title: Text(number),
        subtitle: Text(description),
        onTap: _launchURL,
      ),
    );
  }

  _launchURL() async {
    String url = 'tel:$number';
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw 'Could not launch';
  }
}
