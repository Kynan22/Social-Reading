import 'package:book_app/login/authentication.dart';
import 'package:book_app/models/dbSchema.dart';
import 'package:book_app/screens/profile/account_page.dart';
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




class SocialWidgets extends StatefulWidget {
  //final BookFunctions Database() = BookFunctions();
  
  @override
  _SocialWidgets createState() => _SocialWidgets();

  // Widget addBook(context){
  //   String textValue;
  //   List listValue;
  //   return Dialog(
  //     backgroundColor: Colors.transparent,
  //     child: Container(
  //       decoration: new BoxDecoration(color: lightGrey, borderRadius:new BorderRadius.circular(25.0),),
  //       height: 80,
  //       width: 200,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  //             child: TextFormField(
  //               decoration: new InputDecoration(
  //                 labelText: "Enter Book Title",
  //                 border: new OutlineInputBorder(
  //                   borderRadius: new BorderRadius.circular(25.0),
  //                   borderSide: new BorderSide(),
  //                 ),
                  
  //               ),
  //               validator: (value) {
  //                 if(value.length==0) {
  //                   return "Title cannot be empty";
  //                 }else{
  //                   return null;
  //                 }
  //               },
  //               onFieldSubmitted: (String value) async{
  //                 Navigator.pop(context);
  //                 showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) => showSearchList(context, value));
  //               }
  //             ),
  //           ),
  //         ],
  //       )
  //     ),
  //   );
  // }
  
  
  Widget addFriend(context){
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
                  labelText: "Enter Friend Handle",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  
                ),
                validator: (value) {
                  if(value.length==0) {
                    return "Handle cannot be empty";
                  }else{
                    return null;
                  }
                },
                onFieldSubmitted: (String value) async{
                  Navigator.pop(context, true);
                  showDialog(
                  context: context,
                  builder: (BuildContext context) => showFriendSearchList(context, value));
                }
              ),
            ),
          ],
        )
      ),
    );
  }

  // Future<Widget> getSearchList(context, value) async {
  //   List<String> url = await Api().fetchBooks(value);
  //   List<String> isbn = await Api().fetchBookIsbn(value);

  //   List<Container> list=[];
  //   for(var x = 0; x < url.length; x++){
  //     print('popup: ' + url[x].toString());
  //     list.add(Container(
  //       color: lightGrey,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: <Widget>[
  //           new Container(
  //             height: 100,
  //             padding: EdgeInsets.all(5),
  //             child: Image.network(url[x], fit: BoxFit.fitHeight,),
  //           ),
  //           //onTap: () => Database().addBook(context, isbn[x])),
  //           new GestureDetector(
  //             child: Icon(
  //               Icons.add_circle,
  //               color: darkGrey,
  //               size: 30,
  //             ),
  //             onTap: () => Database().addBook(context, isbn[x]),
  //           ),
  //         ],
  //       ),
  //     ));
  //   }
    
  //   return ListView(children: list,);
  // }
  
  
  Future<Widget> getFriendSearchList(context, value) async {

    final CollectionReference dbRef = Firestore.instance.collection('users');
    var userHandle = await dbRef.where("handle", isEqualTo: value).getDocuments();
    var userName = await dbRef.where("username", isEqualTo: value).getDocuments();
    List<Widget> list = [];
    List<dynamic> users = [];
    for(var doc in userHandle.documents){
      users.add(doc);
    }
    for(var doc in userName.documents){
      users.add(doc);
    }
    for(var doc in users){
      list.add( Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 60.0,
              height: 60.0,
              //margin: EdgeInsets.only(left: 20),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: colorList[doc.data["colour"]],
              ),
              child: Image.asset(
                "assets/images/"+doc.data["image"],
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              height: 60,
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    doc.data["username"],
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold, 
                      color: darkGrey,
                    ),
                  ),
                  Text(
                    doc.data["handle"],
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold, 
                      color: darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: GestureDetector(
                child: Icon(Icons.person_add, color: darkGrey, size: 25,),
                onTap: () => {Navigator.pop(context), Database().addFriend(doc.data["handle"])},
              )
            )
          ],
        ),
      ));
    }

    return ListView(children: list,);

    //return Text(user.documents[0].data['username']);
  }
  Future<Widget> showFriendsList(context) async {
    
  }
  // Dialog showSearchList(context, value){
  //   return Dialog(
  //     backgroundColor: Colors.transparent,
  //     child: Container(
  //       decoration: new BoxDecoration(color: lightGrey, borderRadius:new BorderRadius.circular(25.0),),
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  //             child: TextFormField(
  //               decoration: new InputDecoration(
  //                 labelText: "Enter Book Title",
  //                 //fillColor: Colors.white,
  //                 border: new OutlineInputBorder(
  //                   borderRadius: new BorderRadius.circular(25.0),
  //                   borderSide: new BorderSide(),
  //                 ),
                  
  //               ),
  //               validator: (value) {
  //                 if(value.length==0) {
  //                   return "Title cannot be empty";
  //                 }else{
  //                   return null;
  //                 }
  //               },
  //               onFieldSubmitted: (String value) async{
  //                 //Navigator.push(context, MaterialPageRoute(builder: (context) => showSearchList(context, value)));
  //                 showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) => showSearchList(context, value));
  //               }
  //             ),
  //           ),
  //           Container(
  //             height: 600,
  //             child: FutureBuilder<Widget>(
  //               future: getSearchList(context,value),
  //               builder: (context, snapshot) {
  //                 if (snapshot.hasData) {
  //                   return snapshot.data;
  //                 } else if (snapshot.hasError) {
  //                   return Text("${snapshot.error}");
  //                 }
  //                 else{
  //                   return Container(height: 30, width: 30, child:CircularProgressIndicator());
  //                 }
  //               },        
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Dialog showFriendSearchList(context, value){
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
                  labelText: "Enter Friend Handle",
                  //fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  
                ),
                validator: (value) {
                  if(value.length==0) {
                    return "Handle cannot be empty";
                  }else{
                    return null;
                  }
                },
                onFieldSubmitted: (String value) async{
                  Navigator.pop(context);
                  showDialog(
                  context: context,
                  builder: (BuildContext context) => showFriendSearchList(context, value));
                }
              ),
            ),
            Container(
              height: 400,
              child: FutureBuilder<Widget>(
                future: getFriendSearchList(context,value),
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

 
  // Widget bookWidget(context, collection, isbn){  
  //   return Dialog(  
  //     child: Container(
  //       height: 300, 
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
  //       ),
  //       child: Row(
  //         children: <Widget>[
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Container(
  //                 width: 150,
  //                 height: 150,
  //                 child: FutureBuilder<StreamBuilder>(
  //                   future: Database().getUserBook(collection, isbn),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.hasData) {
  //                       return snapshot.data;
  //                     } else if (snapshot.hasError) {
  //                       return Text("${snapshot.error}");
  //                     }
  //                     else{
  //                       return CircularProgressIndicator();
  //                     }
  //                   },        
  //                 ),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.all(10),
  //                 height: 50, 
  //                 width: 110,
  //                 child: FutureBuilder<StreamBuilder>(
  //                   future: Database().getAmazonLink(),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.hasData) {
  //                       return snapshot.data;
  //                     } else if (snapshot.hasError) {
  //                       return Text("${snapshot.error}");
  //                     }
  //                     else{
  //                       return CircularProgressIndicator();
  //                     }
  //                   },        
  //                 )
  //               ),
  //               Container(
  //                 padding: EdgeInsets.all(10),
  //                 height: 50, 
  //                 width: 110,
  //                 child: RaisedButton(
  //                   onPressed: () => Database().removeBook(context, collection, isbn),
  //                   padding: EdgeInsets.all(5),
  //                   child: Text("Remove", style: TextStyle(color: darkGrey)),
  //                 )
  //               ),   
                      
  //             ],
  //           ),
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Container(
  //                 width: 100,
  //                 height: 150,
  //                 child: FutureBuilder<StreamBuilder>(
  //                   future: Database().getProgress(),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.hasData) {
  //                       return snapshot.data;
  //                     } else if (snapshot.hasError) {
  //                       return Text("${snapshot.error}");
  //                     }
  //                     else{
  //                       return CircularProgressIndicator();
  //                     }
  //                   },        
  //                 ),
  //               ),                     
  //             ],
  //           ),
  //         ],
  //       )
  //     ),
  //   );
  // }


}

class _SocialWidgets extends State<SocialWidgets>{
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