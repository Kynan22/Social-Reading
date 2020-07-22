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

  // Widget addReading(context){
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


  Widget addShelfWidget(context, list){
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
                  labelText: "Enter Shelf Name",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  
                ),
                validator: (value) {
                  if(value.length==0) {
                    return "Shelf name cannot be empty";
                  }else{
                    return null;
                  }
                },
                onFieldSubmitted: (String value) async{
                  Navigator.pop(context);
                  list.add(Container(height: 100, width: 100, child:Text(value)));
                  Database().addShelf(context, value);
                }
              ),
            ),
          ],
        )
      ),
    );
  }

  Future<Widget> getSearchList(context, value) async {
    Book books = await Api().fetchBooks(value);
    
    // var screenWidth = MediaQuery.of(context).size.width;
    // var screenHeight = MediaQuery.of(context).size.height;

    List<Container> list=[];
    var isbn;
    for(var item in books.items){
      if(item.volumeInfo.industryIdentifiers != null &&
        item.volumeInfo.imageLinks != null &&
        item.volumeInfo.title != null &&
        item.volumeInfo.authors != null &&
        item.volumeInfo.publishedDate != null){
          if(item.volumeInfo.industryIdentifiers.length > 1){
            if(item.volumeInfo.industryIdentifiers[0].toJson()['identifier'].toString().length == 13){
              list.add(Container(

                color: lightGrey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Container(
                      height: 120,
                      width: 100,
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Image.network(item.volumeInfo.imageLinks.toJson()['thumbnail'].toString(), fit: BoxFit.fitHeight,),
                    ),
                    //onTap: () => Database().addBook(context, isbn[x])),

                    new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.volumeInfo.toJson()['title'].toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        Text(item.volumeInfo.toJson()['authors'][0].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                        Text("Published " + item.volumeInfo.toJson()['publishedDate'].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    new GestureDetector(
                      child: Icon(
                        Icons.add_circle,
                        color: darkGrey,
                        size: 30,
                      ),
                      onTap: () => Database().addBook(context, item.volumeInfo.industryIdentifiers[0].toJson()['identifier'].toString()),
                    ),
                  ],
                ),
              ));            
            }
            else{
              list.add(Container(
                
                color: lightGrey,
                child: Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        height: 120,
                        width: 100,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Image.network(item.volumeInfo.imageLinks.toJson()['thumbnail'].toString(), fit: BoxFit.fitHeight,),
                      ),
                      //onTap: () => Database().addBook(context, isbn[x])),

                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child:  Text(
                              item.volumeInfo.toJson()['title'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                              )
                            ),


                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child:  Text(
                              item.volumeInfo.toJson()['authors'][0].toString(), 
                              style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.w400
                              )
                            ),


                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Published " + item.volumeInfo.toJson()['publishedDate'].toString(), 
                              style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.w400
                              )
                            ),

                          ),
                          // Text(item.volumeInfo.toJson()['title'].toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          // Text(item.volumeInfo.toJson()['authors'][0].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                          // Text("Published " + item.volumeInfo.toJson()['publishedDate'].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      new GestureDetector(
                        child: Icon(
                          Icons.add_circle,
                          color: darkGrey,
                          size: 30,
                        ),
                        onTap: () => Database().addBook(context, item.volumeInfo.industryIdentifiers[1].toJson()['identifier'].toString()),
                      ),
                    ],
                  ),
                ),
              ));
            }
          }

        }


    }

    // for(var x = 0; x < url.length; x++){
    //   print('popup: ' + url[x].toString());
    //   list.add(Container(
    //     color: lightGrey,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: <Widget>[
    //         new Container(
    //           height: 100,
    //           padding: EdgeInsets.all(5),
    //           child: Image.network(url[x], fit: BoxFit.fitHeight,),
    //         ),
    //         //onTap: () => Database().addBook(context, isbn[x])),

    //         new Column(
    //           children: <Widget>[
    //             Text();
    //             Text();
    //           ],
    //         )
    //         new GestureDetector(
    //           child: Icon(
    //             Icons.add_circle,
    //             color: darkGrey,
    //             size: 30,
    //           ),
    //           onTap: () => Database().addBook(context, isbn[x]),
    //         ),
    //       ],
    //     ),
    //   ));
    // }
    
    return ListView(children: list,);
  }
  // Future<Widget> getReadingList(context, value) async {
  //   Book books = await Api().fetchBooks(value);
    
  //   // var screenWidth = MediaQuery.of(context).size.width;
  //   // var screenHeight = MediaQuery.of(context).size.height;

  //   List<Container> list=[];
  //   var isbn;
  //   for(var item in books.items){
  //     if(item.volumeInfo.industryIdentifiers != null &&
  //       item.volumeInfo.imageLinks != null &&
  //       item.volumeInfo.title != null &&
  //       item.volumeInfo.authors != null &&
  //       item.volumeInfo.publishedDate != null){
  //         if(item.volumeInfo.industryIdentifiers.length > 1){
  //           if(item.volumeInfo.industryIdentifiers[0].toJson()['identifier'].toString().length == 13){
  //             list.add(Container(

  //               color: lightGrey,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: <Widget>[
  //                   new Container(
  //                     height: 120,
  //                     width: 100,
  //                     padding: EdgeInsets.only(top: 5, bottom: 5),
  //                     child: Image.network(item.volumeInfo.imageLinks.toJson()['thumbnail'].toString(), fit: BoxFit.fitHeight,),
  //                   ),
  //                   //onTap: () => Database().addBook(context, isbn[x])),

  //                   new Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Text(item.volumeInfo.toJson()['title'].toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
  //                       Text(item.volumeInfo.toJson()['authors'][0].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
  //                       Text("Published " + item.volumeInfo.toJson()['publishedDate'].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
  //                     ],
  //                   ),
  //                   new GestureDetector(
  //                     child: Icon(
  //                       Icons.add_circle,
  //                       color: darkGrey,
  //                       size: 30,
  //                     ),
  //                     onTap: () => Database().addBook(context, item.volumeInfo.industryIdentifiers[0].toJson()['identifier'].toString()),
  //                   ),
  //                 ],
  //               ),
  //             ));            
  //           }
  //           else{
  //             list.add(Container(
                
  //               color: lightGrey,
  //               child: Flexible(
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: <Widget>[
  //                     new Container(
  //                       height: 120,
  //                       width: 100,
  //                       padding: EdgeInsets.only(top: 5, bottom: 5),
  //                       child: Image.network(item.volumeInfo.imageLinks.toJson()['thumbnail'].toString(), fit: BoxFit.fitHeight,),
  //                     ),
  //                     //onTap: () => Database().addBook(context, isbn[x])),

  //                     new Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Container(
  //                           alignment: Alignment.topLeft,
  //                           child:  Text(
  //                             item.volumeInfo.toJson()['title'].toString(),
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w500
  //                             )
  //                           ),


  //                         ),
  //                         Container(
  //                           alignment: Alignment.topLeft,
  //                           child:  Text(
  //                             item.volumeInfo.toJson()['authors'][0].toString(), 
  //                             style: TextStyle(
  //                               fontSize: 10, 
  //                               fontWeight: FontWeight.w400
  //                             )
  //                           ),


  //                         ),
  //                         Container(
  //                           alignment: Alignment.topLeft,
  //                           child: Text(
  //                             "Published " + item.volumeInfo.toJson()['publishedDate'].toString(), 
  //                             style: TextStyle(
  //                               fontSize: 10, 
  //                               fontWeight: FontWeight.w400
  //                             )
  //                           ),

  //                         ),
  //                         // Text(item.volumeInfo.toJson()['title'].toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
  //                         // Text(item.volumeInfo.toJson()['authors'][0].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
  //                         // Text("Published " + item.volumeInfo.toJson()['publishedDate'].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
  //                       ],
  //                     ),
  //                     new GestureDetector(
  //                       child: Icon(
  //                         Icons.add_circle,
  //                         color: darkGrey,
  //                         size: 30,
  //                       ),
  //                       onTap: () => Database().addBook(context, item.volumeInfo.industryIdentifiers[1].toJson()['identifier'].toString()),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ));
  //           }
  //         }

  //       }


  //   }

  //   // for(var x = 0; x < url.length; x++){
  //   //   print('popup: ' + url[x].toString());
  //   //   list.add(Container(
  //   //     color: lightGrey,
  //   //     child: Row(
  //   //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   //       children: <Widget>[
  //   //         new Container(
  //   //           height: 100,
  //   //           padding: EdgeInsets.all(5),
  //   //           child: Image.network(url[x], fit: BoxFit.fitHeight,),
  //   //         ),
  //   //         //onTap: () => Database().addBook(context, isbn[x])),

  //   //         new Column(
  //   //           children: <Widget>[
  //   //             Text();
  //   //             Text();
  //   //           ],
  //   //         )
  //   //         new GestureDetector(
  //   //           child: Icon(
  //   //             Icons.add_circle,
  //   //             color: darkGrey,
  //   //             size: 30,
  //   //           ),
  //   //           onTap: () => Database().addBook(context, isbn[x]),
  //   //         ),
  //   //       ],
  //   //     ),
  //   //   ));
  //   // }
    
  //   return ListView(children: list,);
  // }

  Dialog showSearchList(context, value){
    
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

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
                  Navigator.pop(context);
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
                    return Text("Loading...");//Container(height: 30, width: 30, child:CircularProgressIndicator());
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

  Widget bookWidget(context, collection, isbn){  
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Dialog(  
      backgroundColor: Colors.transparent,
      child: Container(
        height: screenHeight*0.5,
        //width: screenWidth, 
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.25,
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
                  width: screenWidth * 0.3,
                  child: FutureBuilder<StreamBuilder>(
                    future: Database().getBookInfo(collection, isbn),
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
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 50, 
                    width: 80,
                    child: FutureBuilder<StreamBuilder>(
                      future: Database().getAmazonLink(collection, isbn),
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
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 50, 
                    width: 80,
                    child: RaisedButton(
                      onPressed: () => Database().removeBook(context, collection, isbn),
                      padding: EdgeInsets.all(5),
                      child: Text("Remove", style: TextStyle(fontSize: 12, color: darkGrey)),
                    )
                  ),
                ],
              ), 
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