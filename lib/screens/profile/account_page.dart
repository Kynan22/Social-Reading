import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/login/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/login/root_page.dart';
import 'package:book_app/login/login.dart';
import 'package:book_app/classes/book.dart';
import 'package:book_app/models/dbSchema.dart';
import 'package:book_app/models/database.dart';





class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>{
  LoginFunctions loginFunctions = new LoginFunctions();
  //final BookFunctions bookFunctions = new BookFunctions();
  
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    IgnorePointer(ignoring: false,);
    @override
    void initState() {
      super.initState();
      Database().getColour().then((result) {
        setState(() {mainColour = result;});
      });
    }
    return Container(
      color: darkGrey,
      child: new ListView(
        padding: EdgeInsets.only(top:screenHeight*0.03, left: screenWidth*0.05, right: screenWidth*0.05),
        children: <Widget>[
          new FutureBuilder<StreamBuilder>(
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
          // new Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     new Container(
          //       //margin: EdgeInsets.only(left: 20),
          //       // decoration: new BoxDecoration(
          //       //   shape: BoxShape.circle,
          //       //   color: blue,

          //       //   image: new DecorationImage(
          //       //     fit: BoxFit.fill,
          //       //     image: new AssetImage("assets/images/sherlock_profile.png"),
          //       //   )
          //       // ),
          //       child: FutureBuilder<StreamBuilder>(
          //         future: bookFunctions.getUserProfile(),
          //         builder: (context, snapshot) {
          //           if (snapshot.hasData) {
          //             return snapshot.data;
          //           } else if (snapshot.hasError) {
          //             return Text("${snapshot.error}");
          //           }
          //           else{
          //             return CircularProgressIndicator();
          //           }
          //         },        
          //       ),
          //     ),
          //     new SizedBox(
          //       width: screenWidth*0.1
          //     ),
          //     new Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         new Text(
          //           "Kynan Brown",
          //           style: TextStyle(
          //             fontSize: 20, 
          //             fontWeight: FontWeight.bold, 
          //             color: lightGrey,
          //           ),
          //         ),
          //         new SizedBox(height:screenHeight*0.01),
          //         new Text(
          //           "Novice",
          //           style: TextStyle(
          //             fontSize: 15, 
          //             fontWeight: FontWeight.bold, 
          //             color: lightGrey,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          //),
          new SizedBox(height: screenHeight*0.03),
          
          new Row(
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
          new SizedBox(height: screenHeight*0.1),
          new Text(
            "Statistics",
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: lightGrey,
            ),
          ),
          new Row(
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
          new Container(
            padding: EdgeInsets.only(top: screenHeight*0.05),
            child: SizedBox(
              height: screenHeight*0.05,
              child: GestureDetector(
                child: RaisedButton(onPressed: null, child: Text("LOGOUT", style: TextStyle(color: lightGrey),),),
                onTap: () {
                  loginFunctions.logout(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


