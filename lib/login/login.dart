import 'package:flutter/material.dart';
import 'package:book_app/login/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/login/root_page.dart';


class LoginFunctions{
  void logout(context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;    
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RootPage(auth: new Auth())),
    );

  return await _firebaseAuth.signOut();
          
}
}