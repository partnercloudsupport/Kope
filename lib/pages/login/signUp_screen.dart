import 'package:kope/cloud/locals/locals.dart';
import 'package:kope/cloud/models/user.dart';
import 'package:kope/pages/widgets/dialog.dart';
import 'package:kope/utils/flutkart.dart';
import 'package:kope/utils/my_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignScreen extends StatefulWidget {
  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  bool _isSent, _isExist, _isWorking = false, isAccept = false;
  String username, password, email, tel, _message, cCode = "+243";
  SharedPreferences prefs;
  String userId = null;
  var collection = Firestore.instance.collection("user");
  bool isObscureText = true;
  String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(),
    );
  }

  Padding buildsignUpTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(
            Flutkart.signTitle,
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
              Icons.shopping_basket,
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
              Icons.email,
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
              Icons.lock,
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
          height: 400.0,
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
                      prefixIcon: Icon(Icons.perm_identity), labelText: 'Nom'),
//                  validator:(value)=> Locals.validUsername(value),
                  onSaved: (val) => username = val.toLowerCase(),
                ),
//                SizedBox(height: 10.0,),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      prefixIcon: CountryCodePicker(
                      initialSelection: 'CD',
                      favorite: ['+243','CD'],
                      onChanged: (CountryCode countryCode){
                        cCode = countryCode.toString();
                      },
                    ),
                      labelText: 'Numero Tel'),
                  validator: (value) => Locals.validateMobile(value),
                  onSaved: (val) => tel = val,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email), labelText: 'E-mail'),
                  validator: (value) => Locals.validateEmail(value),
                  onSaved: (val) => email = val.toLowerCase(),
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
                  validator: (value) => Locals.validatePassword(value),
                  obscureText: isObscureText,
                  onSaved: (val) => password = val.toLowerCase(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 50.0,
//      width: 200.0,
      child: FlatButton(
        onPressed: () {
          MyNavigator.goReplace(context, '/login');
        },
//        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Text(
          '${Flutkart.loginText}',
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
                  tel = cCode + tel;
                  _message = "Nous allons vérifier le numéro de téléphone";
                  _message = _message + "\n            $tel";
                  _message = _message +
                      "\nest-ce correct ou souhaitez-vous modifier le numéro?";
                  print("ok");
                  MyDialog.dialog(context, _message).then((value) {
                    if (value) _userVerification();
                  }).catchError((e) {
                    print(e);
                    _showErrorSnackbar("Une erreur est survenue, reessayer");
                  });
                }
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text(
                '${Flutkart.SignText}',
                style: Theme.of(context).primaryTextTheme.button,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _userVerification() {
    //TODO:doms: uncomment for check number
    //                    _checkNumber().then((isExist){
    //                      if(isExist){
    //                        setState(() {
    //                          _isWorking = false;
    //                        });
    //                        _showErrorSnackbar("Ce numero est deja utilisé plusieur fois");
    //                      }else{
    //                        _checkUsername().then((isExist){
    //                            if(isExist){
    //                              setState(() {
    //                                _isWorking = false;
    //                              });
    //                              _showErrorSnackbar("Ce numero est deja utilisé plusieur fois");
    //                            }else{
    //                              _signInWithPhoneNumber();
    //                              User user = new User(
    //                                username: username,
    //                                passwords: password,
    //                                tel: tel,
    //                                email: email
    //                              );
    //                              Locals.user = user;
    //                              MyNavigator.gotTo(context, '/validation');
    //                            }
    //                        }).catchError((e){
    //                          print(e);
    //                          _showErrorSnackbar("Une erreur est survenue, reessayer");
    //                        });
    //                      }
    //                    }).catchError((e){
    //                      print(e);
    //                      _showErrorSnackbar("Une erreur est survenue, reessayer");
    //                    });
    _checkUsername().then((isExist) {
      setState(() {
        _isWorking = false;
      });
      if (isExist) {
        _showErrorSnackbar("Ce numero est deja utilisé plusieur fois");
      } else {
        _signInWithPhoneNumber();
        User user = new User(
            username: username, passwords: password, tel: tel, email: email);
        Locals.user = user;

        MyNavigator.gotTo(context, '/validation');
      }
    }).catchError((e) {
      setState(() {
        _isWorking = false;
      });
      print(e);
      _showErrorSnackbar("Une erreur est survenue, reessayer");
    });
  }

  Widget _buildBody() {
    if (!_isWorking) {
      return ListView(
        children: <Widget>[
          buildsignUpTitle(),
          buildCenterForm(context),
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
    } else
      return Locals.loading();
  }

  Future<void> _signInWithPhoneNumber() async {
    _isSent = false;

    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      print("onVerificationCompleted, user: $user");
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _showErrorSnackbar(
          "We couldn't verify your code for now, please try again!");
      print(
          'onVerificationFailed, code: ${authException.code}, message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) {
      print("Verification code sent to number $tel");
      Locals.verifyID = verificationId;
      this.verificationId = verificationId;
      print(Locals.verifyID);
      setState(() {
        _isSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("onCodeTimeout");
      this.verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: tel,
        timeout: new Duration(seconds: 90),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  } // PhoneCodeAutoRetrievalTimeout

  _showErrorSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> _checkUsername() async {
    _isExist = false;
    setState(() {
      _isWorking = true;
    });
    print(username);
    print(password);

    await Firestore.instance
        .collection('user')
        .where("username", isEqualTo: username)
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        _isExist = true;
      }
    });

    return _isExist;
  }

  Future<bool> _checkNumber() async {
    _isExist = false;
    setState(() {
      _isWorking = true;
    });
    print(tel);

    await Firestore.instance
        .collection('user')
        .where("tel", isEqualTo: tel)
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        print("Number of account :" + query.documents.length.toString());
        if (query.documents.length == 2) _isExist = true;
      }
    });

    return _isExist;
  }
}
