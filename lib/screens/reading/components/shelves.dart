import 'package:book_app/models/database/shelf_db.dart';
import 'package:book_app/screens/reading/components/add_shelf.dart';
import 'package:flutter/material.dart';
import 'reading_shelf.dart';
import 'default_shelf.dart';
import 'add_shelf.dart';

class Shelves {

  // Retrieves the shelves for book_page
  getList(context) async{

    List<Container> list=[];

    return FutureBuilder<dynamic>(
      future: ShelfDB().getShelfList(context),
      builder: ( context, snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            list.add(Reading().getShelf(context));
            for(var shelf in snapshot.data){
              list.add(Default().getShelf(shelf, context));
            }
            list.add(AddShelf().addShelf(context));

            return ListView(
              padding: EdgeInsets.only(top:30),
              children: list,
            );
        }
      }
    );
  }  
}