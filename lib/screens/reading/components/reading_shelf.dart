import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:flutter/rendering.dart';
import 'package:book_app/models/database.dart';
import 'package:book_app/ui/popup_widget.dart';
import './widgets/read_widget.dart';


class Reading {
  Container getShelf(context){
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: <Widget>[
          new Container(
            height: 50,
            color: darkGrey,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  "Reading",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: lightGrey,
                  ),
                ),
                new GestureDetector(
                  child: Icon(
                    Icons.add_circle,
                    color: lightGrey,
                    size: 30,
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => PopupWidgets().addBook(context, "reading")),
                ),
              ],
            ),
          ),
          new Container(
            height: 170,
            color: darkGrey,
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[  
                GestureDetector(
                  child:SizedBox(
                    height: screenHeight*0.25,
                    width: screenWidth*0.3,
                    child: FutureBuilder<StreamBuilder>(
                      future: Database().getUserReading(),
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
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ReadWidgets().readWidget(context));
                  },
                ),
                Container(
                  child: FutureBuilder<StreamBuilder>(
                    future: Database().getUserProgress(),
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
                ),    
              ],
            )
          )
        ]
      )
    );   
  }
}