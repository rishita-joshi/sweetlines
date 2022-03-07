import 'dart:io';
import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import '../themeclass.dart';

class ThoughtsScreen extends StatefulWidget {
  ThoughtsScreen({Key? key, required this.name}) : super(key: key);
  final String? name;

  @override
  State<ThoughtsScreen> createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends State<ThoughtsScreen> {
  String? data;
  List<dynamic> allData = [];
  String copyString = "";
  List<String> servicesList = [];
  var dataofItem;

  final FirebaseFirestore fb = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    data = widget.name.toString();
    int length;
    print("categeory $data");
    return Scaffold(
      backgroundColor: const Color(0xFF1e3d59),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 3.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "$data",
                style: const TextStyle(color: Colors.amber, fontSize: 20.0),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
                iconSize: 21.0,
                color: Colors.amber,
              )
            ],
          ),
          FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      //  //  allData = snapshot.data?.docs[index].data()["item_text_"];

                      return Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFf5f0e1),
                            border: Border.all(
                                color: Colors.amber.shade900, width: 3),
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 5.0, right: 5.0, bottom: 8.0),
                          child: InkWell(
                            onLongPress: () {
                              FlutterClipboard.copy(
                                allData[index].toString(),
                              ).then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("copied"),
                                  )));
                            },
                            child: Text(
                              allData[index].toString(),
                              style: TextStyle(
                                  color: Colors.brown.shade900, fontSize: 20.0),
                            ),
                          ),
                        ),
                      );
                    },

                    itemCount: allData.length,
                    itemWidth: MediaQuery.of(context).size.width * 1,
                    itemHeight: MediaQuery.of(context).size.height * 0.5,
                    layout: SwiperLayout.TINDER,
                    pagination: SwiperPagination(),
                    // control: SwiperControl(),
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const Text("No data");
                }
                return const Center(child: CircularProgressIndicator());
              }),
          SizedBox(
            height: 45.0,
          ),
          showAds(),
        ],
      ),
    );
  }

  Future<QuerySnapshot?> getData() async {
    dataofItem = FirebaseFirestore.instance
        .collection('$data')
        .get()
        .then((QuerySnapshot? querySnapshot) {
      querySnapshot!.docs.forEach((doc) {
        allData = doc["item_text_"];
        print("allData = $allData");
        //  print("getData = ${doc["item_text_"]}");
      });
    });
    return dataofItem;
  }

  showAds() {
    return Container(
      alignment: Alignment(0.5, 1),
      child: FacebookBannerAd(
        placementId: Platform.isAndroid
            ? "YOUR_ANDROID_PLACEMENT_ID"
            : "YOUR_IOS_PLACEMENT_ID",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          switch (result) {
            case BannerAdResult.ERROR:
              print("Error: $value");
              break;
            case BannerAdResult.LOADED:
              print("Loaded: $value");
              break;
            case BannerAdResult.CLICKED:
              print("Clicked: $value");
              break;
            case BannerAdResult.LOGGING_IMPRESSION:
              print("Logging Impression: $value");
              break;
          }
        },
      ),
    );
  }
}
