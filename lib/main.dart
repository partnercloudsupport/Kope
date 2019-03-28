import 'package:kope/pages/home/home_screen.dart';
import 'package:kope/pages/home/item_page.dart';
import 'package:kope/pages/intro_screen.dart';
import 'package:kope/pages/login/login_screen.dart';
import 'package:kope/pages/login/signUp_screen.dart';
import 'package:kope/pages/login/validation_number_screen.dart';
import 'package:kope/pages/product/add_product.dart';
import 'package:kope/pages/profile/profile_screen.dart';
import 'package:kope/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kope/pages/profile/profile_details.dart';
import 'package:kope/pages/stockage/storage_screen.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
  "/intro": (BuildContext context) => IntroScreen(),
  "/login": (BuildContext context) => LoginScreen(),
  "/sign": (BuildContext context) => SignScreen(),
  "/validation": (BuildContext context) => ValidationPhoneNumber(),
  "/profile": (BuildContext context) => ProfileScreen(),
  "/profileDetlais": (BuildContext context) => ProfileDetails(),
  "/product": (BuildContext context) => AddProduct(),
  "/storage": (BuildContext context) => StorageScreen(),
  "/items": (BuildContext context) => ItemDetails(),
};
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.blue,
            buttonColor: Colors.blue,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            )
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: routes);
  }
}


// import "package:flutter/material.dart";

// void main()=>runApp(
//   MaterialApp(
//     title: "Sliver",
//     home: new Home(),
//     theme: ThemeData(
//       primaryColor: Colors.blue
//     ),
//   )
// );

// class Home extends StatelessWidget{

//   List<String> itemData = ["one","two","three","four","car","two","three","one","car"];

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             expandedHeight: 350.0,
//             pinned: true,
//             floating: false,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text("Sliver title"),
//               background: Image.asset("assets/images/back.jpg",fit: BoxFit.cover,)
//             ),
//           ),
//           SliverList(
//               delegate: SliverChildBuilderDelegate((contex,index){
//                 return Card(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Container(

//                           padding: EdgeInsets.all(5.0),
//                             decoration: BoxDecoration(
// //                          color: Colors.grey,
//                                 borderRadius: BorderRadius.circular(5.0)
//                             ),
//                             width: 100.0,
//                             height: 100.0,
//                             child:InkWell(
//                                 onTap: (){
//                                   Navigator.of(context).push(new PageRouteBuilder(
//                                       opaque: false,
//                                       barrierDismissible:true,
//                                       pageBuilder: (BuildContext context, _, __) {
//                                         return Container(
//                                           color: Colors.black38,
//                                           alignment: Alignment.center,
//                                           child: Material(
//                                               color: Colors.redAccent.withOpacity(0.0),
//                                               child: InkWell(
//                                               onTap: (){
//                                                 print("clikc");
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Hero(
//                                                 tag:"img",
//                                                 child: Image.asset("assets/images/back.jpg",
//                                                   fit: BoxFit.cover,
//                                                   height: 300.00,
//                                                   width: 300.0,
//                                                 ),
//                                               ),
//                                             )
//                                           ),
//                                         );
//                                       }));
//                                 },
//                                 child: Hero(
//                                   tag: "img",
//                                   child: Material(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                     elevation: 5.0,
//                                     child: Stack(
//                                       fit: StackFit.expand,
//                                       children: <Widget>[
//                                         Image.asset("assets/images/back.jpg",fit: BoxFit.fill),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                             )
//                         ),
//                       Expanded(
//                           child: Padding(
//                               padding: EdgeInsets.all(5.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: <Widget>[
//                                   Text("Title $index",style: TextStyle(fontSize: 16.0),),
//                                   Text("Title Description $index Title Description $index Title Description $index Title Description $index Title Description $index Title Description $index",style: TextStyle(fontSize: 13.0),),
//                                 ],
//                               ),
//                           )
//                     ),

//                     ],
//                   )
//                 );
//               },
//               childCount: itemData.length
//             ),
//           )
//         ],
//       )
//     );
//   }
// }