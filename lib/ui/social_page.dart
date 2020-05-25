import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/models/dbSchema.dart';

import 'package:book_app/login/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/login/root_page.dart';


class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>{
  
  @override
  Widget build(BuildContext context) {
    IgnorePointer(ignoring: false,);
    
    return Container(
      
      color: darkGrey,
      child: new ListView(
        padding: EdgeInsets.only(top:20, left: 15, right: 15),
        children: getList(),
      ),
    );
  }

  List<Widget> getList() {
    List<Container> list=[];
    for(int x=0;x<20;x++){
      list.add(Container(
        height: 160,
        padding: EdgeInsets.all(5),
        child: getContent(),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          // boxShadow: [
          //   new BoxShadow(
          //     color: Colors.black,
          //     offset: new Offset (3.0, 4.0),
          //   )
          // ],
        ),

        
      ));
      list.add(Container(height:20));
    }
    
    
    

    return list;
  }
}

Column getContent(){
  return Column(
    children: <Widget>[
        new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            height:40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainColour,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage("assets/images/sherlock_profile.png"),
              )
            ),
          ),
          new SizedBox(width: 20),
          new Container(
            alignment: Alignment.center,
            height: 40,
            child: Text(
              "Kynan Made Progress",
              style: TextStyle(
                fontSize: 15, 
                color: darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      new Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new SizedBox(width:80),
          new Expanded(
            child: SizedBox(
              height: 105,
              child: Image.asset("assets/images/outliers.jpg",
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerLeft,
              ),
            ),
          ),
          new Expanded(
            child: SizedBox(
              height: 15,
              child: LinearProgressIndicator(
                value: 0.4,
                backgroundColor: darkGrey,
                valueColor: new AlwaysStoppedAnimation(purple),
              ),
            ),
          ),
          new SizedBox(width:80),
        ],
      ),
    ],
  );
}