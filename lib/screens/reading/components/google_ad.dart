// import 'package:book_app/models/database/shelf_db.dart';
// import 'package:book_app/screens/reading/components/widgets/shelf_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:book_app/models/global.dart';
// import 'package:flutter/rendering.dart';

// import 'package:firebase_admob/firebase_admob.dart';


// const String testDevice = '';

// class GoogleAd extends StatefulWidget{
//   @override
//   _GoogleAdState createState() => _GoogleAdState();
// }

// class _GoogleAdState extends State<GoogleAd>{
//   static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     testDevices: testDevice != null ? <String>[testDevice] : null,
//     nonPersonalizedAds: true,
//     keywords: <String>['Book','Reading','Novel'],
//   );

//   BannerAd _bannerAd;
//   BannerAd createBannerAd (){
//     return BannerAd(
//       adUnitId: BannerAd.testAdUnitId,
//       size: AdSize.banner,
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event){
//         print("BannerAd $event");
//       }
//     );
//   }

//   @override
//   void initState(){
//     FirebaseAdMob.instance.initialize(
//       appId: BannerAd.testAdUnitId  
//     );
//     _bannerAd = createBannerAd()..load()..show();
//     super.initState();
//   }

//   @override
//   void dispose(){
//     _bannerAd.dispose();
//     super.dispose();
//   }

//   Container getShelf(shelf, context){
//     return Container(
//       child: Column(
//         children: <Widget>[
//           new Container(
//             height: 50,
//             color: darkGrey,
//             padding: EdgeInsets.only(left: 30, right: 30, top: 20,),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 new Text(
//                   shelf,
//                   style: TextStyle(
//                     fontSize: 20, 
//                     fontWeight: FontWeight.bold, 
//                     color: lightGrey,
//                   ),
//                 ),
//                 new GestureDetector(
//                   child: Icon(
//                     Icons.add_circle,
//                     color: lightGrey,
//                     size: 30,
//                   ),
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (BuildContext context) => ShelfWidgets().showShelfList(context, shelf)),
//                 ),
//               ],
//             ),
//           ),
//           new Container(
//             height: 150,
//             child: FutureBuilder<StreamBuilder>(
//               future: ShelfDB().displayBooks(shelf),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                     return snapshot.data;
//                 } else if (snapshot.hasError) {
//                   return Text("${snapshot.error}");
//                 }
//                 else{
//                   return CircularProgressIndicator();
//                 }
//               },        
//             ),
//           )
//         ]
//       )
//     );   
//   }



//   @override
//   Widget build(BuildContext context){

//   }
// }


  