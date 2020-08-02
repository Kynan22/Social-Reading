import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';

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
    );
  }
  
}

  

  

