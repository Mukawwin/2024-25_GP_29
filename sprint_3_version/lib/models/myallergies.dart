import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';

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
  UserAllergy? userAllergy;
  bool isloading = true;
  bool press = false;
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
                          if (userAllergy == null) {
                            await databaseService
                                .addUserAllergy(widget.title)
                                .then((value) => getdata());
                          } else {
                            await databaseService
                                .deleteUserAllergy(userAllergy!.id)
                                .then((onValue) => getdata());
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

  getdata() async {
    isloading = true;
    await databaseService.getAllergyFromName(widget.title).then((value) {
      if (value == null) {
        userAllergy = null;
      } else {
        userAllergy = value;
      }
    });
    if (userAllergy != null) {
      if (userAllergy!.allergie == widget.title && widget.pressable == false) {
        colors = const Color(0xFFD5F4E0);
      } else {
        colors = Colors.white;
      }
    } else {
      colors = Colors.white;
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    getdata();
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
