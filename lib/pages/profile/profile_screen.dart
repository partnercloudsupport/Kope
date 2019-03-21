import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:kope/cloud/locals/locals.dart';
import 'package:kope/cloud/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kope/pages/widgets/custom_drop_down_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  bool _isComplete;
  User _user;
  String uid;
  List<String> countries, cities, provinces;
  List<String> countriesKey, citiesKey, provinceKey;
  int selectedC, selectedCo, selectedPro;
  StorageReference ref;
  var collection = Firestore.instance.collection("user");
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
      cCode = "+243";
  List<String> _provinceList = ["Kinshasa", "Nord-Kivu"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countriesKey = new List();
    countries = new List();
    cities = new List();
    citiesKey = new List();
    provinceKey = new List();
    province = _provinceList[0];
    _loadCountries();
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
                    //update here
                  }
                }
              })
        ],
      ),
      body: ListView(children: <Widget>[
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
                  : Center(
                      child: Icon(
                        Icons.person,
                        size: 200,
                      ),
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
                'My Username',
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
                    validator:(value)=> Locals.validName(value),
                    onSaved: (val) => username = val.toLowerCase(),
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
      ]),
    );
  }

  Future<bool> _UpdateProfil() async {
    _isComplete = true;
    ville = citiesKey.elementAt(selectedC);
    pays = countriesKey.elementAt(selectedCo);
    province = provinceKey.elementAt(selectedPro);
    final DocumentReference docRef = Firestore.instance.document('user/$uid');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(docRef);
      if (postSnapshot.exists) {
        await tx.update(docRef, <String, dynamic>{
          username: username,
          passwords: passwords,
          email: email,
          tel: tel,
          adresse: adresse,
          nom: nom,
          profession: profession,
          province: province,
          ville: ville,
          pays: pays,
          imagePath: ref.toString(),
        }).catchError((er) {
          _isComplete = false;
          _showErrorSnackbar("Une erreur est survenue, veiller reassayer!");
        });
      }
    });

    return _isComplete;
  }

  _showErrorSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future _updateImage() async {
    ref = FirebaseStorage.instance.ref().child(uid + "-av.jpg");
    final StorageUploadTask task = await ref.putFile(_image);
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

  Future _loadProvince(String countriesKey) async {
    await Firestore.instance
        .collection('province')
        .where("pays", isEqualTo: countriesKey)
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        for (DocumentSnapshot e in query.documents) {
          cities.add(e.data["name"]);
          citiesKey.add(e.documentID);
        }
      }
    });
  }

  Future _loadCities(String provinceKey) async {
    await Firestore.instance
        .collection('ville')
        .where("province", isEqualTo: provinceKey)
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        for (DocumentSnapshot e in query.documents) {
          cities.add(e.data["name"]);
          citiesKey.add(e.documentID);
        }
      }
    });
  }
}
