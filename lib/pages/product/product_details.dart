import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<File> _image = List<File>();
  int currentPage = 0;
  final PageController ctrl = PageController(viewportFraction: 0.8);
  List imageNet = [
    "https://odelices.ouest-france.fr/images/recettes/cake-olive-parmesan-820x582.jpg",
    "http://idata.over-blog.com/3/64/93/53/2012/BBBBBBBBBBB.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKrLnXltptVZDmbtNTeps6PDWebIX-pQ3r4cewctf6Gg1fhY9k6Q",
    "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/articles/health_tools/brain_food_slideshow/getty_rf_photo_of_dietary_supplements.jpg",
    "https://foodimentaryguy.files.wordpress.com/2014/11/healthfitnessrevolution-com.jpg",
    "https://static-cdn.jtvnw.net/ttv-boxart/Food%20%26%20Drink.jpg"
  ];

  String details = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit essecillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat nonproident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  List<ImageProvider> getImages(){
    List<ImageProvider> images = List();
    for (var img in imageNet) {
      images.add(NetworkImage(img));
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
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
                    "Designation",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
                background: imageNet.length == 0
                ? Image.network("https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")
                    // ? Image.asset("assets/images/back.jpg", fit: BoxFit.contain)
                    : Carousel(
                      boxFit: BoxFit.contain,
                      images: getImages(),
                      autoplay: true,
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
                                        Text('Article Designation',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text('Prix',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green)),
                                        SizedBox(height: 5.0),
                                        Text('7000 Fc',
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
                                Text('Electronique'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Likes'),
                                    Column(
                                      children: <Widget>[
                                        Icon(Icons.favorite, color: Colors.red),
                                        SizedBox(height: 5.0),
                                        Text('45')
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
                      Text('$details'),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, color: Colors.deepOrange,),
            title: Text('Aimer', style: TextStyle(color: Colors.deepOrange)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call, color: Colors.green,),
            title: Text('Appeler',style: TextStyle(color: Colors.green)),
            backgroundColor: Colors.deepOrange
          )
        ],
      )
    );
  }

  _buildStoryPage(File img, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 1 : 2;

    return AnimatedContainer(
      width: MediaQuery.of(context).size.width,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 1, right: 3),
      child: Image.file(img,
          fit: BoxFit.contain, width: MediaQuery.of(context).size.width),
    );
  }
}
