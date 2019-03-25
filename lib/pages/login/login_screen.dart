import 'package:kope/cloud/locals/locals.dart';
import 'package:kope/pages/widgets/animation/loading.dart';
import 'package:kope/utils/flutkart.dart';
import 'package:kope/utils/my_navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _value = false, _isLoad = false;
  bool _hasdata;
  SharedPreferences prefs;
  String userId = "";
  bool isObscureText = true;
  String username, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: buildScreen());
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = (prefs.getString('userId'));
    });
  }

  Padding buildsignUpTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(
            Flutkart.loginTitle,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
          buildTopCircle()
        ],
      ),
    );
  }

  Row buildTopCircle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Material(
          elevation: 5.0,
          color: Colors.blue[300],
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          child: Container(
            height: 50.0,
            width: 50.0,
            child: Icon(
              Icons.group,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Material(
          elevation: 5.0,
          color: Colors.blue[200],
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ),
      ],
    );
  }

  Row buildBottomCircle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        Material(
          elevation: 5.0,
          color: Colors.blue[200],
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Icon(
              Icons.phone_android,
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Material(
          elevation: 5.0,
          color: Colors.blue[300],
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          child: Container(
            height: 50.0,
            width: 50.0,
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
        ),
        Spacer(),
        buildLoginButton(context)
      ],
    );
  }

  Center buildCenterForm(BuildContext context) {
    return Center(
        child: Material(
          animationDuration: Duration(milliseconds: 500),
          elevation: 5.0,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            height: 250.0,
            width: MediaQuery.of(context).size.width - 20,
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.perm_identity),
                        labelText: 'Username'),
//                validator:(val)=> Locals.validUsername(val),
                    onSaved: (val) => username = val.toLowerCase(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_open),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                isObscureText =
                                isObscureText == true ? false : true;
                              });
                            })),
                    obscureText: isObscureText,
                    validator: (value) => Locals.validatePassword(value),
                    onSaved: (val) => password = val.toLowerCase(),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildScreen() {
    Widget widget;
    if (_isLoad) {
      widget = MyLoading();
    } else {
      widget = ListView(
        children: <Widget>[
          buildsignUpTitle(),
          buildCenterForm(context),
          SizedBox(
            height: 20.0,
          ),
          SwitchListTile(
            value: _value,
            activeColor: Colors.deepOrange,
            secondary: Icon(
              Icons.vpn_key,
              color: Colors.grey,
            ),
            title: Text("Option de Connexion"),
            subtitle: Text(Flutkart.forgetPassword),
            onChanged: (bool value) {
              setState(() {
                _value = value;
              });
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          buildSignInButton(context),
          SizedBox(
            height: 20.0,
          ),
          buildBottomCircle(),
          SizedBox(
            height: 20.0,
          ),
        ],
      );
    }
    return Container(child: Center(child: widget));
  }

  SizedBox buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 50.0,
//      width: 200.0,
      child: FlatButton(
        onPressed: () {
          MyNavigator.gotTo(context, '/sign');
        },
//        color: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Text(
          '${Flutkart.signTitle}',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Row buildSignInButton(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50.0,
            width: MediaQuery.of(context).size.width - 20,
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    _isLoad = true;
                  });
                  _sign().then((value) {
                    setState(() {
                      _isLoad = false;
                    });
                    if (value) {
                      if (_value) prefs.setString('userId', Locals.uid);
                      MyNavigator.goReplace(context, "/home");
                    } else {
                      _showErrorSnackbar(
                          "Nom d\'utilisateur ou mot de passe incorrect");
                      print("=================LOGIN=====================");
                      print("user not exist");
                    }
                  }).catchError((error) {
                    setState(() {
                      _isLoad = false;
                    });
                    _showErrorSnackbar("Probleme de connexion au serveur");
                    print(error);
                  });
                }
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text(
                '${Flutkart.loginText}',
                style: Theme.of(context).primaryTextTheme.button,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _sign() async {
    _hasdata = false;
    print(username);
    print(password);

    await Firestore.instance
        .collection('user')
        .where("username", isEqualTo: username)
        .where("passwords", isEqualTo: password)
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        _hasdata = true;
        Locals.uid = query.documents[0].documentID;
        Locals.username = query.documents[0].data['username'];
        print("user is : ${Locals.uid}");
      }
    });
    return _hasdata;
  }

  _showErrorSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black54,
      ),
    );
  }
}
