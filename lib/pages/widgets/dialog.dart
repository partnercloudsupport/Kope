import 'package:flutter/material.dart';

class MyDialog {
  static bool value;

  static Future<bool> dialog(BuildContext context, String message) async {
    value = false;
    await showDialog(
        context: context,
        child: SimpleDialog(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    message,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            value = false;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Non'),
                        ),
                        Spacer(),
                        RaisedButton(
                          onPressed: () {
                            value = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Oui'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ));
    return value;
  }
  static void values()=>{ value = value};
}
