import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/incidentlogcard.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/models/mybottombar.dart';
import 'package:mukawwin_3/models/save.dart';
import 'package:mukawwin_3/screens/formaddincident.dart';

class Incidentloglist extends StatefulWidget {
  const Incidentloglist({super.key});

  @override
  State<Incidentloglist> createState() => _IncidentloglistState();
}

class _IncidentloglistState extends State<Incidentloglist> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Incidentlogcard> mylist = [];
  UserDetails? userDetails;

  void getUser() async {
    DatabaseService databaseService = DatabaseService();
    try {
      List<UserDetails> users = await databaseService.getuserdetails();

      if (users.isEmpty) {
        print('No allergies found for this user.');
      } else {
        print('User Allergies:');
        for (var user in users) {
          userDetails = user;
        }
        getincidentlist();
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void getincidentlist() async {
    DatabaseService databaseService = DatabaseService();
    try {
      List<Incidentlog> savelist =
          await databaseService.getIncidentlogList(userDetails!.username);

      if (savelist.isEmpty) {
        print('No allergies found for this user.');
        print('uid : ${_auth.currentUser!.uid}');
      } else {
        print('Save List Is:');
        for (var list in savelist) {
          setState(() {
            mylist.add(Incidentlogcard(
              image: list.imagename,
              title: list.title,
              date: list.date.toDate(),
              description: list.desc,
              path: list.path,
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
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Column(
                children: [
                  Myappbar(
                    show: false,
                    title: 'Incident Log',
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Formaddincident(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 50.0,
                          color: Color(0xFF4B7e80),
                        )),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          // mylist.isEmpty
          //     ? wait == true
          //         ? const Center(
          //             child: Text('No Products available'),
          //           )
          //         : const CircularProgressIndicator()
          //     : const Text(''),
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
