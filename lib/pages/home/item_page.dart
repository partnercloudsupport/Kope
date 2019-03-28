import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kope/cloud/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ItemDetails extends StatefulWidget {
//   @override
//   _ItemDetailsState createState() => _ItemDetailsState();
// }

// class _ItemDetailsState extends State<ItemDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Container(
//             height: 400,
//             child: Column(
//               children: <Widget>[
//                 Text('Text'),

//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class ItemDetails extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ItemDetails> {
  SharedPreferences prefs;
  String uid, _designation, _categorie, _img;
  double _likes;
  List<DocumentSnapshot> _docs = new List();
  Firestore _db = Firestore.instance;
  Article art = Article();
  Stream _stream;

  @override
  void initState() {
    super.initState();
    _load();
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = (prefs.getString('userId'));
    });
    _loadData();
  }

  Future _loadData() async {
    //TODO:update load data
    await _db
        .collection('articles')
        .orderBy("create_at", descending: true)
        .orderBy("designation", descending: false)
        .limit(30)
        .getDocuments()
        .then((QuerySnapshot query) {
      if (query.documents.isNotEmpty) {
        _docs = query.documents;
      }
    });
    setState(() {
      _docs = _docs;
    });
  }

  Stream _load() {
    //TODO:update load data
    Query query = _db
        .collection('articles')
        .orderBy("create_at", descending: true)
        .orderBy("designation", descending: false)
        .limit(30);

    _stream =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));
  }

  Future<String> _loadCateorie(String key) async {
    await _db
        .collection('categories')
        .document(key)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        _categorie = doc["name"];
      }
    });
    // setState(() {_categorie = _categorie;});
    return _categorie;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              height: 250.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 230.0,
                            width: MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                    image: AssetImage('assets/images/back.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                            left: 15.0,
                            top: 130.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Honey Bread',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$88',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: 5.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(7.0),
                        elevation: 2.0,
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.favorite, color: Colors.red),
                              Text(
                                '368',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(7.0),
                        elevation: 2.0,
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.chat_bubble,
                                  color: Colors.grey.withOpacity(0.5)),
                              Text(
                                '76',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(7.0),
                        elevation: 2.0,
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.arrow_forward, color: Colors.grey),
                              Text(
                                '18',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 17.0),
              child: Text(
                'Recemment ajoutés',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
                stream: _db
                    .collection('articles')
                    .orderBy("create_at", descending: true)
                    .orderBy("designation", descending: false)
                    .limit(30)
                    .snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) return Center(child: Text('Loading....'));
                  int count = snap.data.documents.length;
                  return GridView.builder(
                      itemCount: count,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        art = Article();
                        String cat;
                        art.id = snap.data.documents[index].documentID;
                        // _loadCateorie(
                        //         snap.data.documents[index].data["categories"])
                        //     .then((val) {
                        //   cat = val;
                        //   // setState(() {
                        //   //   cat = cat;
                        //   // });
                        // });
                        art.designation =
                            snap.data.documents[index].data["designation"];
                        art.prix = snap.data.documents[index].data["prix"];
                        art.likes = snap.data.documents[index].data["likes"];
                        art.date = snap.data.documents[index].data["create_at"];
                        List<dynamic> list = new List.from(
                            snap.data.documents[index].data["images"]);
                        art.img = list[0]["image1"];
                        // art.categorie = cat;
                        // print(_categorie);
                        // print(art.categorie);
                        return product(art);
                      });
                }),
            SizedBox(height: 10.0)
          ],
        ),
      ]),
    );
  }

  Widget product(Article art) {
    return Card(
      elevation: 10,
      child: InkWell(
        onTap: () {},
        child: GridTile(
          child: Image(
            image: NetworkImage(art.img),
            fit: BoxFit.cover,
          ),
          footer: Container(
            color: Colors.white12,
            child: ListTile(
              // leading: Text(
              //   '${art.designation.toUpperCase()}',
              //   style: TextStyle(
              //       fontWeight: FontWeight.bold, color: Colors.white70,),
              // ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${art.designation.toUpperCase()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        )),
                    
                    Text('${art.prix}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        )),
                    Text('${art.date}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ))
                  ]),
              // title: Text('${art.categorie}'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(Article art, int cardIndex) {
    return Padding(
      padding: cardIndex.isEven
          ? EdgeInsets.only(right: 15.0, bottom: 20.0)
          : EdgeInsets.only(left: 15.0, bottom: 20.0),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
                color: Colors.red, style: BorderStyle.solid, width: 2.0)),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      image: DecorationImage(
                          image: NetworkImage(art.img), fit: BoxFit.cover)),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                      child: Text(
                        art.designation,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                      child: Text(
                        "art.date.toLocal().toString()",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    art.categorie,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                      ),
                      SizedBox(width: 2.0),
                      Text(
                        art.likes.toString(),
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Spacer(),
                      Text(
                        art.prix.toString(),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10.0,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
