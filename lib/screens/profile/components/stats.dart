import 'package:book_app/models/database/shelf_db.dart';
import 'package:book_app/screens/reading/components/add_shelf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';

class Stats {

  getStatsTitle(context){
    return new Container(
      child: Text(
        "Statistics",
        style: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold, 
          color: lightGrey,
        ),
      ),
    );
  }
  getStats(context){
    return new Container(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              
              new SizedBox(height:10),
              new Text(
                "Total Books Completed:         8",
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold, 
                  color: lightGrey,
                ),
              ),
              new SizedBox(height:10),
              new Text(
                "Total Books Added:         35",
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold, 
                  color: lightGrey,
                ),
              ),
              new SizedBox(height:10),
              new Text(
                "Post Interactions per Month:         82",
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold, 
                  color: lightGrey,
                ),
              ),
              new SizedBox(height:10),
              new Text(
                "Average Books Read per Month:        2",
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold, 
                  color: lightGrey,
                ),
              ),
              new SizedBox(height:10),
              new Text(
                "Average Pages Read per Month:        739",
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold, 
                  color: lightGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}