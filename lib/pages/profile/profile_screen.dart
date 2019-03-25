import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kope/cloud/locals/locals.dart';
import 'package:kope/cloud/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kope/pages/widgets/animation/loading.dart';
import 'package:kope/pages/widgets/custom_drop_down_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  String _img;
  bool _isComplete, _isLoad = true;
  User _user;
  String uid;
  List<String> countries, cities, provinces;
  List<String> countriesKey, citiesKey, provinceKey;
  int selectedC, selectedCo, selectedPro;
  StorageReference ref;
  Firestore firestore;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String username,
      passwords,
      email,
      tel,
      nom,
      province,
      adresse,
      ville,
      profession,
      pays,
      imagePath,
      cCode = "+243", selectedProv;
  List<String> _provinceList = new List();
  SharedPreferences prefs;
  StorageUploadTask _task = null;

  @override
  void initState() {
    super.initState();
    init();
    countriesKey = new List();
    countries = new List();
    cities = new List();
    citiesKey = new List();
    provinceKey = new List();
    _loadProvince();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = (prefs.getString('userId'));
    });
  }

  picker(bool isCamenra) async {
    print('Picker is called');
    File img = isCamenra
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _image = img;
      // _cropImage(image);
      setState(() {});
    }
  }

  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 130.0,
            color: Color(0xFF737373).withOpacity(1.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Camera'),
                    leading: Icon(Icons.camera, color: Colors.deepOrange),
                    onTap: () {
                      Navigator.pop(context);
                      picker(true);
                    },
                  ),
                  ListTile(
                    title: Text('Gallery'),
                    leading: Icon(Icons.folder_open, color: Colors.lightGreen),
                    onTap: () {
                      Navigator.pop(context);
                      picker(false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                if (_image != null) {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _updateImage();
                  }
                }
              })
        ],
      ),
      body: _buildScreen(),
    );
  }

  Future<bool> _updateProfil() async {
    _isComplete = true;
    tel = cCode + tel.trim();
    // province = provinceKey.elementAt(provinceKey.indexOf(province));
    print("user current id $uid");
    _isComplete = false;
    print("user current province $province");
    selectedProv = provinceKey.elementAt(_provinceList.indexOf(province));
    final DocumentReference docRef = await firestore.document("user/$uid");
    print(docRef.path);
    print("file Url : ${imagePath}");
    firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(docRef);
      print("dound user id :${postSnapshot.documentID}");
      if (postSnapshot.exists) {
        print("User found run update");
        await tx.update(docRef, <String, dynamic>{
          "email": email.trim(),
          "tel": tel.trim(),
          "nom": nom.trim(),
          "profession": profession.trim(),
          "province": selectedProv.trim(),
          "ville": ville.trim(),
          "imagePath": imagePath
        }).catchError((er) {
          setState(() {
            _isLoad = false;
          });
          _isComplete = false;
          _showErrorSnackbar("Une erreur est survenue, veiller reassayer!");
        });
      }
    });
    setState(() {
      _isLoad = false;
    });
    return _isComplete;
  }

  _showErrorSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  _updateImage() async {
    setState(() {
      _isLoad = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.signInAnonymously();
    print(uid);
    ref = FirebaseStorage.instance.ref().child("profiles/" + uid + "-av.jpg");
    print("Image Reference ${ref.path}");
    _task = ref.putFile(_image);
    _task.onComplete.then((task) {
      print("upload tak is correct");
      task.ref.getDownloadURL().then((url) {
        imagePath = url.toString();
        _updateProfil();
      }).catchError((e) {
        print(e);
        _showErrorSnackbar("Une erreur est survenu, essayer");
        setState(() {
          _isLoad = false;
        });
      });
    }).catchError((e) {
      setState(() {
        _isLoad = false;
      });
      print(e);
      _showErrorSnackbar("Une erreur est survenu, essayer");
    });
  }

  Widget _buildScreen() {
    Widget widget;
    if (_isLoad) {
      widget = Center(child: MyLoading());
    } else {
      widget = ListView(children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: _image != null
                  ? Image.file(
                      _image,
                      fit: BoxFit.cover,
                    )
                  : _img == null
                      ? Center(
                          child: Icon(
                            Icons.person,
                            size: 200,
                          ),
                        )
                      : Image(
                          image: NetworkImage(
                            _img,
                          ),
                          fit: BoxFit.cover,
                        ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    _showBottomSheet();
                  }),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Row(
            children: <Widget>[
              Text(
                username == null ? 'My Username' : username,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Nom Complet',
                    ),
                    validator: (value) => Locals.validName(value),
                    onSaved: (val) => nom = val.toLowerCase(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('Province'),
                            Spacer(),
                            CustomDropdownButton(
                              value: province,
                              items: _provinceList,
                              onChanged: (value) {
                                setState(() {
                                  province = value;
                                });
                              },
                            ),
                          ],
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.location_city),
                            labelText: 'Ville',
                          ),
                          validator: (value) =>
                              value == null ? 'Completez la ville' : null,
                          onSaved: (val) => ville = val.toLowerCase(),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.work),
                      labelText: 'Profession',
                    ),
                    validator: (value) =>
                        value == null ? 'Completez la profession' : null,
                    onSaved: (val) => profession = val.toLowerCase(),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        prefixIcon: CountryCodePicker(
                          initialSelection: 'CD',
                          favorite: ['+243', 'CD'],
                          onChanged: (CountryCode countryCode) {
                            cCode = countryCode.toString();
                          },
                        ),
                        labelText: 'Numero Tel'),
                    validator: (value) => Locals.validateMobile(value),
                    onSaved: (val) => tel = val,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email),
                      labelText: 'E-mail',
                    ),
                    validator: (value) => Locals.validateEmail(value),
                    onSaved: (val) => email = val.toLowerCase(),
                  ),
                ],
              ),
            ))
      ]);
    }
    return widget;
  }

  Future _loadCountries() async {
    await Firestore.instance
        .collection('pays')
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        for (DocumentSnapshot e in query.documents) {
          countries.add(e.data["name"]);
          countriesKey.add(e.documentID);
        }
      }
    });
  }

  Future _loadProvince() async {
    firestore = Firestore.instance;
    await firestore
        .collection('province')
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        for (DocumentSnapshot e in query.documents) {
          cities.add(e.data["name"]);
          citiesKey.add(e.documentID);
        }
      }
    });
    setState(() {
      firestore = firestore;
      province = cities[0];
      _provinceList = cities;
      provinceKey = citiesKey;
    });
    _loadUserData();
  }

  Future _loadUserData() async {
    await firestore
        .collection('user')
        .document(uid)
        .get()
        .then((DocumentSnapshot query) {
      if (query.exists) {
        username = query.data["username"];
        _img = query.data["imagePath"];
      }
    });
    setState(() {
      username = username;
      _img = _img;
      _isLoad = false;
    });
  }
}
