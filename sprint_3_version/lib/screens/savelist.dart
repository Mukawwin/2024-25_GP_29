import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/models/mycard.dart';
import 'package:mukawwin_3/models/save.dart';
import '../models/mybottombar.dart';

class Savelist extends StatefulWidget {
  const Savelist({super.key});

  @override
  State<Savelist> createState() => _SavelistState();
}

class _SavelistState extends State<Savelist> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Mycard> mylist = [];
  // String? url;

  void getsavelist() async {
    DatabaseService databaseService = DatabaseService();
    try {
      List<Save> savelist = await databaseService.getaveList();

      if (savelist.isEmpty) {
        print('No allergies found for this user.');
        print('uid : ${_auth.currentUser!.uid}');
      } else {
        print('Save List Is:');
        for (var list in savelist) {
          setState(() {
            mylist.add(Mycard(
              img: list.imagename,
              title: list.title,
              exdate: '',
              path: list.path,
              docid: list.id,
            ));
          });
          print('iamge: ${list.imagename}, title: ${list.title}');
        }
      }
    } catch (e) {
      print(
          'Error fetching======================================================== savelist: $e');
    }
  }

  @override
  void initState() {
    getsavelist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Myappbar(
            show: false,
            title: "   Safe List",
          ),
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mylist.length, // عدد العناصر في القائمة
              itemBuilder: (context, index) {
                return mylist[index];
              },
            ),
          ),
          const Mybottombar(),
        ],
      ),
    );
  }
}
