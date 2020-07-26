import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:flutter/rendering.dart';
import 'package:book_app/models/database.dart';
import 'package:book_app/ui/popup_widget.dart';


class Default {
  Container getShelf(name, context){
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: <Widget>[
          new Container(
            height: 50,
            color: darkGrey,
            padding: EdgeInsets.only(left: 30, right: 30, top: 20,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  name,
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
                    builder: (BuildContext context) => PopupWidgets().addBook(context, "next")),
                ),
              ],
            ),
          ),
          new Container(
            height: 150,
            child: FutureBuilder<StreamBuilder>(
              future: Database().getUserBooks("next"),
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
          )
        ]
      )
    );   
  }
}