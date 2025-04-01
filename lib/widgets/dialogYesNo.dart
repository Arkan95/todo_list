import 'package:flutter/material.dart';

class DialogYesNo extends StatelessWidget {
  String? title;
  void Function()? yes;
  void Function()? no;
  DialogYesNo({super.key, this.title, this.yes, this.no});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(title ?? "Eliminare?"),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            yes;
            Navigator.of(context).pop(true);
          },
          child: const Text("Confermo"),
        ),
        ElevatedButton(
          onPressed: () {
            no;
            Navigator.of(context).pop(false);
          },
          child: const Text("Annulla"),
        ),
      ],
    );
  }
}
