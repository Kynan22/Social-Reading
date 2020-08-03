import 'package:book_app/models/database/shelf_db.dart';
import 'package:book_app/screens/reading/components/widgets/search_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:book_app/models/global.dart';
import 'package:book_app/models/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReadWidgets {
  Future<StreamBuilder> fetchRead() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    
    //Firestore.instance.collection("users").document(firebaseUser.uid).collection('reading').getDocuments().then((value) {
      
      //value.documents[0].data.
      

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
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.network(
                      ds.data['thumbnail'],
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                //   onTap: () => showDialog(
                //     context: context,
                //     builder: (BuildContext context) => PopupWidgets().bookWidget(context, "reading", ds.documentID),
                // ),
              )
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
                //   onTap: () => showDialog(
                //     context: context,
                //     builder: (BuildContext context) => PopupWidgets().bookWidget(context, "reading", ds.documentID),
                //   ),
              )
            );
          }
        }
      },
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
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.25,
                  child: FutureBuilder<StreamBuilder>(
                    future: fetchRead(),
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
                // Container(
                //   width: screenWidth * 0.3,
                //   child: FutureBuilder<StreamBuilder>(
                //     future: Database().getBookInfo(collection, isbn),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) {
                //         return snapshot.data;
                //       } else if (snapshot.hasError) {
                //         return Text("${snapshot.error}");
                //       }
                //       else{
                //         return CircularProgressIndicator();
                //       }
                //     }, 
                //   )
                // ),
              ],
            ),
            Container(
              height: 80,
              child: null,
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: <Widget>[
              //     Container(
              //       padding: EdgeInsets.all(10),
              //       height: 50, 
              //       width: 80,
              //       child: FutureBuilder<StreamBuilder>(
              //         future: Database().getAmazonLink(collection, isbn),
              //         builder: (context, snapshot) {
              //           if (snapshot.hasData) {
              //             return snapshot.data;
              //           } else if (snapshot.hasError) {
              //             return Text("${snapshot.error}");
              //           }
              //           else{
              //             return CircularProgressIndicator();
              //           }
              //         },        
              //       )
              //     ),
              //     Container(
              //       padding: EdgeInsets.all(10),
              //       height: 50, 
              //       width: 80,
              //       child: RaisedButton(
              //         onPressed: () => Database().removeBook(context, collection, isbn),
              //         padding: EdgeInsets.all(5),
              //         child: Text("Remove", style: TextStyle(fontSize: 12, color: darkGrey)),
              //       )
              //     ),
              //   ],
              // ), 
            ), 
          ],
        )
      ),
    );
  }


}