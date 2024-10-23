import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';

import 'UserAllergyModel.dart';

class Myallergies extends StatefulWidget {
  final String icon;
  final String title;

  const Myallergies({super.key, required this.icon, required this.title});

  @override
  State<Myallergies> createState() => _MyallergiesState();
}

class _MyallergiesState extends State<Myallergies> {
  Color colors = Colors.white;
  DatabaseService databaseService = DatabaseService();
  UserAllergy? userAllergy;
  bool isloading = true;

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
      if (userAllergy!.allergie == widget.title) {
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
              },
              child: Card(
                elevation: 4,
                color: colors,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: isloading
                    ? Center(child: CircularProgressIndicator())
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
