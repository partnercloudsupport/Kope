import 'package:kope/pages/widgets/categorie_menu.dart';
import 'package:kope/pages/widgets/profile_details.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("KopInc"),
          centerTitle: true,
        ),
        bottomNavigationBar: new Material(
            color: Colors.blue[600],
            child: new TabBar(controller: controller, tabs: <Tab>[
              new Tab(icon: new Icon(Icons.help, size: 30.0)),
              new Tab(icon: new Icon(Icons.settings, size: 30.0)),
              new Tab(icon: new Icon(Icons.home, size: 30.0)),
              new Tab(icon: new Icon(Icons.person, size: 30.0)),
              new Tab(icon: new Icon(Icons.explore, size: 30.0)),
            ])),
        body: new TabBarView(controller: controller, children: <Widget>[
          new Container(child: new Center(child: Text('1')),),
          new Container(child: new Center(child: Text('2')),),
          new Container(child: new Center(child: Text('3')),),
          new ProfileDetails(),
          new CategorieMenu(),
        ]));
  }
}
