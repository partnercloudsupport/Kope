import 'package:kope/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
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
        padding: const EdgeInsets.only(left:20.0, right: 20.0),
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
                child: Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 100.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Username',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    buildLoginButton(context)
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text("Nom Complet"),
              SizedBox(
                height: 25.0,
              ),
              Text("Adresse"),
              SizedBox(
                height: 25.0,
              ),
              Text(
                "Profession",
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                "N° Tel",
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                "E-mail",
              ),
              SizedBox(
                height: 25.0,
              )
            ],
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
