import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/login/login.dart';
import 'package:book_app/models/database.dart';

import 'components/profile.dart';
import 'components/challenge.dart';
import 'components/stats.dart';

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

    List<Container> list = [];
    list.add(Profile().getProfile(context));
    list.add(new Container(child: SizedBox(height: screenHeight*0.05)));
    list.add(Challenge().getChallenge(context));
    list.add(new Container(child: SizedBox(height: screenHeight*0.05),));
    list.add(Stats().getStats(context));
    list.add(new Container(
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
    ),);
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
        children: list,
      ),
    );
  }
}


