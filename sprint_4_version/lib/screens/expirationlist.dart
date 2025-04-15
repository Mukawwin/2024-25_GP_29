import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/expirationcard.dart';
import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/models/mybottombar.dart';
import 'package:mukawwin_3/models/save.dart';
import 'package:mukawwin_3/screens/selectforsafelist.dart';

class Expirationlist extends StatefulWidget {
  const Expirationlist({super.key});

  @override
  State<Expirationlist> createState() => _ExpirationlistState();
}

class _ExpirationlistState extends State<Expirationlist> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserDetails? userDetails;

  List<Expirationcard> mylist = [];

  void getUser() async {
    DatabaseService databaseService = DatabaseService();
    try {
      // جلب الحساسيات
      List<UserDetails> users = await databaseService.getuserdetails();

      // طباعة البيانات في الـ Console
      if (users.isEmpty) {
        print('No allergies found for this user.');
      } else {
        print('User Allergies:');
        for (var user in users) {
          userDetails = user;
          // print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
        }
      }
      getExpirationlist();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void getExpirationlist() async {
    print('11111111111111111111111111111111111');
    DatabaseService databaseService = DatabaseService();
    try {
      List<Expiration> savelist =
          await databaseService.getExpirationList(userDetails!.username);

      if (savelist.isEmpty) {
        print('No allergies found for this user.');
        print('uid : ${_auth.currentUser!.uid}');
      } else {
        print('Save List Is:');
        for (var list in savelist) {
          //     Timestamp timestamp = list.date; // استرجاع كـ Timestamp
          // DateTime date = timestamp.toDate(); // تحويل إلى DateTime
          try {
            setState(() {
              mylist.add(Expirationcard(
                  title: list.title,
                  img: list.imagename,
                  expirationdate: list.date.toDate()));
            });
          } catch (e) {
            print(
                '------------------------------anvalid card--------------------');
          }

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
              Myappbar(
                show: false,
                title: "Expiration List",
              ),
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Selectforsafelist(),
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
