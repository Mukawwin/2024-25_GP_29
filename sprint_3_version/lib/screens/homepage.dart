import 'package:flutter/material.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';
import 'package:mukawwin_3/models/myallergies.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/Firebase/Auth.dart';
import 'package:mukawwin_3/models/UserModel.dart';
import '../models/mybottombar.dart';
import 'package:mukawwin_3/screens/allergies.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../Firebase/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  UserModel? userModel;
  bool isloading = true;
  AuthService authService = AuthService();
  UserAllergy? userAllergy;
  DatabaseService databaseService = DatabaseService();
  final firestore = FirebaseFirestore.instance;
  List<Myallergies> alleries = [];
  bool show = false;
  getData() async {
    isloading = true;
    await authService.getUserData().then((value) => userModel = value);
    setState(() {
      isloading = false;
    });
  }

  late List<String> mydata = [];
  void fetchAndPrintAllergies() async {
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
          print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
        }
        List<String> uniqueList = mydata.toSet().toList();
        for (int i = 0; i < mydata.length; i++) {
          print('$uniqueList');
        }
        ;

        for (int i = 0; i < uniqueList.length; i++) {
          alleries.add(Myallergies(
              icon: 'icons/${uniqueList[i].toString().toLowerCase()}.png',
              title: uniqueList[i],
              pressable: true));
          print(uniqueList[i]);
        }
        show = true;
      }
    } catch (e) {
      print('Error fetching allergies: $e');
    }
  }

  @override
  void initState() {
    getData();
    fetchAndPrintAllergies();
    // getallirgies();
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
            title: "Welcome ${isloading ? "" : userModel!.username}",
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Your Allergies',
            style: TextStyle(
                fontFamily: 'lato',
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B7e80),
                fontSize: 25.0),
          ),
          show == false
              ? const CircularProgressIndicator()
              : alleries.length > 1
                  ? Expanded(
                      child: AnimationLimiter(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250.0,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 0.0,
                            childAspectRatio: 1,
                          ),
                          itemCount: alleries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: alleries[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                      padding: const EdgeInsets.only(
                          left: 50.0, right: 50.0, top: 20.0, bottom: 20.0),
                      child:
                          SizedBox(width: double.infinity, child: alleries[0]),
                    )),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: InkWell(
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xFF4ECDC4)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Manage Allergies',
                          style: TextStyle(
                              fontFamily: 'lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25.0),
                        ),
                        Icon(
                          Icons.navigate_next_outlined,
                          size: 50.0,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Allergies(showback: true, showProgressBar: false),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const Mybottombar(),
        ],
      ),
    );
  }
}

// Expanded(
//   child: ListView.builder(
//     itemCount: mydata.length, // عدد العناصر في القائمة
//     itemBuilder: (context, index) {
//       return mydata[index];
//     },
//   ),
// ),
// Container(
//   height: 80.0,
//   color: Colors.amber,
// )
