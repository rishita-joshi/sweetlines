import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sweetlines/screens/list_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  List<String> servicesList = [];
  String name = " ";

  @override
  void initState() {
  
    super.initState();
    getDataFromFirebase();

    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ThoughtsCategeroy())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FlutterLogo(
          size: MediaQuery.of(context).size.height * 0.2,
        ),
      ),
    ));
  }

  getDataFromFirebase() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('EnglishQuotes').get();
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    final allData =
        querySnapshot.docs.map((doc) => doc.get('item_text_')).toList();
    print("length = ${allData.length}");
  //  print("all data = ${allData}");
  }

  //   var data = FirebaseFirestore.instance
  //       .collection('EnglishQuotes')
  //       .doc("KxOC7wdN8GxIsglOrRcd")
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //        name = documentSnapshot.data().toString();
  //       print("data = $name");
  //       print('Document exists on the database ${documentSnapshot.data()}');
  //         servicesList = name.split(",");
  //        // servicesList.length;
  //                 print("this is list of datas== ${servicesList.length}");
  //     }
  //   });
  //  print(data);

}

// var data = FirebaseFirestore.instance
//     .collection('EnglishQuotes')
//     .get()
//     .then((QuerySnapshot querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//            print(doc["item_text_"]);
//            List<String> names  = doc["item_text_"]; 
//            print("data = $names");
//         });
//     });

// // print(data);
//     return data ;
// }
