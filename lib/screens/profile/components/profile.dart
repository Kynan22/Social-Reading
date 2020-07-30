import 'package:book_app/models/database/shelf_db.dart';
import 'package:book_app/screens/reading/components/add_shelf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/database.dart';

class Profile {

  getProfile(context){
    return new Container(
      child: FutureBuilder<StreamBuilder>(
        future: Database().getUserProfile(),
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
    );
  }
}