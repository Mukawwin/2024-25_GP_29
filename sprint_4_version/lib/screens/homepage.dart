import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/adsense/v2.dart';
import 'package:mukawwin_3/methods/alarm_service.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';
import 'package:mukawwin_3/models/myallergies.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/Firebase/Auth.dart';
import 'package:mukawwin_3/models/UserModel.dart';
import 'package:mukawwin_3/screens/select_icon.dart';
import '../models/mybottombar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../Firebase/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  List<Myallergies> alleries = [];
  bool show = false;
  String? mytoken;

  List<String> allusers = [];
  // myrequest() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('User granted provisional permission');
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }

  // void gettoken() async {
  //   mytoken = await FirebaseMessaging.instance.getToken();
  //   // updateDocument(mytoken!);
  //   print('==============================================');
  //   print(mytoken);
  // }

  // Future<void> updateDocument(String newValue) async {
  //   QuerySnapshot querySnapshot = await firestore
  //       .collection('users')
  //       .where('uid', isEqualTo: _auth.currentUser!.uid)
  //       .get();

  //   for (var doc in querySnapshot.docs) {
  //     await firestore.collection('users').doc(doc.id).update({
  //       'mytoken': newValue,
  //     });
  //   }
  // }

  getData() async {
    isloading = true;
    await authService.getUserData().then((value) => userModel = value);
    setState(() {
      isloading = false;
    });
  }

  late List<String> mydata = [];
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
          if (allergy.name == userModel!.username) {
            mydata.add(allergy.allergie);
            print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
          }
        }
        // List<String> uniqueList = mydata.toSet().toList();
        for (int i = 0; i < mydata.length; i++) {
          alleries.add(Myallergies(
              icon: 'icons/${mydata[i].toString().toLowerCase()}.png',
              title: mydata[i],
              pressable: true));
          print('$mydata mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
          print(
              "HHHHHHHHHHHHHHHHHHHHHHHHHHHH${mydata}HHHHHHHHHHHHHHHHHHHHHHHHH");
        }
        if (mydata.length < 1) {
          await Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SelectIcon(
                    editable: false,
                  )));
        }
        setState(() {
          show = true;
        });
      }
    } catch (e) {
      print('Error fetching allergies: $e');
    }
  }

  void addScheduledNotification() async {
    // استبدل بـ Device Token الخاص بك
    String deviceToken = mytoken!;

    // تحديد تاريخ ووقت الإشعار
    DateTime sendAt = DateTime.utc(
        2025, 4, 7, 3, 40, 40); // 8 أبريل 2025 الساعة 3:00 مساءً بتوقيت UTC

    // إضافة الإشعار إلى Firestore
    try {
      await FirebaseFirestore.instance
          .collection('scheduled_notifications')
          .add({
        'token': deviceToken,
        'title': 'موعد الخدمة',
        'body': 'لديك خدمة مجدولة غدًا',
        'sendAt': sendAt.toIso8601String(), // تأكد من أن الوقت بتنسيق ISO 8601
      });

      print("تم إضافة الإشعار المجدول!");
    } catch (e) {
      print('لم يتم اضافة الاشعار');
    }
  }

  @override
  void initState() {
    // myrequest();
    // gettoken();
    getData();
    fetchAndPrintAllergies();
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
            menu: true,
            show: false,
            title: "Welcome ${isloading ? "" : userModel!.username}",
          ),
          const SizedBox(
            height: 20.0,
          ),
          // IconButton(
          //     onPressed: () async {
          //       await scheduleAlarm(DateTime.now().add(Duration(seconds: 2)));
          //     },
          //     icon: Icon(
          //       Icons.ac_unit_rounded,
          //       color: Colors.red,
          //     )),
          const Text(
            'Your Allergies',
            style: TextStyle(
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
          const Mybottombar(),
        ],
      ),
    );
  }
}
