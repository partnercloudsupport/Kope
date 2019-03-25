import 'package:flutter/material.dart';
import 'package:kope/cloud/models/user.dart';
import 'package:photo_manager/photo_manager.dart';

class Locals {
  static User user;
  static String number;
  static String username;
  static String uid;
  static String verifyID;
  static bool isAccept = false;
  static List<AssetEntity> imgList;
  static String validUsername(String value) {
    Pattern pattern = r'^([a-zA-Z])$';
    RegExp regex = new RegExp(pattern);
    if (value.length < 6)
      return 'Le Username doit contenir au moins 6 caracteres';
    else if (!regex.hasMatch(value))
      return 'Le Username ne doit pas contenir un caractere special';
    else
      return null;
  }

  static String validName(String value) {
    if (value == null) {
      return 'Completez le nom';
    } else {
      return null;
    }
  }

  static showSuccess(BuildContext context) {
    return showDialog(
        context: context,
        child: SimpleDialog(
          contentPadding: EdgeInsets.all(40.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(50.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 80.0,
                  ),
                  )
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Operation a reussie",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ));
  }

  static showErrorSnackbar(String message, GlobalKey<ScaffoldState> key) {
    key.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String validateMobile(String value) {
    if (value.length != 9)
      return 'Mobile Number must be of 9 digit';
    else if (value[0] == "0")
      return 'Le Numero n\'est doit pas commencer par 0';
    else
      return null;
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Entrez un mail valide';
    else
      return null;
  }

  static String validatePassword(String value) {
    if (value.length < 6)
      return 'Le mot de passe doit contenir  6 caracteres ou plus';
    else
      return null;
  }

  // static Widget loading() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         CircularProgressIndicator(
  //           backgroundColor: Colors.blue,
  //         ),
  //         Text(
  //           Flutkart.load,
  //           style: TextStyle(fontSize: 10, color: Colors.black87),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
