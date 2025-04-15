// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';
// import 'package:mukawwin_3/Firebase/database.dart';
// import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/screens/allergies.dart';
// import 'package:mukawwin_3/screens/allergies.dart';

// ignore: must_be_immutable
class SelectIcon extends StatefulWidget {
  final bool editable;
  // final String docid;
  late String? name;
  late bool? male;
  late bool? female;
  late bool? backbutton;
  SelectIcon({
    super.key,
    // required this.docid,
    required this.editable,
    this.male,
    this.female,
    this.name,
    this.backbutton,
  });

  @override
  State<SelectIcon> createState() => _SelectIconState();
}

class _SelectIconState extends State<SelectIcon> {
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool selectmale = false;
  late bool selectfemale = false;
  late String gender;

  List<String> allusers = [];

  void getUsersForThisAccount() async {
    DatabaseService databaseService = DatabaseService();
    try {
      // جلب الحساسيات
      List<UserAllergy> users = await databaseService.getalluser();

      // طباعة البيانات في الـ Console
      if (users.isEmpty) {
        print('No allergies found for this user.');
      } else {
        print('User Allergies:');
        for (var user in users) {
          allusers.add(user.name);
          print('${user.name}');
          // print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
        }
        allusers = allusers.toSet().toList();
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  void initState() {
    if (widget.editable) {
      username.text = widget.name!;
      if (widget.male!) {
        // color = const Color(0xFFD5F4E0);
        gender = "male";
        selectmale = true;
        selectfemale = false;
      } else if (widget.female!) {
        // color = const Color(0xFFD5F4E0);
        gender = 'female';
        selectfemale = true;
        selectmale = false;
      }
    }
    getUsersForThisAccount();
    super.initState();
  }

  @override
  void dispose() {
    getUsersForThisAccount();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formstate,
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.backbutton == true
                  ? Myappbar(
                      back: Icons.subdirectory_arrow_left_sharp,
                      show: true,
                    )
                  : Myappbar(
                      show: true,
                    ),
              const SizedBox(height: 30),
              const Text(
                "Select Icon",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff387f7f)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    radius: 25,
                    onTap: () {
                      setState(() {
                        if (widget.editable == false) {
                          selectmale
                              ? selectmale = false
                              : [
                                  gender = "male",
                                  selectmale = true,
                                  selectfemale = false,
                                ];
                        }
                      });
                    },
                    child: Container(
                      // padding: EdgeInsets.all(15),
                      margin: const EdgeInsets.all(15),
                      // color: Colors.white,
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: const Offset(0, 0),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: -4,
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            spreadRadius: -5,
                            blurRadius: 10,
                            offset: Offset(0, -10),
                          ),
                        ],
                        color:
                            selectmale ? const Color(0xFFD5F4E0) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset("images/male.png")),
                      ),
                    ),
                  ),

                  //********************************************

                  InkWell(
                      radius: 25,
                      onTap: () {
                        setState(() {
                          if (widget.editable == false) {
                            selectfemale
                                ? selectfemale = false
                                : [
                                    gender = 'female',
                                    selectfemale = true,
                                    selectmale = false
                                  ];
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(0, 0),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: -4,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              spreadRadius: -5,
                              blurRadius: 10,
                              offset: Offset(0, -10),
                            ),
                          ],
                          color: selectfemale
                              ? const Color(0xFFD5F4E0)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset("images/female.png"),
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: widget.editable == false
                    ? TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                          label: Center(
                              child: Text(
                            "Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.grey[600],
                            ),
                          )),
                          fillColor: Colors.grey[300],
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          widget.name!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 35),
              !widget.editable
                  ? MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: const Color(0xFF4ECDC4),
                      onPressed: () async {
                        if ((selectmale || selectfemale) &&
                            username.text != "" &&
                            !allusers.contains(username.text)) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(_auth.currentUser!.uid)
                              .update({
                            'username': username.text,
                            'gender': gender,
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Allergies(
                                backicon: false,
                                showProgressBar: false,
                                uid: _auth.currentUser!.uid,
                                name: username.text,
                                male: selectmale,
                                female: selectfemale,
                              ),
                            ),
                          );
                          print("selest allergies ppppppppppppppppppppppp");
                        } else if (allusers.contains(username.text)) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Row(
                            children: [
                              Text("This Name is Already exist"),
                              Icon(
                                Icons.warning_amber,
                                color: Colors.red,
                              )
                            ],
                          )));
                        } else {
                          print(selectfemale);
                          print(selectmale);
                          print(username.text);
                          print(
                              'nooooooooooooooooooooooooooooooooonooooooooooooooooo');
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Row(
                            children: [
                              Text(
                                  "Please select gender and name before select allergies "),
                              Icon(
                                Icons.warning_amber,
                                color: Colors.red,
                              )
                            ],
                          )));
                        }
                      },
                      child: const Text(
                        "Select Allergies",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey,
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(25),
                      // ),

                      child: const Text(
                        "Select Allergies",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 15),
              const Divider(
                indent: 25,
                endIndent: 25,
              ),
              const SizedBox(height: 20),
              widget.editable
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("homepage");
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            color: Color(0xff387f7f),
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ))
                  : const Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
