import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';

class Challenge {
  
  getChallenge(context){
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                "Reading Challenge",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: lightGrey,
                ),
              ),
              new SizedBox(height:screenHeight*0.01),
              new Text(
                "25 Books by 2021",
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold, 
                  color: lightGrey,
                ),
              ),
            ],
          ),
          new SizedBox(width: screenWidth*0.1),
          new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              new Container(
                height: screenWidth*0.3,
                width: screenWidth*0.3,
                child: CircularProgressIndicator(  
                  strokeWidth: 15,
                  value: 0.32,
                  backgroundColor: lightGrey,
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColour),

                ),
              ),
              new Text(
                "8/25",
                style: TextStyle(
                  fontSize: 20, 
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