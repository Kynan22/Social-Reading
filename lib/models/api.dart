import 'package:http/http.dart' as http;
import 'package:book_app/classes/book.dart';
import 'dart:convert';
import 'dart:async' show Future;

class Api{
  
  Future<Map<String, dynamic>> fetchBook(isbn) async {
    String url = "https://www.googleapis.com/books/v1/volumes?q=isbn:"+isbn+"&key=AIzaSyCnDYXvB58T7vcZWZW0-5ajpEp5V4QQZp4";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('RETURNING: ' + response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Book> fetchBooks(title) async {
    title = title.replaceAll(RegExp(' '), '+');
    String url = "https://www.googleapis.com/books/v1/volumes?q="+title+"&key=AIzaSyCnDYXvB58T7vcZWZW0-5ajpEp5V4QQZp4";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var book = Book.fromJson(json.decode(response.body));
      return book;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<String>> fetchBookIsbn(title) async {
    title = title.replaceAll(RegExp(' '), '+');
    String url = "https://www.googleapis.com/books/v1/volumes?q=intitle:"+title+"&key=AIzaSyCnDYXvB58T7vcZWZW0-5ajpEp5V4QQZp4";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('RETURNING: ' + response.body);
      var book = Book.fromJson(json.decode(response.body));
      List<String> isbnList = [];
      for (var x = 0; x < book.items.length && x < 20; x++){
        if(book.items[x].volumeInfo.industryIdentifiers != null){
          if(book.items[x].volumeInfo.industryIdentifiers.length > 1 ){
            if(book.items[x].volumeInfo.industryIdentifiers[0].toJson()['identifier'].toString().length == 13){
              print('adding ' + book.items[x].volumeInfo.industryIdentifiers[0].toJson().toString());
              isbnList.add(book.items[x].volumeInfo.industryIdentifiers[0].toJson()['identifier'].toString());
            }
            else if(book.items[x].volumeInfo.industryIdentifiers[1].toJson()['identifier'].toString().length == 13){
              print('adding ' + book.items[x].volumeInfo.industryIdentifiers[1].toJson().toString());
              isbnList.add(book.items[x].volumeInfo.industryIdentifiers[1].toJson()['identifier'].toString());
            }
            else{
              print("FAILED");
            }
          }
        }
      }
      return isbnList;
      //return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}