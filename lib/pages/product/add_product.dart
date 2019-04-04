import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kope/cloud/locals/locals.dart';
import 'package:kope/pages/widgets/animation/loading.dart';
import 'package:kope/pages/widgets/custom_drop_down_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String categorie, _desc, _designation, _prix;
  List<String> _categorieList, _categorieKey;
  List<File> _image = List<File>();
  final PageController ctrl = PageController(viewportFraction: 0.8);
  Firestore _db = Firestore.instance;
  bool _isComplete, _isLoad = false;
  int _limitP = 5;
  StorageReference ref;
  SharedPreferences prefs;
  String uid;
  List<dynamic> _pathImages;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StorageUploadTask _task = null;
  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    init();
    _categorieList = new List();
    _categorieKey = new List();
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = (prefs.getString('userId'));
    });
    _loadCategorie();
  }

  picker(bool isCamenra) async {
    print('Picker is called');
    File img = isCamenra
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _image.add(img);

      setState(() {
        _limitP = _limitP - 1;
      });
    }
  }

  _buildStoryPage(File img, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 1 : 2;

    return AnimatedContainer(
      width: MediaQuery.of(context).size.width,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 1, right: 3),
      child: Image.file(img,
          fit: BoxFit.contain, width: MediaQuery.of(context).size.width),
    );
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

  _removeImage() {
    if (_image.length != 0) {
      _limitP = _limitP + 1;
      setState(() {
        _image.removeAt(currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    Widget widget;
    if (_isLoad) {
      widget = Center(
        child: MyLoading(),
      );
    } else {
      widget = CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey,
            expandedHeight: 250.0,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Ajouter un article",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: _image.length == 0
                    ? Image.asset("assets/images/back.jpg", fit: BoxFit.contain)
                    : PageView.builder(
                        controller: ctrl,
                        itemCount: _image.length,
                        itemBuilder: (context, int currentIdx) {
                          // Active page
                          // if (currentIdx == 0)
                          //   return _buildStoryPage(
                          //       _image[0], true);
                          bool active = currentIdx == currentPage;
                          return _buildStoryPage(_image[currentIdx], active);
                        })),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Material(
                    elevation: 5.0,
                    child: Container(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _limitP != 0
                              ? RaisedButton(
                                  child: Text('Add Photo'),
                                  onPressed: () {
                                    _showBottomSheet();
                                  },
                                )
                              : SizedBox(
                                  width: 1,
                                ),
                          SizedBox(
                            width: 10.0,
                          ),
                          RaisedButton(
                            child: Text(
                              'Remove Photo',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              _removeImage();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Material(
                    elevation: 10.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          height: 400.0,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.category, color: Colors.grey),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(width: 5.0),
                                  CustomDropdownButton(
                                    value: categorie,
                                    items: _categorieList,
                                    onChanged: (value) {
                                      setState(() {
                                        categorie = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.edit),
                                  labelText: 'Designation',
                                ),
                                validator: (value) => value == null
                                    ? 'Completez la designation'
                                    : null,
                                onSaved: (val) =>
                                    _designation = val.toLowerCase().trim(),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.monetization_on),
                                  labelText: 'Prix',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value == null ? 'Completez le prix' : null,
                                onSaved: (val) =>
                                    _prix = val.toLowerCase().trim(),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.description),
                                  labelText: 'Description',
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                validator: (value) => value == null
                                    ? 'Completez la description'
                                    : null,
                                onSaved: (val) =>
                                    _desc = val.toLowerCase().trim(),
                              ),
                              Spacer(),
                              RaisedButton(
                                  child: Text('Ajouter'),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      _uploadTask();
                                      // Locals.showSuccess(context);
                                    }
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }
    return widget;
  }

  Future<bool> _saveData() async {
    print("image number : ${_pathImages.length}");
    await _db.collection("articles").add({
      'uuid': uid,
      'categories': _categorieKey.elementAt(_categorieList.indexOf(categorie)),
      'desc': _desc,
      'designation': _designation,
      'prix': double.parse(_prix),
      'images': _pathImages,
      'create_at': DateTime.now(),
      'likes' : 0.0
    }).catchError((e) {
      setState(() {
        _isLoad = false;
      });
      print(e);
      Locals.showErrorSnackbar(
          "Une erreur s'est produite reessayer", _scaffoldKey);
    });
    setState(() {
      _isLoad = false;
      _image = new List();
    });
    print("all is good");
    Locals.showSuccess(context);
    return _isComplete;
  }

  Future _loadCategorie() async {
    await _db
        .collection('categories')
        .orderBy("name", descending: false)
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        for (DocumentSnapshot e in query.documents) {
          _categorieList.add(e.data["name"]);
          _categorieKey.add(e.documentID);
        }
      }
    });
    setState(() {
      categorie = _categorieList[0];
    });
  }

  _uploadTask() async {
    setState(() {
      _isLoad = true;
    });
    String _imagePath;
    _pathImages = new List();
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.signInAnonymously();

    for (File _img in _image) {
      int currentIndex = _image.indexOf(_img);
      var dt = DateTime.now().millisecondsSinceEpoch.toString();
      ref = FirebaseStorage.instance
          .ref()
          .child("uploads/" + "img-" + dt + uid + "-av.jpg");
      print("Image Reference ${ref.path}");
      _task = ref.putFile(_img);
      _task.onComplete.then((task) {
        print("upload tak is correct");
        task.ref.getDownloadURL().then((url) {
          _imagePath = url.toString();
          _pathImages.add({'image${_pathImages.length + 1}': _imagePath});
          if (_img == _image.last) _saveData();
        }).catchError((e) {
          print(e);
          Locals.showErrorSnackbar(
              "Une erreur est survenu, essayer", _scaffoldKey);
          return;
        });
      }).catchError((e) {
        print(e);
        Locals.showErrorSnackbar(
            "Une erreur est survenu, essayer", _scaffoldKey);
        return;
      });
    }
  }
}
