import 'package:flutter/material.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/ui/popup_widget.dart';
import '../book_page.dart';


class AddShelf {
  addShelf(context){
    return Container(
      height: 80,
      child: GestureDetector(
        child: Icon(Icons.add_box, size: 40, color: lightGrey,),
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context){
            return PopupWidgets().addShelfWidget(context);
          }
        ),
      ),
    ); 
  }
}