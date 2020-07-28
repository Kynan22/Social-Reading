import 'package:book_app/screens/reading/book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:book_app/ui/popup_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:book_app/classes/book.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/models/api.dart';


class ShelfDB {

  addShelf(context, shelfName) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    //final CollectionReference dbRef = Firestore.instance.collection('users');

    await Firestore.instance.collection('users').document(firebaseUser.uid).updateData({'shelves': FieldValue.arrayUnion([shelfName])});
    //Navigator.pop(context);
  }

  getShelves(context) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var shelves = Firestore.instance.collection('users').document(firebaseUser.uid).get().then((querySnapshot) {
      return querySnapshot.data['shelves'];
    });
    
    return shelves;

  }



}