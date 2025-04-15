import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/myappbar.dart';

import 'UserAllergyModel.dart';

// ignore: must_be_immutable
class Myallergies extends StatefulWidget {
  final String icon;
  final String title;
  late bool? pressable;

  Myallergies(
      {super.key, required this.icon, required this.title, this.pressable});

  @override
  State<Myallergies> createState() => _MyallergiesState();
}

class _MyallergiesState extends State<Myallergies> {
  Color colors = Colors.white;
  DatabaseService databaseService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool? userAllergy;
  bool isloading = false;
  bool press = false;
  UserDetails? data;
  List<String> myallergy = [];

  void getdetails() async {
    await databaseService.getuserdetails().then((value) {
      print('+++++++++++++++++++++${value.length}++++++++++++++++++++++++');
      for (int i = 0; i < value.length; i++) {
        if (value[i].userUid == _auth.currentUser!.uid) {
          setState(() {
            data = value[i];
          });
        }
      }
    });
  }

  void getmyallergy() async {
    print('+++++++++++++++++++++++++++getallergrie+++++++++++++++++++++++++++');
    DatabaseService databaseService = DatabaseService();
    try {
      print(
          '+++++++++++++++++++++++++++getallergrie+++++++++++++++++++++++++++');
      // جلب الحساسيات
      List<UserAllergy> allergies = await databaseService.getUserAllergies();
      print(
          '+++++++++++++++++++++++++++getallergrie+++++++++++++++++++++++++++');

      // طباعة البيانات في الـ Console
      if (allergies.isEmpty) {
        print('No allergies found for this user.');
      } else {
        print(
            '+++++++++++++++++++++++++++getallergrie+++++++++++++++++++++++++++');
        print('User Allergies:');
        for (var allergy in allergies) {
          if (allergy.name == data!.username) {
            myallergy.add(allergy.allergie);
            print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
          }
        }
        getdata();
      }
    } catch (e) {
      print('Error fetching allergies: $e');
    }
  }

  // getmyallergy() async {
  //   await databaseService.getAllergyFromName(data!.username).then((value) {
  //     for (int i = 0; i < value.length; i++) {
  //       print(
  //           'XXXXXXXXXXXXXXXXXXXXXXXXX${value[i].name}XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  //       myallergy.add(value[i].allergie);
  //       print(value[i].allergie);
  //     }
  //   });
  // }

  void showdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            height: 350.0,
            child: AlertDialog(
              title: const Column(
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: 60.0,
                    color: Colors.red,
                  ),
                  Text(
                    "Update Allergy!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "you are about to updatethe allergy to : ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                  const Text("Do you want to proceed?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      )),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red,
                      ),
                      child: InkWell(
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          print('تم اختيار إلغاء');
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFF4B7e80),
                      ),
                      child: InkWell(
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onTap: () async {
                          checking = true;
                          if (userAllergy == null) {
                            print('++++++++++++++++++++++++++++++++++++++++');
                            await databaseService
                                .addUserAllergy(widget.title, data!.username,
                                    data!.email, data!.gender, data!.id)
                                .then((value) => getdata());
                            myallergy.add(widget.title);
                            getdata();
                          } else {
                            // if (myallergy.length == 1) {
                            // } else {
                            await databaseService
                                .deleteUserAllergy(data!.username, widget.title)
                                .then((onValue) => getdata());
                            setState(() {
                              myallergy.remove(widget.title);
                              getdata();
                            });
                            // }
                          }
                          Navigator.of(context).pop();
                          print('تم اختيار موافقة');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getdata() {
    if (myallergy.contains(widget.title) && widget.pressable == false) {
      print('1111111111111111111111111111111111111111111111');
      userAllergy = true;
      colors = const Color(0xFFD5F4E0);
    } else {
      print('2222222222222222222222222222222222222222222222');
      colors = Colors.white;
    }

    setState(() {
      isloading = false;
    });
    // await databaseService.getAllergyFromName(data!.username).then((value) {
    //   if (value. null) {
    //     print('objectttttttttttttttttttttttttttttttttttttttttttt1');
    //     userAllergy = null;
    //   } else {
    //     // if (widget.title == value.allergie && value.name == data!.username) {
    //     //   userAllergy = value;
    //     //   print('objectttttttttttttttttttttttttttttttttttttttttttt2${value}');
    //     // } else {
    //     //   print('objectttttttttttttttttttttttttttttttttttttttttttt1${value}');
    //     //   userAllergy = null;
    //     // }
    //   }
    // });
    // if (userAllergy != null) {
    //   if (userAllergy!.allergie == widget.title && widget.pressable == false) {
    //     print('${userAllergy!.allergie}+++++++${userAllergy!.name}');
    //     print('objectttttttttttttttttttttttttttttttttttttttttttt3');
    //     colors = const Color(0xFFD5F4E0);
    //   } else {
    //     colors = Colors.white;
    //     print('${userAllergy!.allergie}+++++++${userAllergy!.name}');
    //     print('objectttttttttttttttttttttttttttttttttttttttttttt4');
    //   }
    // } else {
    //   print('objectttttttttttttttttttttttttttttttttttttttttttt5');
    //   colors = Colors.white;
    // }
    // setState(() {
    //   isloading = false;
    // });
  }

  @override
  void initState() {
    getdetails();
    getmyallergy();
    // getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: 70.0,
          height: 100.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: () {
                if (widget.pressable == false) {
                  showdialog(context);
                }
              },
              child: Card(
                elevation: 4,
                color: colors,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: isloading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.icon,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          )),
    );
  }
}
