import 'package:flutter/material.dart';
import 'package:mukawwin_3/APIservice/Firebase/database.dart';

import '../models/UserAllergyModel.dart';

class Myallergies extends StatefulWidget {
  final AllergyModel allergyModel;

  const Myallergies({super.key, required this.allergyModel});

  @override
  State<Myallergies> createState() => _MyallergiesState();
}

class _MyallergiesState extends State<Myallergies> {
  Color colors = Colors.white;
  DatabaseService databaseService = DatabaseService();
  bool isloading = true;
  bool isExsit = false;
  getdata() async {
    isloading = true;
    setState(() {});

    print("=====================");
    print(widget.allergyModel.id);
    await databaseService
        .checkIfAllergyExsit(widget.allergyModel.id)
        .then((value) => isExsit = value);
    if (isExsit) {
      colors = const Color(0xFFD5F4E0);
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
                if (!isExsit) {
                  await databaseService
                      .addUserAllergy(widget.allergyModel.id)
                      .then((value) => getdata());
                } else {
                  await databaseService
                      .deleteUserAllergy(widget.allergyModel.id)
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
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.allergyModel.icon,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.allergyModel.title,
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
