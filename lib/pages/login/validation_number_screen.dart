import 'package:kope/cloud/locals/locals.dart';
import 'package:kope/utils/flutkart.dart';
import 'package:kope/utils/my_navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class ValidationPhoneNumber extends StatefulWidget {
  @override
  _ValidationPhoneNumber createState() => _ValidationPhoneNumber();
}

class _ValidationPhoneNumber extends State<ValidationPhoneNumber> {
  bool _isComplete, _isLogIn;
  var collection = Firestore.instance.collection("user");
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId;
  String _sms;
  bool _codeVerified = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  String userId = null;

  @override
  void initState() {
    super.initState();
    this.verificationId = Locals.verifyID;
    init();
//    Timer(Duration(seconds: 10), );
  }
  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = (prefs.getString('userId'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(Flutkart.validationTitle),
      ),
      body: Form(
        key: _formKey,
        child:  ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                      'Entrez le code de validation envoyé \n   Au numero ${Locals.number} '
                          '     \n          Par SMS pour confirmer \n'
                          '                 votre inscription',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(width: 150.0,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.dialpad), hintText: 'Code',
                      ),
                      validator:validateSms,
                      onSaved: (val)=>this._sms = val,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 40.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _submitSmsCode().then((value){
                          if(value){
                            prefs.setString('userId', userId);
                            MyNavigator.goReplaceAll(context, "/home");
                          }
                        });
                      }
                    },
                    child: Text(
                      'Vérifier',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String validateSms(String value) {
    if (value.length != 6)
      return 'Le code de validation n\'est pas correct';
    else
      return null;
  }

  Future<bool> inscription() async {
    _isComplete = false;

    DocumentReference docRef;
    docRef = await collection.add({
      'username': Locals.user.username,
      'passwords': Locals.user.passwords,
      'tel': Locals.user.tel,
      'email': Locals.user.email
    });
    if (docRef != null) {
      userId = docRef.documentID;
      _isComplete = true;
    }

    return _isComplete;
  }

  Future<bool> _submitSmsCode() async {
    _codeVerified = false;
    _isLogIn =true;
    await _auth.currentUser().then((FirebaseUser user){
      if(user == null){
        _isLogIn = false;
      }
      else
        print("user id:"+user.uid);
      _codeVerified  =true;
    });
    if(!_isLogIn){
      print('Auth process : Searching for cheking');
      print('Auth Message : $verificationId');
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId : verificationId,
          smsCode: _sms
      );
      print('Auth process : auth pass ${credential.toString()}');
      FirebaseUser user = await _auth.signInWithCredential(credential).catchError((error){
        if(error){
          print(error);
          _codeVerified = false;
          _showErrorSnackbar("Probleme lors de la verification, reessayer plus tard");
        }
      });
      print("user id :"+user.uid);
    }
    if(_codeVerified){
      inscription().then((value){
        if(value)
          _codeVerified = true;
      }).catchError((error){
        if(error){
          _codeVerified = false;
          print(error);
          _showErrorSnackbar("Probleme lors de la verification, reessayer plus tard");
        }
      });
    }
    return _codeVerified;
  }

  _showErrorSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

}
