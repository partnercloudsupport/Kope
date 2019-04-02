import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kope/cloud/locals/locals.dart';
import 'package:kope/pages/widgets/animation/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({Key key, this.id}) : super(key: key);
  final String id;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<dynamic> _image = List();
  List<String> _images = List();
  int currentPage = 0;
  String _designation, _detail, _categories, _user, _uuid, _tel;
  double _prix = 0.0, _likes = 0.0;
  bool _isLoad = false, uLike = false;
  Firestore _db = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String details =
      "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit essecillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat nonproident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  @override
  void initState() {
    super.initState();
    _isLoad = true;
    getProductData();
  }

  Future getProductData() async {
    try {
      await _db
          .collection("articles")
          .document(widget.id)
          .get()
          .then((DocumentSnapshot doc) {
        if (doc.exists) {
          _designation = doc.data["designation"];
          _categories = doc.data["categories"];
          _detail = doc.data["desc"];
          _likes = doc.data["likes"];
          _prix = doc.data["prix"];
          _user = doc.data["uuid"];
          _image = new List.from(doc.data["images"]);
          int x = 0;
          while (x < _image.length) {
            String key = 'image${x + 1}';
            print("value from db : ${_image[x][key]}");
            _images.add(_image[x][key]);
            x++;
          }
        }
      });
    } catch ($e) {
      Locals.showErrorSnackbar(
          "Une erreur s'est produite, veiller reasseyer", _scaffoldKey);
      print($e);
    }
    setState(() {
      _designation = _designation;
      _categories = _categories;
      _detail = _detail;
      _likes = _likes;
      _prix = _prix;
      _user = _user;
      _images = _images;
      _uuid = _user;
      isLike();
      getUserData();
    });
  }

  Future getUserData() async {
    try {
      await _db
          .collection("user")
          .document(_user)
          .get()
          .then((DocumentSnapshot doc) {
        if (doc.exists) {
          _user = doc.data["nom"];
          _tel = doc.data["tel"];
        }
      });
    } catch (e) {
      Locals.showErrorSnackbar(
          "Une erreur s'est produite, veiller reasseyer", _scaffoldKey);
      print(e);
    }
    print("Le nom du user $_user");
    setState(() {
      _designation = _designation;
      _categories = _categories;
      _detail = _detail;
      _likes = _likes;
      _prix = _prix;
      _user = _user;
      _image = _image;
      getCategorie();
    });
  }

  Future getCategorie() async {
    try {
      await _db
          .collection("categories")
          .document(_categories)
          .get()
          .then((DocumentSnapshot doc) {
        if (doc.exists) {
          _categories = doc.data["name"];
        }
        print("erverything are cool");
      });
    } catch (e) {
      Locals.showErrorSnackbar(
          "Une erreur s'est produite, veiller reasseyer", _scaffoldKey);
      print(e);
    }

    setState(() {
      _designation = _designation;
      _categories = _categories;
      _detail = _detail;
      _likes = _likes;
      _prix = _prix;
      _user = _user;
      _image = _image;
      _isLoad = false;
    });
  }

  Future isLike() async {
    try {
      await _db
          .collection("likes")
          .where("articles", isEqualTo: widget.id)
          .where("uuid", isEqualTo: _uuid)
          .getDocuments()
          .then((QuerySnapshot query) {
        if (query.documents.isNotEmpty) {
          uLike = true;
          print("likes found");
        }
      });
    } catch (e) {
      Locals.showErrorSnackbar(
          "Une erreur s'est produite, veiller reasseyer", _scaffoldKey);
      print(e);
    }
    setState(() {
      uLike = uLike;
    });
  }

  Future addLike() async {
    try {
      await _db.collection("likes").add({'articles': widget.id, 'uuid': _uuid});
      DocumentReference docRef = _db.document("articles/${widget.id}");
      print(docRef.path);
      _db.runTransaction((Transaction tx) async {
        DocumentSnapshot doc = await tx.get(docRef);
        if (doc.exists) {
          print("add likes");
          _likes = doc.data['likes'];
          await tx.update(docRef, <String, dynamic>{
            'likes': doc.data['likes'] + 1.0,
          });
        }
      });
    } catch (e) {
      Locals.showErrorSnackbar(
          "Une erreur s'est produite, veiller reasseyer", _scaffoldKey);
      print(e);
    }
    setState(() {
      uLike = true;
      _likes += 1;
    });
  }

  Future deleteLike() async {
    String ref;
    try {
      await _db
          .collection("likes")
          .where("articles", isEqualTo: widget.id)
          .where("uuid", isEqualTo: _uuid)
          .getDocuments()
          .then((QuerySnapshot query) {
        if (query.documents.isNotEmpty) {
          ref = query.documents[0].documentID;
          uLike = false;
          print("likes processing found id : $ref");
          DocumentReference docRef = _db.document("likes/$ref");
          print(docRef.path);
          _db.runTransaction((Transaction tx) async {
            await tx.delete(docRef);
            print("Deleted like in db");
            docRef = _db.document("articles/${widget.id}");
            _db.runTransaction((Transaction tx) async {
              DocumentSnapshot doc = await tx.get(docRef);
              if (doc.exists) {
                _likes = doc.data['likes'];
                await tx.update(docRef, <String, dynamic>{
                  'likes': doc.data['likes'] - 1.0,
                });
                print("delete number likes $_likes");
                print("Document id number likes ${docRef.path}");
              }
            });
          });
        }
      });
    } catch (e) {
      Locals.showErrorSnackbar(
          "Une erreur s'est produite, veiller reasseyer", _scaffoldKey);
      print(e);
    }
    setState(() {
      uLike = false;
      _likes = _likes;
    });
  }

  List<ImageProvider> getImages() {
    List<ImageProvider> images = List();
    for (var img in _images) {
      images.add(NetworkImage(img));
    }
    return images;
  }

  _buildScreen() {
    Widget widget = Center(
      child: Text('data'),
    );
    if (_isLoad) {
      widget = Center(child: MyLoading());
    } else {
      widget = _buildCustomScreen();
    }
    return widget;
  }

  CustomScrollView _buildCustomScreen() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.grey[200],
          expandedHeight: 250.0,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _designation == null ? "Designation" : _designation,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              background: _images.length == 0
                  ? Image.network(
                      "https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")
                  : Carousel(
                      boxFit: BoxFit.cover,
                      images: getImages(),
                      autoplay: false,
                      animationCurve: Curves.fastLinearToSlowEaseIn,
                      animationDuration: Duration(milliseconds: 5000),
                      dotSize: 4.0,
                      indicatorBgPadding: 8.0,
                    )),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        height: 220.0,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Article Designation',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: Colors.grey)),
                                      SizedBox(height: 5.0),
                                      Text(
                                          _designation == null
                                              ? 'Article Designation'
                                              : _designation,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text('Prix',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                      SizedBox(height: 5.0),
                                      Text(
                                          _prix == 0.0
                                              ? '00 Fc'
                                              : _prix.toString() + " Fc",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 40.0),
                              Text('CATEGORIE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.grey)),
                              SizedBox(height: 5.0),
                              Text(_categories == null
                                  ? 'Electronique'
                                  : _categories),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Likes'),
                                  Column(
                                    children: <Widget>[
                                      Icon(Icons.favorite, color: Colors.red),
                                      SizedBox(height: 5.0),
                                      Text(_likes == 0.0
                                          ? '0'
                                          : _likes.toString())
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Text('Details Article'),
                    Divider(color: Colors.grey),
                    Text(_detail == null ? details : _detail),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: _buildScreen(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            if (index == 1) {
              launch("tel://$_tel");
            } else {
              if (!uLike)
                addLike();
              else
                deleteLike();
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                uLike == false ? Icons.favorite_border : Icons.favorite,
                color: uLike == false ? Colors.deepOrange : Colors.red,
              ),
              title: Text(uLike == false ? 'Aimer' : 'Ne pas Aimer',
                  style: TextStyle(color: Colors.deepOrange)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.call,
                color: Colors.green,
              ),
              title: Text('Appeler', style: TextStyle(color: Colors.green)),
              backgroundColor: Colors.deepOrange,
            )
          ],
        ));
  }
}
