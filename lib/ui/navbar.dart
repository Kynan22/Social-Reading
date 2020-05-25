import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/ui/book_page.dart';
import 'package:book_app/ui/account_page.dart';
import 'package:book_app/ui/social_page.dart';
import '../models/dbSchema.dart';
import '../models/global.dart';
import 'account_page.dart';
import 'book_page.dart';
import 'social_page.dart';

class Navbar{
  MaterialApp navbar(){
    return new MaterialApp(
      color: darkGrey,
      home: SafeArea(
        top: false,
        child: DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: Scaffold(
            backgroundColor: mainColour,
            appBar: AppBar(
              backgroundColor: mainColour,
              elevation: 0,
              title: TabBar(
                      //  VERSION 1
                // labelColor: lightGrey,
                // unselectedLabelColor: darkGrey,
                // indicatorSize: TabBarIndicatorSize.label,
                // indicator: BoxDecoration(
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(10)),
                //     color: darkGrey
                // ),
                  labelColor: lightGrey,
                  unselectedLabelColor: darkGrey,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: darkGrey),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "SOCIAL",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "BOOKS",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),  
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "PROFILE",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
            body: TabBarView(children: [
              SocialPage(),
              BookPage(),
              AccountPage(),
            ]),
          )
        )
      )
    );
  }
}