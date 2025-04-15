import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/Api.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';
import 'package:mukawwin_3/models/customtextfield.dart';
import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/models/mybottombar.dart';
import 'package:mukawwin_3/models/alertlist.dart';
import 'package:mukawwin_3/screens/check.dart';

class ImageSelected extends StatefulWidget {
  final File imageFile;
  const ImageSelected({super.key, required this.imageFile});

  @override
  State<ImageSelected> createState() => _ImageSelectedState();
}

class _ImageSelectedState extends State<ImageSelected> {
  UserDetails? userDetails;
  // List<String> mydata = [];
  // getdata() async {
  //   DatabaseService databaseService = DatabaseService();
  //   try {
  //     // جلب الحساسيات
  //     List<UserAllergy> allergies = await databaseService.getUserAllergies();

  //     // طباعة البيانات في الـ Console
  //     if (allergies.isEmpty) {
  //       print('No allergies found for this user.');
  //     } else {
  //       print('User Allergies:');
  //       for (var allergy in allergies) {
  //         mydata.add(allergy.allergie);
  //         // print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
  //       }
  //       setState(() {
  //         mydata = mydata.toSet().toList();
  //       });
  //     }
  //   } catch (e) {
  //     print('Error fetching allergies: $e');
  //   }
  // }
  late List<String> mydata = [];

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
          print(
              'ttttttttttttttttttttttttt${userDetails!.username}ttttttttttttttttttttttttttt');
          // print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
        }
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void fetchAndPrintAllergies() async {
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
          if (allergy.name == userDetails!.username) {
            setState(() {
              mydata.add(allergy.allergie);
            });
            print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
          }
        }
      }
    } catch (e) {
      print('Error fetching allergies: $e');
    }
  }

  @override
  void initState() {
    getUser();
    fetchAndPrintAllergies();
    // getallirgies();
    super.initState();
  }

  AIAPI aiapi = AIAPI();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isload
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Myappbar(
                  show: false,
                  back: Icons.arrow_back,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    // width: double.infinity,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: Image.file(
                      widget.imageFile,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                    onPressed: () async {
                      // String allergies ="";
                      // for(var)
                      await aiapi
                          .postOCRData(
                              imageFile: widget.imageFile,
                              allergies: mydata.join(','))
                          .then((value) {
                        if (value.warnings.hasAllergens) {
                          allalert[1].allergies =
                              value.analysis.detectedAllergens;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Check(select: 1),
                            ),
                          );
                        } else {
                          allalert[1].allergies = [];
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Check(select: 0),
                            ),
                          );
                        }
                      });
                    },
                    buttonname: "Done"),
                const Center(
                    child: Text(
                  'Checking for these allergies:',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                )),
                Expanded(
                    child: ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: mydata.length,
                  itemBuilder: (BuildContext context, int index) {
                    // تصميم العنصر الواحد في القائمة
                    return Center(child: Text(mydata[index]));
                  },
                ))
              ],
            ),
    );
  }
}
