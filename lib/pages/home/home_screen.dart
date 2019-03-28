import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kope/pages/home/item_page.dart';
import 'package:kope/pages/widgets/categorie_menu.dart';
import 'package:kope/pages/profile/profile_details.dart';
import 'package:flutter/material.dart';
import 'package:kope/utils/my_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: 5);
    _controller.addListener(_handleTabSelection);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kope', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
              color: Colors.grey,
            ),
          ],
        ),
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
                  style:
                      TextStyle(color: _index == 2 ? Color(0xFFE52020) : null),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: _index == 3 ? Color(0xFFE52020) : null,
                ),
                title: Text(
                  "Profile",
                  style:
                      TextStyle(color: _index == 3 ? Color(0xFFE52020) : null),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.explore,
                  color: _index == 4 ? Color(0xFFE52020) : null,
                ),
                title: Text(
                  "Explore",
                  style:
                      TextStyle(color: _index == 4 ? Color(0xFFE52020) : null),
                ))
          ],
        ),
        body: new TabBarView(controller: _controller, children: <Widget>[
          new Container(
            child: new Center(child: Text('1')),
          ),
          new Container(
            child: new Center(child: Text('2')),
          ),
          new ItemDetails(),
          new Container(
            child: new Center(child: Text('...')),
          ),
          new CategorieMenu(),
        ]));
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
}
