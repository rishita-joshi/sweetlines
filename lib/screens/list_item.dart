import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sweetlines/screens/thoughts_screen.dart';

import '../themeclass.dart';

class ThoughtsCategeroy extends StatefulWidget {
  ThoughtsCategeroy({Key? key}) : super(key: key);

  @override
  State<ThoughtsCategeroy> createState() => _ThoughtsCategeroyState();
}

class _ThoughtsCategeroyState extends State<ThoughtsCategeroy> {
  final FirebaseFirestore fb = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeClass.redColor,
          centerTitle: false,
          title: Text("data"),
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            child: FutureBuilder(
                future: getData(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 10.0, right: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ThoughtsScreen(
                                                name: snapshot.data?.docs[index]
                                                    .data()["name"],
                                              )),
                                    );
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    alignment: Alignment.center,
                                    child: Image.network(
                                      snapshot.data?.docs[index]
                                          .data()["img_url"],
                                      //'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
                                      // height: 250,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 45.0, left: 15.0),
                                child: Text(
                                  snapshot.data?.docs[index].data()["name"],
                                  //  textData[index],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                              ),
                            ],
                          );
                        });
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Text("No data");
                  }
                  return CircularProgressIndicator();
                })));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData() {
    return fb.collection("sweetlines").get();
  }
}
