import 'package:flutter/material.dart';
import 'package:kope/cloud/models/article.dart';

class StorageScreen extends StatefulWidget {
  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Mes Stockages"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: 100.0,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildSearchBar(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Article art =Article();
                  art.categorie = "categorie";
                  art.designation = "Article";
                  art.prix = 12000.0;
                  return articleCard(article: art);
                }),
            
          ],
        )
      ),
    );
  }

  Widget _buildSearchBar() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      child: TextField(
        onChanged: (text) {},
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
          hintText: 'Rechercher',
          suffixIcon: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class articleCard extends StatelessWidget {
  final Article article;

  const articleCard({ this.article});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Material(
                  elevation: 10.0,
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    child: Icon(
                      Icons.image,
                      size: 100.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "${article.designation}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: -8.0,
                      children: <Widget>[
                        FlightDetailChip(Icons.category, '${article.categorie}'),
                      ],
                    ),
                    FlightDetailChip(Icons.monetization_on, '${article.prix}')
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class FlightDetailChip extends StatelessWidget {
  final IconData iconData;
  final String label;

  FlightDetailChip(this.iconData, this.label);

  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(label),
      labelStyle: TextStyle(color: Colors.black, fontSize: 14.0),
      backgroundColor: Color(0xFFF6F6F6),
      avatar: Icon(
        iconData,
        size: 14.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );
  }
}
