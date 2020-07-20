import 'package:book_app/models/database.dart';
import 'package:book_app/ui/widgets/social_widgets.dart';
import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';


class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>{
  
  @override
  Widget build(BuildContext context) {
    IgnorePointer(ignoring: false,);
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      
      color: darkGrey,
      child: new Column(
        children: <Widget>[
          Container(
            height: deviceHeight*0.1,
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Add Friend"),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => SocialWidgets().addFriend(context),
                  ),
                ),
                RaisedButton(
                  child: Text("Open Chat"),
                  onPressed: () => Database().chatFriend(),
                  
                ),
              ],
            )
          ),
          Container(
            height: deviceHeight*0.764,
            child: ListView(
              padding: EdgeInsets.only(left: 15, right: 15),
              children: getList(),
            ),
          ),
        ],
      )
    );
  }

  List<Widget> getList() {
    List<Container> list=[];
    for(int x=0;x<10;x++){
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