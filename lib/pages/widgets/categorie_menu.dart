import 'package:flutter/material.dart';
import './categoriesList.dart' as categoriesList;

class CategorieMenu extends StatefulWidget {
  @override
  _CategorieMenuState createState() => _CategorieMenuState();
}

class _CategorieMenuState extends State<CategorieMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: new GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 25.0),
          padding: const EdgeInsets.all(10.0),
          itemCount: categoriesList.list.length,
          itemBuilder: (BuildContext context, int index) {
            return new GridTile(
              footer: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Flexible(
                      child: new SizedBox(
                        height: 20.0,
                        width: 80.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: new Text(
                            categoriesList.list[index]["name"],
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0,)
                  ]),
              child: new Container(
                child: new GestureDetector(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new SizedBox(
                        height: 90.0,
                        width: 90.0,
                        child: new Row(
                          children: <Widget>[
                            new Stack(
                              children: <Widget>[
                                new SizedBox(
                                  child: new Container(
                                    child: new CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40.0,
                                      child: new Icon(
                                          categoriesList.list[index]["icon"],
                                          size: 40.0,
                                          color: categoriesList.list[index]
                                              ["color"]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            );
          },
        ));
  }
}
