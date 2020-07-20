import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:book_app/classes/book.dart';
import 'dart:async' show Future;
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_app/models/database.dart';
import 'package:book_app/ui/popup_widget.dart';






class BookPage extends StatefulWidget {
  // BookPage({Key key, this.auth, this.userId, this.logoutCallback})
  //     : super(key: key);

  // final BaseAuth auth;
  // final VoidCallback logoutCallback;
  // final String userId;


  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage>{
  final firestoreInstance = Firestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //final BookFunctions bookFunctions = new BookFunctions();
  final PopupWidgets popupWidget = new PopupWidgets();


  
  //Future userUid;
  Future<Book> futureBook;

  @override
  void initState() {
    super.initState();
    //futureBook = bookFunctions.loadI("9781460752661");
    //userUid = getUserUid();
  }
  @override
  Widget build(BuildContext context) {

    
    IgnorePointer(ignoring: false,);
    return Container(
      color: darkGrey,
      child: ListView(
        padding: EdgeInsets.only(top:30),
        children: getList(),
      )
    );
  }
  List<Widget> getList() {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var shelves = Database().getShelfList(context);

    List<Container> list=[];
    list.add(Container(
        height: 50,
        color: darkGrey,
        padding: EdgeInsets.only(left: 30),
        child: Text(
          "Reading",
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: lightGrey,
          ),
        ),
    ));
    list.add(Container(
      height: 170,
      color: darkGrey,
      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: new Row(  
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[  
          GestureDetector(
            child:SizedBox(
              height: screenHeight*0.25,
              width: screenWidth*0.3,
              child: FutureBuilder<StreamBuilder>(
                future: Database().getUserReading(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                },        
              ),
            ),
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) => PopupWidgets().bookWidget(context, "reading", ));
            },
          ),
          Container(
            child: FutureBuilder<StreamBuilder>(
              future: Database().getUserProgress(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                else{
                  return CircularProgressIndicator();
                }
              },        
            ),
          ),    
        ],
      ),
    ));
    list.add(Container(
        height: 50,
        color: darkGrey,
        padding: EdgeInsets.only(left: 30, right: 30, top: 20,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              "Up Next",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: lightGrey,
              ),
            ),
            new GestureDetector(
              child: Icon(
                Icons.add_circle,
                color: lightGrey,
                size: 30,
              ),
              //onTap: () => PopupWidgets().showWidget(context),
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => PopupWidgets().addBook(context)),
            ),
          ],
        ), 
    ));
    list.add(Container(
      height: 150,
      child: FutureBuilder<StreamBuilder>(
        future: Database().getUserBooks("books"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          else{
            return CircularProgressIndicator();
          }
        },        
      ),
    ));
    // for(var shelf in shelves){
    list.add(Container(
      height: 150,
      color: Colors.red,
        child: FutureBuilder(
          future: Database().getShelfList(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            else{
              return CircularProgressIndicator();
            }
          },        
        ),
    ));
    //}
    
    list.add(Container(
      height: 80,
      child: GestureDetector(
        child: Icon(Icons.add_box, size: 40, color: lightGrey,),
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => PopupWidgets().addShelfWidget(context, list),
        ),
      ),
    ));
    

    return list;
  }
}

  

  

