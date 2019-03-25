import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kope/cloud/locals/locals.dart';
import 'package:kope/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  // SizedBox buildLoginButton(BuildContext context) {}

  SharedPreferences prefs;
  String uid, username, nom, addresse, profession, tel, email, _img, ville;
  Firestore firestore;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // BuildContext context;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = (prefs.getString('userId'));
      // _loadUserData();
    });
  }

  SizedBox buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 30.0,
//      width: 200.0,
      child: FlatButton(
        onPressed: () {
          MyNavigator.gotTo(context, '/profile');
        },
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  bodyWidget(BuildContext context) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Material(
              color: Colors.white,
              elevation: 0.8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100.0,
                    width: 100.0,
                    child: _img == null
                        ? Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                            size: 100.0,
                          )
                        : Image(
                            image: NetworkImage(_img),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          username == null ? 'Username' : username,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        buildLoginButton(context),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(nom == null ? "Nom Complet" : nom),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(addresse == null ? "Adresse" : addresse),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    profession == null ? "Profession" : profession,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    tel == null ? "N° Tel" : tel,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    email == null ? "E-mail" : email,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // this.context = context;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: new AppBar(
        title: Text('Mon Profile'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height / 8),
          Container(
            height: 450.0,
            child: bodyWidget(context),
          )
        ],
      ),
    );
  }

  Future _loadUserData() async {
    print(uid);
    firestore = Firestore.instance;
    await firestore
        .collection('user')
        .document(uid)
        .get()
        .then((DocumentSnapshot query) {
      if (query.exists) {
        username = query.data["username"];
        profession = query.data["profession"];
        nom = query.data["nom"];
        addresse = query.data["province"];
        ville = query.data["ville"];
        tel = query.data["tel"];
        email = query.data["email"];
        _img = query.data["imagePath"];
      }
    });
    setState(() {
      username = username;
      profession = profession;
      nom = nom;
      addresse = addresse;
      // if (addresse != null) _loadAddresse(addresse);
      ville = ville;
      tel = tel;
      email = email;
      _img = _img;
    });
  }

  Future _loadAddresse(String provinceKey) async {
    String key = null;
    await firestore
        .collection("province")
        .document(provinceKey)
        .get()
        .then((DocumentSnapshot query) {
      if (query.exists) {
        addresse = ville;
        addresse = addresse + ", " + query.data["name"];
        key = query.data["pays"];
      }
    }).catchError((e) {
      print(e);
      Locals.showErrorSnackbar(
          "Une erreur s'est produite reessayer", _scaffoldKey);
    });
    setState(() {
      addresse = addresse;
      if (key != null) _loadPays(key);
    });
  }

  Future _loadPays(String paysKey) async {
    await firestore
        .collection("pays")
        .document(paysKey)
        .get()
        .then((DocumentSnapshot query) {
      if (query.exists) {
        addresse = addresse + ", " + query.data["name"];
      }
    }).catchError((e) {
      print(e);
      Locals.showErrorSnackbar(
          "Une erreur s'est produite reessayer", _scaffoldKey);
    });
    setState(() {
      addresse = addresse;
    });
  }
}
