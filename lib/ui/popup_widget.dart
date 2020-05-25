import 'package:book_app/login/authentication.dart';
import 'package:book_app/models/dbSchema.dart';
import 'package:book_app/ui/account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:book_app/classes/book.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/login/root_page.dart';
import 'package:book_app/models/database.dart';
import 'package:book_app/models/api.dart';



import '../models/global.dart';

class PopupWidgets extends StatefulWidget {
  //final BookFunctions Database() = BookFunctions();
  
  @override
  _PopupWidgets createState() => _PopupWidgets();

   changeProfile(String choice, context) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    firestoreInstance.collection("users").document(firebaseUser.uid).updateData( 
    {
      "image" : choice
    }).then((value){});
    Navigator.pop(context);
  }
  changeColour(int choice, context) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    firestoreInstance.collection("users").document(firebaseUser.uid).updateData( 
    {
      "colour" : choice
    }).then((value){});
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RootPage(auth: new Auth())),
    );
  }
  Widget addBook(context){
    String textValue;
    List listValue;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: new BoxDecoration(color: lightGrey, borderRadius:new BorderRadius.circular(25.0),),
        height: 80,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                decoration: new InputDecoration(
                  labelText: "Enter Book Title",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  
                ),
                validator: (value) {
                  if(value.length==0) {
                    return "Title cannot be empty";
                  }else{
                    return null;
                  }
                },
                onFieldSubmitted: (String value) async{
                  Navigator.pop(context);
                  showDialog(
                  context: context,
                  builder: (BuildContext context) => showSearchList(context, value));
                }
              ),
            ),
          ],
        )
      ),
    );
  }

  Future<Widget> getSearchList(context, value) async {
    List<String> url = await Api().fetchBooks(value);
    List<String> isbn = await Api().fetchBookIsbn(value);

    List<Container> list=[];
    for(var x = 0; x < url.length; x++){
      print('popup: ' + url[x].toString());
      list.add(Container(
        color: lightGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              height: 100,
              padding: EdgeInsets.all(5),
              child: Image.network(url[x], fit: BoxFit.fitHeight,),
            ),
            //onTap: () => Database().addBook(context, isbn[x])),
            new GestureDetector(
              child: Icon(
                Icons.add_circle,
                color: darkGrey,
                size: 30,
              ),
              onTap: () => Database().addBook(context, isbn[x]),
            ),
          ],
        ),
      ));
    }
    
    return ListView(children: list,);
  }

  Dialog showSearchList(context, value){
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: new BoxDecoration(color: lightGrey, borderRadius:new BorderRadius.circular(25.0),),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                decoration: new InputDecoration(
                  labelText: "Enter Book Title",
                  //fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  
                ),
                validator: (value) {
                  if(value.length==0) {
                    return "Title cannot be empty";
                  }else{
                    return null;
                  }
                },
                onFieldSubmitted: (String value) async{
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => showSearchList(context, value)));
                  showDialog(
                  context: context,
                  builder: (BuildContext context) => showSearchList(context, value));
                }
              ),
            ),
            Container(
              height: 600,
              child: FutureBuilder<Widget>(
                future: getSearchList(context,value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  else{
                    return Container(height: 30, width: 30, child:CircularProgressIndicator());
                  }
                },        
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showWidget(context){  
    return Dialog(    
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
        ),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Choose a new picture"),
                GestureDetector(
                  child:Image.asset("assets/images/sherlock_profile.png",height:80),
                  onTap: () => changeProfile("sherlock_profile.png", context),
                ),
                GestureDetector(
                  child:Image.asset("assets/images/dobby.png",height:80),
                  onTap: () => changeProfile("dobby.png", context),
                ),
                GestureDetector(
                  child:Image.asset("assets/images/madhatter.png", height:80),
                  onTap: () => changeProfile("madhatter.png", context),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Choose a new Colour"),
                GestureDetector(
                  child:Container(
                    height: 60,
                    width: 60,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: blue,  
                    ),
                  ),
                  onTap: () => changeColour(0, context),
                ),
                GestureDetector(
                  child:Container(
                    height: 60,
                    width: 60,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: purple,  
                    ),
                  ),
                  onTap: () => changeColour(1, context),
                ),
                GestureDetector(
                  child:Container(
                    height: 60,
                    width: 60,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: pink,  
                    ),
                  ),
                  onTap: () => changeColour(2, context),
                ),
              ],
            ),
          ],
        ),
        // child: Row(
        //   children: <Widget>[
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>[
        //         Container(
        //           width: 150,
        //           height: 150,
        //           child: FutureBuilder<StreamBuilder>(
        //             future: Database().getUserBook(collection, isbn),
        //             builder: (context, snapshot) {
        //               if (snapshot.hasData) {
        //                 return snapshot.data;
        //               } else if (snapshot.hasError) {
        //                 return Text("${snapshot.error}");
        //               }
        //               else{
        //                 return CircularProgressIndicator();
        //               }
        //             },        
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.all(10),
        //           height: 50, 
        //           width: 110,
        //           child: FutureBuilder<StreamBuilder>(
        //             future: Database().getAmazonLink(),
        //             builder: (context, snapshot) {
        //               if (snapshot.hasData) {
        //                 return snapshot.data;
        //               } else if (snapshot.hasError) {
        //                 return Text("${snapshot.error}");
        //               }
        //               else{
        //                 return CircularProgressIndicator();
        //               }
        //             },        
        //           )
        //         ),  
                      
        //       ],
        //     ),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>[
        //         Container(
        //           width: 100,
        //           height: 150,
        //           child: FutureBuilder<StreamBuilder>(
        //             future: Database().getProgress(),
        //             builder: (context, snapshot) {
        //               if (snapshot.hasData) {
        //                 return snapshot.data;
        //               } else if (snapshot.hasError) {
        //                 return Text("${snapshot.error}");
        //               }
        //               else{
        //                 return CircularProgressIndicator();
        //               }
        //             },        
        //           ),
        //         ),                     
        //       ],
        //     ),
        //   ],
        // )
      ),
    );
  }

  // Widget bookWidget(context){  
  //   return Dialog(    
  //     child: Container(
  //       height: 300.0,
  //       width: 360.0,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: <Widget>[
  //           Container(
  //             width: 150,
  //             height: 150,
  //             child: FutureBuilder<StreamBuilder>(
  //               future: Database().getUserReading(),
  //               builder: (context, snapshot) {
  //                 if (snapshot.hasData) {
  //                   return snapshot.data;
  //                 } else if (snapshot.hasError) {
  //                   return Text("${snapshot.error}");
  //                 }
  //                 else{
  //                   return CircularProgressIndicator();
  //                 }
  //               },        
  //             ),
  //           ),
  //           Container(
  //             padding: EdgeInsets.all(10),
  //             height: 50, 
  //             width: 110,
  //             child: FutureBuilder<StreamBuilder>(
  //               future: Database().getAmazonLink(),
  //               builder: (context, snapshot) {
  //                 if (snapshot.hasData) {
  //                   return snapshot.data;
  //                 } else if (snapshot.hasError) {
  //                   return Text("${snapshot.error}");
  //                 }
  //                 else{
  //                   return CircularProgressIndicator();
  //                 }
  //               },        
  //             )
  //           ),        
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget bookWidget(context, collection, isbn){  
    return Dialog(  
      child: Container(
        height: 300, 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
        ),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  child: FutureBuilder<StreamBuilder>(
                    future: Database().getUserBook(collection, isbn),
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
                Container(
                  padding: EdgeInsets.all(10),
                  height: 50, 
                  width: 110,
                  child: FutureBuilder<StreamBuilder>(
                    future: Database().getAmazonLink(),
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
                  )
                ),  
                      
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 150,
                  child: FutureBuilder<StreamBuilder>(
                    future: Database().getProgress(),
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
          ],
        )
      ),
    );
  }
}

class _PopupWidgets extends State<PopupWidgets>{
  //BookFunctions Database() = BookFunctions();
  TextEditingController _textcontroller;
  String textValue;
  @override
  Widget build(BuildContext context) {
    void initState() {
      super.initState();
      _textcontroller = TextEditingController();
      Database().getColour().then((result) {
        setState(() {mainColour = result;});
      });
    }
    void dispose() {
      _textcontroller.dispose();
      super.dispose();
    }
    
  }
  // Future<StreamBuilder> loadWidget() async {
  //   var firebaseUser = await FirebaseAuth.instance.currentUser();
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection("reading").snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.hasError)
  //         return new Text('Error: ${snapshot.error}');
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting:
  //           return new Text('Loading...');
  //         default:
  //           DocumentSnapshot ds = snapshot.data.documents[0];
  //           return new Container(
  //             padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
  //             height: 18,
  //             width: 180,
  //             child:  LinearProgressIndicator(
  //               value: (ds['progress']).toDouble(),
  //               backgroundColor: lightGrey,
  //               valueColor: new AlwaysStoppedAnimation<Color>(blue),
  //             ),
  //           ); 
  //       }
  //     },
  //   );
  // }

  // Widget showWidget(){
  //   return new Container(
  //     padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
  //     height: 18,
  //     width: 180,
  //     child:  LinearProgressIndicator(
  //       value: (ds['progress']).toDouble(),
  //       backgroundColor: lightGrey,
  //       valueColor: new AlwaysStoppedAnimation<Color>(blue),
  //     ),
  //     //child: Text((ds['progress']/100).toString()),
  //   );
  // }
 
 

}