import 'package:book_app/models/database/shelf_db.dart';
import 'package:book_app/screens/reading/components/widgets/search_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:book_app/models/global.dart';
import 'package:book_app/models/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ShelfWidgets {
  Future<dynamic> fetchShelfBooks(shelf) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    
    Firestore.instance.collection("users").document(firebaseUser.uid).collection(shelf).getDocuments().then((value) {
      List<Map> shelfList;
      for(var doc in value.documents){
        shelfList.add(doc.data);
      }
      return shelfList;
    });

  }

  Future<Widget> getShelfList(context, shelf) async{

    var firebaseUser = await FirebaseAuth.instance.currentUser();
    List<Container> list=[];

    Firestore.instance.collection("users").document(firebaseUser.uid).collection(shelf).getDocuments().then((value) {
      //List<Map> shelfList;
      for(var doc in value.documents){
        //shelfList.add(doc.data);
        list.add(Container(
          color: lightGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Container(
                height: 120,
                width: 100,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Image.network(doc.data['thumbnail'], fit: BoxFit.fitHeight,),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  Text(doc.data['title'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  Text(doc.data['authors'][0].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                  Text("Published " + doc.data['published'].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                ],
              ),
              new GestureDetector(
                child: Icon(
                  Icons.remove_circle,
                  color: darkGrey,
                  size: 30,
                ),
                onTap: () => Database().removeBook(context, shelf, doc.documentID, true),
              ),
            ],
          ),
        ));


      }
      
    });
    return ListView(children:list,);

  }

  Dialog showShelfList(context, shelf){
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
                  labelText: "Add Book",
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
                  builder: (BuildContext context) => SearchWidgets().showSearchList(context,value, shelf));
                }
              ),
            ),
            Container(
              height: 550,
              child: FutureBuilder<Widget>(
                future: getShelfList(context,shelf),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  else{
                    return Text("Loading...");
                  }
                },        
              ),
            ),
            Container (
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  "Delete Shelf"
                ),
                onPressed: () {    
                  ShelfDB().deleteShelf(context, shelf);
                }
              ),
            )
          ],
        ),
      ),
    );
  }
  
  shelfOpen(context, shelf) async{
    return ShelfDB().openShelf(shelf);
  }
}