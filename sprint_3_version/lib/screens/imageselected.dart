import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';
import 'package:mukawwin_3/models/customtextfield.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/models/mybottombar.dart';

import 'package:mukawwin_3/screens/check.dart';

class ImageSelected extends StatefulWidget {
  final File imageFile;
  const ImageSelected({super.key, required this.imageFile});

  @override
  State<ImageSelected> createState() => _ImageSelectedState();
}

class _ImageSelectedState extends State<ImageSelected> {
  List<String> mydata = [];
  getdata() async {
    DatabaseService databaseService = DatabaseService();
    try {
      // جلب الحساسيات
      List<UserAllergy> allergies = await databaseService.getUserAllergies();

      // طباعة البيانات في الـ Console
      if (allergies.isEmpty) {
        print('No allergies found for this user.');
      } else {
        print('User Allergies:');
        for (var allergy in allergies) {
          mydata.add(allergy.allergie);
          // print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
        }
        setState(() {
          mydata = mydata.toSet().toList();
        });
      }
    } catch (e) {
      print('Error fetching allergies: $e');
    }
  }

  @override
  void initState() {
    getdata();
    // getallirgies();
    super.initState();
  }

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
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Check(select: 0),
                        ),
                      );
                    },
                    buttonname: "Done"),
                const Center(
                    child: Text(
                  'Cheching for these allergies:',
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
