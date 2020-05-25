import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/ui/book_page.dart';
import 'package:book_app/ui/account_page.dart';
import 'package:book_app/ui/social_page.dart';

import '../models/global.dart';
import '../models/global.dart';
import '../models/global.dart';

class Navbar{

  MaterialApp navbar(){
    return new MaterialApp(
      color: darkGrey,
      home: SafeArea(
        child: DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: new Scaffold(
            backgroundColor: blue,
            body: Stack(
              children: <Widget> [
                TabBarView(
                  children: [
                    SocialPage(),
                    BookPage(),
                    AccountPage(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left:50),
                  height: 20,
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                    ),
                  ),
                ),
              ],
            ),  
            appBar: AppBar(
              backgroundColor: blue,
              elevation: 0,
              title: new TabBar(
                labelColor: lightGrey,
                unselectedLabelColor: darkGrey,
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: SizedBox(
                      height: 20,
                      child: Tab(icon: new Icon(
                        Icons.people,
                        size: 40,
                      ),),
                      
                    )
                    
                  ),
                  Tab(
                    child: Container(
                      
                      height: 20,
                      child: Tab(icon: new Icon(
                        Icons.book,
                        size: 35,
                      ),),
                    )
                  ),
                  Tab(
                    child: SizedBox(
                      height: 20,
                      child: Tab(icon: new Icon(
                        Icons.perm_identity,
                        size: 40,
                      ),),
                    )
                  ),
                ],      
              ),
            ),
          ),
        ),
      ), 
    );
  }
}