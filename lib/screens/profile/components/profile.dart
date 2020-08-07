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