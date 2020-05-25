import 'package:book_app/models/database.dart';
import 'package:book_app/models/global.dart';
import 'package:flutter/material.dart';
import 'ui/navbar.dart';
import 'login/root_page.dart';
import 'login/authentication.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final nav = new Navbar();
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      home: new RootPage(auth: new Auth()));
  }

  // Future getUser() async {

  // }
  // Future getApiKey() {

  // }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.userId, this.logoutCallback, this.title}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Database().getColour().then((result) {
      setState(() {mainColour = result;});
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navbar().navbar(),
    );
  } 
}