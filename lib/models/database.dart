import 'package:book_app/screens/reading/book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:book_app/ui/popup_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:book_app/classes/book.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_app/models/global.dart';
import 'package:book_app/models/api.dart';

import '../screens/reading/components/default_shelf.dart';


class Database{

  getColour() async{
    var userColour = await getUserColour();
    return userColour;
  }
  checkBook(context,isbn,shelf) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    final CollectionReference dbRef = Firestore.instance.collection('users');
    if(shelf == "reading"){
      try{
       
        var reading = await dbRef.document(firebaseUser.uid).collection(shelf).getDocuments();
        var book = reading.documents[0];
        Navigator.pop(context);
        
        showDialog(
          context: context,
          builder: (BuildContext context) => PopupWidgets().readingFull(context));
      }
      on RangeError{
        addBook(context, isbn, shelf);
      }
      
    }
    else{
      addBook(context, isbn, shelf);
    }
  }
  addBook(context,isbn,shelf) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    final CollectionReference dbRef = Firestore.instance.collection('users');

    var json = await Api().fetchBook(isbn);
    print(json.toString());

    var book = Book.fromJson(json);
    var ii = book.items[0].volumeInfo.industryIdentifiers[0].toJson()['identifier'];
    var identifier;
    var isbn10;
    // var identifier = book.items[0].volumeInfo.industryIdentifiers[1].toJson()['identifier'];
    var thumbnail = book.items[0].volumeInfo.imageLinks.toJson()['thumbnail'];
    var title = book.items[0].volumeInfo.toJson()['title'];
    var authors = book.items[0].volumeInfo.toJson()['authors'];
    var published = book.items[0].volumeInfo.toJson()['publishedDate'];
    var pageCount = book.items[0].volumeInfo.toJson()['pageCount'];
    // var isbn10 = book.items[0].volumeInfo.industryIdentifiers[0].toJson()['identifier'];
    if(ii.toString().length == 13){
      identifier = book.items[0].volumeInfo.industryIdentifiers[0].toJson()['identifier'];
      isbn10 = book.items[0].volumeInfo.industryIdentifiers[1].toJson()['identifier'];
    }
    else{
      identifier = book.items[0].volumeInfo.industryIdentifiers[1].toJson()['identifier'];
      isbn10 = book.items[0].volumeInfo.industryIdentifiers[0].toJson()['identifier'];
    }
    // await dbRef.document(firebaseUser.uid).setData(
    //   {
    //     'colour' : colour,
    //     'handle' : handle,
    //     'image' : image,
    //     'username' : username,
    //   }
    // );
    
    await dbRef.document(firebaseUser.uid).collection(shelf).document(identifier.toString()).setData(
      {
        'thumbnail' : thumbnail,
        'isbn10' : isbn10,
        'title' : title,
        'authors' : authors,
        'published' : published,
        'progress' : 0,
        'pageCount' : pageCount

      }
    ); 
    Navigator.pop(context);
  }

  

  addUser(userid, colour, handle, image, username) async{
    //var firebaseUser = userid;
    final CollectionReference dbRef = Firestore.instance.collection('users');

    await dbRef.document(userid).setData(
      {
        'colour' : colour,
        'handle' : handle,
        'image' : image,
        'username' : username,
      }
    );
    // final databaseReference = Firestore.instance;
  }
  addFriend(id) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    final CollectionReference dbRef = Firestore.instance.collection('users').document(firebaseUser.uid).collection("friends");

    await dbRef.document(id).setData({});

  }
  chatFriend() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    final CollectionReference dbRef = Firestore.instance.collection('users');

  }

  removeBook(context, shelf, isbn, pop) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    final CollectionReference dbRef = Firestore.instance.collection('users').document(firebaseUser.uid).collection(shelf);
    if(pop){Navigator.pop(context);}
    await dbRef.document(isbn).delete();
    
  }



  Future<StreamBuilder> getUserBook(collection, isbn) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection(collection).document(isbn).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new Image.network(
              snapshot.data['thumbnail'],
              fit: BoxFit.fitHeight,
            );
          
        }
      },
    );
  }
  Future<StreamBuilder> getBookInfo(collection, isbn) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection(collection).document(isbn).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new Container(
              //width: screenWidth * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(snapshot.data['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),),
                    //padding: EdgeInsets.only(top: 65),
                  ),
                  Container(
                    child: Text(snapshot.data['authors'][0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                    padding: EdgeInsets.only(top: 5, bottom: 5),

                  ), 
                  Container(
                    child: Text("Published "+snapshot.data['published'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                    padding: EdgeInsets.only(top: 5, bottom: 10),

                  ),
                ],
              ),
            );
        }
      },
    );
  }

  Future<StreamBuilder> getAmazonLink(collection, isbn) async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection(collection).document(isbn).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            //DocumentSnapshot ds = snapshot.data.documents[0];
            return new Container(
              //child: GestureDetector(
                child: RaisedButton(
                  
                  padding: EdgeInsets.all(5),
                  child: Text("Buy Now", style: TextStyle(fontSize: 12, color: darkGrey)),
                  onPressed: () => _launchURL(snapshot.data['isbn10']),
                ),
                // onTap: (
                //   () => _launchURL(ds['isbn10'])
                // )
                //alignment: Alignment.centerLeft,
              //),
            );
        }
      },
    );
  }
  _launchURL(isbn) async {
    var url = 'https://www.amazon.com.au/dp/' + isbn;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<StreamBuilder> getUserProfile() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    //var colour = lightGrey;
    return StreamBuilder(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            //DocumentSnapshot ds = snapshot.data.documents[firebaseUser.uid];
            // switch(snapshot.data["colour"]){
            //   case 0:
            //     colours.setColour();
            //     break;
            //   case 1:
            //     colours.setColour(purple);
            //     break;
            //   case 2:
            //     colours.setColour(pink);
            //     break;
            //   default:
            //     colours.setColour(lightGrey);
            //     break;
            // }
            var screenWidth = MediaQuery.of(context).size.width;
            var screenHeight = MediaQuery.of(context).size.height;
            final PopupWidgets popupWidget = new PopupWidgets();
            
            return new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: 150.0,
                    height: 150.0,
                    margin: EdgeInsets.only(left: 20),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainColour,//getUserColour(),
                    ),
                    child: Image.asset(
                      "assets/images/"+snapshot.data["image"],
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => popupWidget.showWidget(context))
                //popupWidget.showWidget(),
                ),
                new SizedBox(
                width: screenWidth*0.1
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      snapshot.data["username"],
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                        color: lightGrey,
                      ),
                    ),
                    new SizedBox(height:screenHeight*0.01),
                    new Text(
                      snapshot.data["handle"],
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold, 
                        color: lightGrey,
                      ),
                    ),
                  ],
                ),
              ],
            );
        }
      },
    );
  }

  Future<Color> getUserColour() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    
    return await Firestore.instance.collection("users").document(firebaseUser.uid).get().then((value)
      {
        switch(value.data["colour"]){
          case 0:
            return blue;
            break;
          case 1:
            return purple;
            break;
          case 2:
            return pink;
            break;
          default:
            return lightGrey;
            break;
        }
      }
    );
  }
  
  Future<StreamBuilder> getProgress() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection("reading").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            DocumentSnapshot ds = snapshot.data.documents[0];
            return new Container(
              height: 18,
              width: 180,
              // child:  LinearProgressIndicator(
              //   value: (ds['progress']).toDouble(),
              //   backgroundColor: lightGrey,
              //   valueColor: new AlwaysStoppedAnimation<Color>(mainColour),//getUserColour()),
              // ),
              child: Text(
                (ds['progress']*ds['pages']).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), '')+"/"+ds['pages'].toString()
              ),
            ); 
        }
      },
    );
  }
  Future<StreamBuilder> getUserSearchBooks() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection("reading").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            DocumentSnapshot ds = snapshot.data.documents[0];
            return new Container(
              height: 18,
              width: 180,
              // child:  LinearProgressIndicator(
              //   value: (ds['progress']).toDouble(),
              //   backgroundColor: lightGrey,
              //   valueColor: new AlwaysStoppedAnimation<Color>(mainColour),//getUserColour()),
              // ),
              child: Text(
                (ds['progress']*ds['pages']).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), '')+"/"+ds['pages'].toString()
              ),
            ); 
        }
      },
    );
  }
  Future<StreamBuilder> getFriendSearchList() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection("reading").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            DocumentSnapshot ds = snapshot.data.documents[0];
            return new Container(
              height: 18,
              width: 180,
              // child:  LinearProgressIndicator(
              //   value: (ds['progress']).toDouble(),
              //   backgroundColor: lightGrey,
              //   valueColor: new AlwaysStoppedAnimation<Color>(mainColour),//getUserColour()),
              // ),
              child: Text(
                (ds['progress']*ds['pages']).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), '')+"/"+ds['pages'].toString()
              ),
            ); 
        }
      },
    );
  }
  // StreamBuilder(
  //     stream: Firestore.instance.collection("users").document(firebaseUser.uid).collection("aaa").snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError)
  //         return new Text('Error: ${snapshot.error}');
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting:
  //           return new Text('Loading...');
  //         default:
  //           print(snapshot.data.toString());
  // Future<List<String>> getShelfBooks(shelf) async{
  //   var firebaseUser = await FirebaseAuth.instance.currentUser();
  //   //CollectionReference dbRef = Firestore.instance.collection('users').document(firebaseUser.uid).collection("shelves");
  //   var shelves = await Firestore.instance.collection('users').document(firebaseUser.uid).collection("shelves").document(shelf).get();
  //   List<String> list = [];
  //   for(var book in shelves.data["books"]){
  //     list.add(book.toString());
  //   } 

  //   return list;
  // }

}

