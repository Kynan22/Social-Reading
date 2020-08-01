import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:book_app/ui/popup_widget.dart';
import 'dart:async' show Future;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ShelfDB {

  // Adds shelf name to shelves array in user document
  addShelf(context, shelfName) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    await Firestore.instance.collection('users').document(firebaseUser.uid).updateData({'shelves': FieldValue.arrayUnion([shelfName])});
  }

  // Gets shelves array from user document and returns it
  getShelfList(context) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var shelves = Firestore.instance.collection('users').document(firebaseUser.uid).get().then((querySnapshot) {
      return querySnapshot.data['shelves'];
    });

    return shelves;
  }
  
  Future<StreamBuilder> displayBooks(shelf) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection(shelf).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                // for (var key in document.data)
                return new Container(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Image.network(
                        document.data['thumbnail'],
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => PopupWidgets().bookWidget(context, shelf,document.documentID)),
                  ),
                  
                );
              }).toList(),
            );
        }
      },
    );
  }

  openShelf(shelf) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection(shelf).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new Container(
              child: ListView(
              scrollDirection: Axis.vertical,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                // for (var key in document.data)
                return new Container(
                  padding: EdgeInsets.all(10),
                  child: Image.network(
                    document.data['thumbnail'],
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerLeft,
                  ),
                );
              }).toList(),
            )
          );
        }
      },
    );
  }
}