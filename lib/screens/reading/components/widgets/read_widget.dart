import 'package:book_app/models/database/shelf_db.dart';
import 'package:book_app/screens/reading/components/widgets/search_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:book_app/models/global.dart';
import 'package:book_app/models/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/ui/popup_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReadWidgets {
  Future<StreamBuilder> fetchReadImage() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection("reading").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            try{
              DocumentSnapshot ds = snapshot.data.documents[0];
              return new Container(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Image.network(
                    ds.data['thumbnail'],
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              );
            }
          on RangeError{
            return new Container(
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Select a book to begin reading!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.w900, 
                          color: mainColour,
                        ),
                      ),
                    ),
                  ),
                  // onTap: () => showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) => PopupWidgets().bookWidget(context, "reading", ds.documentID),
                  // ),
              )
            );
          }
        }
      },
    );

  }
  Future<StreamBuilder> fetchReadProgress() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
  
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection("reading").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            try{
              DocumentSnapshot ds = snapshot.data.documents[0];
              return new Container(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                height: 18,
                width: 170,
                child:  LinearProgressIndicator(
                  value: (ds['progress']).toDouble(),
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColour),//getUserColour()),
                ),
                //child: Text((ds['progress']/100).toString()),
              );
            }
          on RangeError{
            return new Container(

            );
          }
        }
        
      },
    );

  }

  Future<StreamBuilder> fetchReadDetails() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection("reading").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            try{
              DocumentSnapshot ds = snapshot.data.documents[0];
              return new Container(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                height: 18,
                width: 130,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      child:TextFormField(
                        initialValue: (ds['progress']*ds['pageCount']).toInt().toString(),
                        
                        onFieldSubmitted: (String value) async{
                          Navigator.pop(context);
                          showDialog(
                          context: context,
                          builder: (BuildContext context) => updateReadProgress(value));
                        }
                      ),
                    ),
                    Container(
                      width: 30,
                      child:TextFormField(
                        initialValue: " / ",
                      
                      
                      ),
                    ),
                    
                    Container(
                      width: 30,
                      child:TextFormField(
                        initialValue: ds['pageCount'].toInt().toString(),
                      
                      
                      ),
                    ),
                  ],
                )
               
              );
            }
          on RangeError{
            return new Container(
                
            );
          }
        }
        
      },
    );

  }

  updateReadProgress(value) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    final CollectionReference dbRef = Firestore.instance.collection('users');

    await dbRef.document(firebaseUser.uid).setData(
      {
        'progress': value
      }
    );
  }

  Widget readWidget(context){  
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
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.25,
                  child: FutureBuilder<StreamBuilder>(
                    future: fetchReadImage(),
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
                  width: screenWidth * 0.4,
                  child: Column(
                    children: <Widget>[
                      Container(
                        
                        child: FutureBuilder<StreamBuilder>(
                          future: fetchReadProgress(),
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
                        height: 30,
                        child: FutureBuilder<StreamBuilder>(
                          future: fetchReadDetails(),
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
                      )
                    ],
                  ),
                )
                
              ],
            ),
            Container(
              height: 80,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 50, 
                    width: 80,
                    // child: FutureBuilder<StreamBuilder>(
                    //   future: Database().getAmazonLink(collection, isbn),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       return snapshot.data;
                    //     } else if (snapshot.hasError) {
                    //       return Text("${snapshot.error}");
                    //     }
                    //     else{
                    //       return CircularProgressIndicator();
                    //     }
                    //   },        
                    // )
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 50, 
                    width: 80,
                    child: RaisedButton(
                      //onPressed: () => Database().removeBook(context, "reading", isbn, true),
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