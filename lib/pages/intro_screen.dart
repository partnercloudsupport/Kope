
import 'package:flutter/material.dart';
import 'package:kope/utils/flutkart.dart';
import 'package:kope/utils/my_navigator.dart';
import 'package:kope/widgets/walkthrough.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;
  SharedPreferences prefs;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirst = prefs.getBool('isFirst');
    });
  }
  void _setPreferences(BuildContext context) {
    prefs.setBool('isFirst', false);
    MyNavigator.goReplace(context, "/login");
  }
  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/images/back.jpg"), fit: BoxFit.cover)),
//      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Center(
              child: FlutterLogo(
                size: 70.0,
              )),
          Expanded(
            flex: 3,
            child: PageView(
              children: <Widget>[
                Walkthrough(
                  title: Flutkart.wt1,
                  content: Flutkart.wc1,
                  imageIcon: Icons.mobile_screen_share,
                ),
                Walkthrough(
                  title: Flutkart.wt2,
                  content: Flutkart.wc2,
                  imageIcon: Icons.search,
                ),
                Walkthrough(
                  title: Flutkart.wt3,
                  content: Flutkart.wc3,
                  imageIcon: Icons.shopping_cart,
                ),
                Walkthrough(
                  title: Flutkart.wt4,
                  content: Flutkart.wc4,
                  imageIcon: Icons.check,
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                    color: lastPage ? Colors.transparent : Colors.redAccent,
                    child: Text(lastPage ? "" : Flutkart.skip,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    elevation: 3.0,
                    onPressed: () {
                      // ignore: unnecessary_statements
                      lastPage ? null : _setPreferences(context);
                    }),
                RaisedButton(
                    color: Colors.redAccent,
                    child: Text(lastPage ? Flutkart.gotIt : Flutkart.next,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    elevation: 3.0,
                    onPressed: () {
                      lastPage
                          ? _setPreferences(context)
                          : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
