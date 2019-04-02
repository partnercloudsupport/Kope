import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kope/pages/home/item_page.dart';
import 'package:kope/pages/product/product_details.dart';
import 'package:kope/pages/widgets/categorie_menu.dart';
import 'package:flutter/material.dart';
import 'package:kope/utils/my_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  SharedPreferences prefs;
  String uid, _username, _email, _img;
  Firestore _db = Firestore.instance;
  int _index = 0;

  List imageNet = [
    "http://www.annonce-offre-emploi.com/templates/arfooo/images/deposer-annonce.gif",
    "https://steveaxentios.ch/cms/wp-content/uploads/2018/10/pub-Coca-Cola-e1539265588644.jpg",
    "https://ichef.bbci.co.uk/news/624/cpsprodpb/3E78/production/_100529951_datapic-ukpubvisiting-i2l1e-nc.png",
    "https://image.jimcdn.com/app/cms/image/transf/dimension=475x1024:format=jpg/path/s8aa582d7fa17cc4f/image/ifa95ef2547ded335/version/1516211354/image.jpg",
    "http://www.congoactuel.com/wp-content/uploads/2018/10/congo-airways-to-wet-lease-4-aircraft-from-ethiopian-airlines.jpg",
    "http://www.rawbank.cd/files/uploads/Festival-Amani-2019.jpeg"
  ];

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: 5);
    _controller.addListener(_handleTabSelection);
    // _controller.animateTo(2);
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = (prefs.getString('userId'));
    });
    _loadUSerData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _handleTabSelection() {
    setState(() {
      _index = _controller.index;
    });
  }

  List<ImageProvider> getImages() {
    List<ImageProvider> images = List();
    for (var img in imageNet) {
      images.add(NetworkImage(img));
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _index != 2 ? new AppBar(title: Center(child: Text('Kope'))) : null,
      drawer: new Drawer(
        elevation: 10.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: _img == null
                  ? CircleAvatar(child: Text('N'))
                  : Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(_img),
                          fit: BoxFit.cover,
                        )),
                      ),
                    ),
              accountName: Text(_username == null ? 'Username' : _username),
              accountEmail: Text(_email == null ? 'Email' : _email),
            ),
            new ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                MyNavigator.gotTo(context, "/profileDetlais");
              },
            ),
            new ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text('Ajouter Produit'),
              onTap: () {
                MyNavigator.gotTo(context, "/product");
              },
            ),
            new ListTile(
              leading: Icon(Icons.storage),
              title: Text('Mes Stockages'),
              onTap: () {
                MyNavigator.gotTo(context, "/storage");
              },
            ),
            // new ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('Home'),
            //   onTap: () {
            //     MyNavigator.gotTo(context, "/items");
            //   },
            // ),
            Spacer(),
            Divider(),
            new ListTile(
              leading: Icon(Icons.lock_open),
              title: Text('Déconnection'),
              onTap: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _index = index;
            _controller.animateTo(_index);
          });
        },
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,
                  color: _index == 0 ? Color(0xFFE52020) : null),
              title: Text("Settings",
                  style: TextStyle(
                      color: _index == 0 ? Color(0xFFE52020) : null))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.help,
                color: _index == 1 ? Color(0xFFE52020) : null,
              ),
              title: Text("Help",
                  style: TextStyle(
                      color: _index == 1 ? Color(0xFFE52020) : null))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _index == 2 ? Color(0xFFE52020) : null,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: _index == 2 ? Color(0xFFE52020) : null),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _index == 3 ? Color(0xFFE52020) : null,
              ),
              title: Text(
                "Profile",
                style: TextStyle(color: _index == 3 ? Color(0xFFE52020) : null),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
                color: _index == 4 ? Color(0xFFE52020) : null,
              ),
              title: Text(
                "Explore",
                style: TextStyle(color: _index == 4 ? Color(0xFFE52020) : null),
              ))
        ],
      ),
      body: _index == 2
          ? CustomScrollView(
              slivers: <Widget>[
                builAppBar(),
                SliverToBoxAdapter(
                    child: new ItemDetails())
              ],
            )
          : buildTabBar(),
    );
  }

  Future _loadUSerData() async {
    await _db
        .collection('user')
        .document(uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        _username = doc["username"];
        _email = doc["email"];
        _img = doc["imagePath"];
      }
    });
    setState(() {
      _username = _username;
      _email = _email;
      _img = _img;
    });
  }

  SliverAppBar builAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.grey[200],
      expandedHeight: 250.0,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Vos annonces",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          background: imageNet.length == 0
              ? Image.network(
                  "https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")
              // ? Image.asset("assets/images/back.jpg", fit: BoxFit.contain)
              : Carousel(
                  boxFit: BoxFit.contain,
                  images: getImages(),
                  autoplay: false,
                  animationCurve: Curves.fastLinearToSlowEaseIn,
                  animationDuration: Duration(milliseconds: 5000),
                  dotSize: 4.0,
                  indicatorBgPadding: 8.0,
                )),
    );
  }

  TabBarView buildTabBar() {
    return TabBarView(controller: _controller, children: <Widget>[
      new Container(
        child: new Center(child: Text('1')),
      ),
      new Container(
        child: new Center(child: Text('Lorem Ipsum')),
      ),
      new ItemDetails(),
      new Container(
        child: new Center(child: Text('...')),
      ),
      new CategorieMenu(),
    ]);
  }
}
