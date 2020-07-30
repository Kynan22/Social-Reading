import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:book_app/classes/book.dart';
import 'dart:async' show Future;
import 'package:book_app/models/global.dart';
import 'package:book_app/models/database.dart';
import 'package:book_app/models/api.dart';

class SearchWidgets {

  Future<Widget> getSearchList(context, value, shelf) async {
    Book books = await Api().fetchBooks(value);

    List<Container> list=[];
    for(var item in books.items){
      if(item.volumeInfo.industryIdentifiers != null &&
      item.volumeInfo.imageLinks != null &&
      item.volumeInfo.title != null &&
      item.volumeInfo.authors != null &&
      item.volumeInfo.publishedDate != null){
        if(item.volumeInfo.industryIdentifiers.length > 1){
          if(item.volumeInfo.industryIdentifiers[0].toJson()['identifier'].toString().length == 13){
            list.add(Container(
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
    }
    return ListView(children: list,);
  }
  
  Dialog showSearchList(context, value, shelf){
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: new BoxDecoration(color: lightGrey, borderRadius:new BorderRadius.circular(25.0),),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                decoration: new InputDecoration(
                  labelText: "Add Book",
                  //fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  
                ),
                validator: (value) {
                  if(value.length==0) {
                    return "Title cannot be empty";
                  }else{
                    return null;
                  }
                },
                onFieldSubmitted: (String value) async{
                  Navigator.pop(context);
                  showDialog(
                  context: context,
                  builder: (BuildContext context) => showSearchList(context, value, shelf));
                }
              ),
            ),
            Container(
              height: 600,
              child: FutureBuilder<Widget>(
                future: getSearchList(context,value,shelf),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  else{
                    return Text("Loading...");//Container(height: 30, width: 30, child:CircularProgressIndicator());
                  }
                },        
              ),
            ),
          ],
        ),
      ),
    );
  }


}