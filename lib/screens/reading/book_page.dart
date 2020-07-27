import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:flutter/rendering.dart';

import 'components/shelves.dart';


class BookPage extends StatefulWidget {
  // BookPage({Key key, this.auth, this.userId, this.logoutCallback})
  //     : super(key: key);

  // final BaseAuth auth;
  // final VoidCallback logoutCallback;
  // final String userId;


  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage>{
  // final firestoreInstance = Firestore.instance;
  // final FirebaseDatabase _database = FirebaseDatabase.instance;
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final PopupWidgets popupWidget = new PopupWidgets();
  
  // //Future userUid;
  // Future<Book> futureBook;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    IgnorePointer(ignoring: false,);
    return Container(
      color: darkGrey,
      child: FutureBuilder<dynamic>(
        future: Shelves().getList(context),
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
      // child: ListView(
      //   padding: EdgeInsets.only(top:30),
      //   //children: null,
      //   children: Shelves().getList(context),
      // )
    );
  }
  
}

  

  

