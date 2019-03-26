import 'package:kope/pages/home/item_page.dart';
import 'package:kope/pages/widgets/categorie_menu.dart';
import 'package:flutter/material.dart';
import 'package:kope/utils/my_navigator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _index = 2;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: 5);
    _controller.addListener(_handleTabSelection);
    _controller.animateTo(_index);
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
          icon: Icon(Icons.search,color: Colors.white),
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
                currentAccountPicture: CircleAvatar(
                  child: Text('N'),
                ),
                accountName: Text('Username'),
                accountEmail: Text('Email'),
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
          ItemDetails(),
          new Container(
            child: new Center(child: Text('...')),
          ),
          new CategorieMenu(),
        ]));
  }
}
