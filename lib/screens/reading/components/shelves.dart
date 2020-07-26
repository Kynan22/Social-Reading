import 'package:flutter/material.dart';
import 'reading_shelf.dart';
import 'default_shelf.dart';
import '../../../models/database.dart';

class Shelves {
  List<Widget> getList(context) {
    //var shelves = Database().getShelves(context);
    List<Container> list=[];
    // list.add(Container(
    //   child:Text(
    //     shelves.toString()
    //   ),
    // ));
    list.add(Reading().getShelf(context));
    list.add(Default().getShelf("Up Next", context));
    list.add(Default().getShelf("Completed", context));

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
    

    return list;
  }  
}