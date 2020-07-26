import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/screens/reading/book_page.dart';
import 'package:book_app/screens/profile/account_page.dart';
import 'package:book_app/screens/social/social_page.dart';
import '../models/dbSchema.dart';
import '../models/global.dart';
import '../screens/profile/account_page.dart';
import '../screens/reading/book_page.dart';
import '../screens/social/social_page.dart';

class Navbar{
  MaterialApp navbar(){
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.blueAccent,
          items: <Widget>[
            Icon(Icons.add, size: 30),
            Icon(Icons.list, size: 30),
            Icon(Icons.compare_arrows, size: 30),
          ],
          onTap: (index) {
            //Handle button tap

          },
        ),
        
      ),
      
    );
  
    
  }
}