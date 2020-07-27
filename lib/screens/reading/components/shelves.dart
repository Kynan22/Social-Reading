import 'package:book_app/screens/reading/components/add_shelf.dart';
import 'package:flutter/material.dart';
import 'reading_shelf.dart';
import 'default_shelf.dart';
import 'add_shelf.dart';
import '../../../models/database.dart';

class Shelves {
  getList(context) async{
    //var shelves = await Database().getShelves(context);
    List<Container> list=[];

    return FutureBuilder<dynamic>(
      future: Database().getShelves(context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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


    // await Database().getShelves(context, list);
    // // await for(var shelf in ){
    // //   list.add(Default().getShelf(shelf, context));
    // // }
    // list.add(Reading().getShelf(context));
    // list.add(Default().getShelf("Up Next", context));
    // list.add(Default().getShelf("Completed", context));

    // for(var shelf in shelves){
    //   list.add(Default().getShelf(shelf, context));
    // }
    // for(var shelf in shelves){
    // list.add(Container(
    //   height: 150,
    //   color: Colors.red,
    //     child: FutureBuilder(
    //       future: Database().getShelfList(context),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return snapshot.data;
    //         } else if (snapshot.hasError) {
    //           return Text("${snapshot.error}");
    //         }
    //         else{
    //           return CircularProgressIndicator();
    //         }
    //       },        
    //     ),
    // ));
    //}
    
    // list.add(Container(
    //   height: 80,
    //   child: GestureDetector(
    //     child: Icon(Icons.add_box, size: 40, color: lightGrey,),
    //     onTap: () => showDialog(
    //       context: context,
    //       builder: (BuildContext context) => PopupWidgets().addShelfWidget(context, list),
    //     ),
    //   ),
    // ));
    

    // return ListView(
    //   padding: EdgeInsets.only(top:30),
    //   children: list,
    // );
  }  
}