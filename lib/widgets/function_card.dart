import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'function_icon.dart';

class FunctionCard extends StatelessWidget {
  final Icon icon;
  final Image image;
  final String title;
  final String subtitle;
  final String description;
  final dynamic openFunction;
  final dynamic downloadFunction;
  final dynamic printFunction;
  final dynamic shareFunction;
  const FunctionCard(
      this.icon,
      this.image,
      this.title,
      this.subtitle,
      this.description,
      this.openFunction,
      this.downloadFunction,
      this.printFunction,
      this.shareFunction,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: image,
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              description,
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: kIsWeb
                  ? <Widget>[
                      FunctionIcon(openFunction,
                          const Icon(Icons.picture_as_pdf), true, "Apri"),
                      FunctionIcon(downloadFunction, const Icon(Icons.save),
                          true, "Salva"),
                      FunctionIcon(printFunction, const Icon(Icons.print), true,
                          "Stampa"),
                    ]
                  : <Widget>[
                      FunctionIcon(openFunction,
                          const Icon(Icons.picture_as_pdf), true, "Apri"),
                      FunctionIcon(downloadFunction, const Icon(Icons.save),
                          true, "Salva"),
                      FunctionIcon(printFunction, const Icon(Icons.print), true,
                          "Stampa"),
                      FunctionIcon(shareFunction, const Icon(Icons.share), true,
                          "Condividi"),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
