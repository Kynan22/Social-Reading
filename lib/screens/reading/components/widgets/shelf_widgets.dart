import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:book_app/classes/book.dart';
import 'dart:async' show Future;
import 'package:book_app/models/global.dart';
import 'package:book_app/models/database.dart';
import 'package:book_app/models/api.dart';

class ShelfWidgets {
  Future<Widget> shelf(context, shelf) async {
    Book books = await Api().fetchBooks(value);

    List<Container> shelfList=[];

    for(var item in books.items){
      shelfList.add(Container(
        color: lightGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              height: 120,
              width: 100,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Image.network(item.volumeInfo.imageLinks.toJson()['thumbnail'].toString(), fit: BoxFit.fitHeight,),
            ),
            //onTap: () => Database().addBook(context, isbn[x])),

            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.volumeInfo.toJson()['title'].toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                Text(item.volumeInfo.toJson()['authors'][0].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                Text("Published " + item.volumeInfo.toJson()['publishedDate'].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
              ],
            ),
            new GestureDetector(
              child: Icon(
                Icons.add_circle,
                color: darkGrey,
                size: 30,
              ),
              onTap: () => Database().checkBook(context, item.volumeInfo.industryIdentifiers[0].toJson()['identifier'].toString(), shelf),
            ),
          ],
        ),
      ));
    }
    else{
      list.add(Container(
        
        color: lightGrey,
        child: Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 120,
                width: 100,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Image.network(item.volumeInfo.imageLinks.toJson()['thumbnail'].toString(), fit: BoxFit.fitHeight,),
              ),
              //onTap: () => Database().addBook(context, isbn[x])),

              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   alignment: Alignment.topLeft,
                  //   child:  Text(
                  //     item.volumeInfo.toJson()['title'].toString(),
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w500
                  //     )
                  //   ),


                  // ),
                  // Container(
                  //   alignment: Alignment.topLeft,
                  //   child:  Text(
                  //     item.volumeInfo.toJson()['authors'][0].toString(), 
                  //     style: TextStyle(
                  //       fontSize: 10, 
                  //       fontWeight: FontWeight.w400
                  //     )
                  //   ),


                  // ),
                  // Container(
                  //   alignment: Alignment.topLeft,
                  //   child: Text(
                  //     "Published " + item.volumeInfo.toJson()['publishedDate'].toString(), 
                  //     style: TextStyle(
                  //       fontSize: 10, 
                  //       fontWeight: FontWeight.w400
                  //     )
                  //   ),

                  // ),
                  Text(item.volumeInfo.toJson()['title'].toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  Text(item.volumeInfo.toJson()['authors'][0].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                  Text("Published " + item.volumeInfo.toJson()['publishedDate'].toString(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                ],
              ),
              new GestureDetector(
                child: Icon(
                  Icons.add_circle,
                  color: darkGrey,
                  size: 30,
                ),
                onTap: () => Database().checkBook(context, item.volumeInfo.industryIdentifiers[1].toJson()['identifier'].toString(), shelf),
              ),
            ],
          ),
        ),
      ));
    }
  }
}