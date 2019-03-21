import 'package:kope/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {

  SizedBox buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 30.0,
//      width: 200.0,
      child: FlatButton(
        onPressed: () {
          MyNavigator.gotTo(context, '/profile');
        },
        color: Colors.blue,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  bodyWidget(BuildContext context) => Stack(
    children: <Widget>[
      Positioned(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width - 20,
        left: 10.0,
        top: MediaQuery.of(context).size.height * 0.1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Username',
                      style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    buildLoginButton(context)
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Text("Nom Complet"),
              SizedBox(height: 25.0,),
              Text("Adresse"),
              SizedBox(height: 25.0,),
              Text(
                "Profession",
              ),
              SizedBox(height: 25.0,),
              Text(
                "N° Tel",
              ),
              SizedBox(height: 25.0,),
              Text(
                "E-mail",
              )
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Hero(
            tag: 'tag',
            child: Container(
              height: 200.0,
              width: 200.0,
              child: Icon(
                Icons.account_circle,
                color: Colors.grey,
                size: 100.0,
              ),
            )),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: bodyWidget(context),
    );
  }
}
