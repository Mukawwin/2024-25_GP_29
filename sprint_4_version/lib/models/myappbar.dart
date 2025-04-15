import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/Auth.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';
import 'package:mukawwin_3/models/UserModel.dart';

// import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/mybottombar.dart';
import 'package:mukawwin_3/models/save.dart';
import 'package:mukawwin_3/screens/account.dart';
import 'package:mukawwin_3/screens/allergies.dart';
import 'package:mukawwin_3/screens/help.dart';
import 'package:mukawwin_3/screens/homepage.dart';
// import 'package:mukawwin_3/screens/allergies.dart';
import 'package:mukawwin_3/screens/select_icon.dart';

// ignore: must_be_immutable
bool checking = false;

// ignore: must_be_immutable
class Myappbar extends StatefulWidget {
  late String? title;
  late IconData? exit;
  late IconData? back;
  late IconData? backfromallergiestohomepage;

  final bool show;
  late bool? savelist;
  late bool? menu;

  Myappbar(
      {super.key,
      this.backfromallergiestohomepage,
      this.title,
      this.menu,
      this.exit,
      this.back,
      this.savelist,
      required this.show});

  @override
  State<Myappbar> createState() => _MyappbarState();
}

class _MyappbarState extends State<Myappbar> {
  AuthService authService = AuthService();
  String selectedValue = '';
  List<String> allusers = [];
  List<String> uniqueusers = [];
  Map<String, String> icon = {};
  UserModel? userModel;
  Color color = Colors.white;

  final firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  getData() async {
    await authService.getUserData().then((value) => userModel = value);
  }

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
          icon[user.name] = user.gender;
          allusers.add(user.name);
          print('${user.name}');
          // print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
        }
        uniqueusers = allusers.toSet().toList();
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void deletedocs(String name) async {
    if (name == uniqueusers[0]) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        'username': uniqueusers[1],
      });
      print("999999999999999999999999999999999999pp");
      // Navigator.of(context)
      //     .pushReplacementNamed("homepage");
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        'username': uniqueusers[0],
      });
      print("999999999999999999999999999999999999pp");
      // Navigator.of(context)
      //
    }

    QuerySnapshot querySnapshot = await firestore
        .collection(_auth.currentUser!.uid)
        .where('name', isEqualTo: name)
        .get();

    // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    for (var doc in querySnapshot.docs) {
      await firestore.collection(_auth.currentUser!.uid).doc(doc.id).delete();
    }
    print("تم حذف المستند بنجاح");
    List<String> deleteimagepath = [];

    try {
      DatabaseService databaseService = DatabaseService();
      List<Save> savelist = await databaseService.getsaveList(name);

      if (savelist.isEmpty) {
        print('No allergies found for this user.');
        print('uid : ${_auth.currentUser!.uid}');
      } else {
        print('Save List Is:');
        for (var list in savelist) {
          setState(() {
            deleteimagepath.add(list.path);
          });
          print('iamge: ${list.imagename}, title: ${list.title}');
        }
      }
    } catch (e) {
      print(
          'Error fetching======================================================== savelist: $e');
    }
    final FirebaseStorage _storage = FirebaseStorage.instance;
    // for (int i = 0; i < deleteimagepath.length; i++) {
    //   try {
    //     // قم بالإشارة إلى الملف باستخدام المسار
    //     Reference ref = _storage.ref(deleteimagepath[i]);

    //     // احذف الملف
    //     await ref.delete();

    //     print('تم حذف الصورة بنجاح');
    //   } catch (e) {
    //     print('حدث خطأ أثناء حذف الصورة: $e');
    //   }
    // }
    QuerySnapshot querySnapshot1 = await firestore
        .collection('savelist${_auth.currentUser!.uid}')
        .where('name', isEqualTo: name)
        .get();

    // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    for (var doc in querySnapshot1.docs) {
      await firestore
          .collection('savelist${_auth.currentUser!.uid}')
          .doc(doc.id)
          .delete();
    }

    //**************************************************

    try {
      DatabaseService databaseService = DatabaseService();
      List<Incidentlog> savelist =
          await databaseService.getIncidentlogList(name);

      if (savelist.isEmpty) {
        print('No allergies found for this user.');
        print('uid : ${_auth.currentUser!.uid}');
      } else {
        print('Save List Is:');
        for (var list in savelist) {
          setState(() {
            deleteimagepath.add(list.path);
          });
          print('iamge: ${list.imagename}, title: ${list.title}');
        }
      }
    } catch (e) {
      print(
          'Error fetching======================================================== savelist: $e');
    }
    // final FirebaseStorage _storage = FirebaseStorage.instance;
    for (int i = 0; i < deleteimagepath.length; i++) {
      try {
        // قم بالإشارة إلى الملف باستخدام المسار
        Reference ref = _storage.ref(deleteimagepath[i]);

        // احذف الملف
        await ref.delete();

        print('تم حذف الصورة بنجاح');
      } catch (e) {
        print('حدث خطأ أثناء حذف الصورة: $e');
      }
    }
    QuerySnapshot querySnapshot2 = await firestore
        .collection('incidents${_auth.currentUser!.uid}')
        .where('name', isEqualTo: name)
        .get();

    // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    for (var doc in querySnapshot2.docs) {
      await firestore
          .collection('incidents${_auth.currentUser!.uid}')
          .doc(doc.id)
          .delete();
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Homepage()));
  }

  @override
  void initState() {
    getData();
    getUsersForThisAccount();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("images/6.png"),
        widget.show == false
            ? Positioned(
                top: 30,
                left: 5,
                child: widget.exit != null
                    ? IconButton(
                        onPressed: () async {
                          bool? confirmExit = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Column(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 40,
                                      color: Color(0xFF387F7F),
                                    ),
                                    Text(
                                      "Sign out confirmation",
                                      style: TextStyle(
                                        fontFamily: 'lato',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF387F7F),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Divider(
                                      color: Color(0xFF387F7F),
                                      thickness: 0,
                                    ),
                                  ],
                                ),
                                content: const Text(
                                  "Are you sure you want to sign out?",
                                  style: TextStyle(
                                    fontFamily: 'lato',
                                    fontSize: 18,
                                    color: Color(0xFF387F7F),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Color(0xFF387F7F),
                                            fontFamily: 'lato',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(flex: 1),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text(
                                          "Sign out",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'lato',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmExit == true) {
                            await authService.signOut().then((value) =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "signin", (route) => false));
                          }
                        },
                        icon: Icon(
                          widget.exit,
                          size: 30,
                          color: Colors.white,
                        ),
                      )
                    : widget.menu != null
                        ? PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (uniqueusers.contains(value)) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_auth.currentUser!.uid)
                                    .update({
                                  'username': value,
                                });
                                print("999999999999999999999999999999999999pp");
                                Navigator.of(context)
                                    .pushReplacementNamed("homepage");
                              } else {
                                switch (value) {
                                  case 'Add':
                                    [
                                      print(
                                          'AddAccount+++++++++++++++++++++++++'),
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SelectIcon(
                                            backbutton: true,
                                            editable: false,
                                          ),
                                        ),
                                      ),
                                    ];
                                    break;
                                  case 'Edit':
                                    [
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Account(),
                                        ),
                                      ),
                                    ];
                                    break;
                                  case 'change':
                                    [
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Allergies(
                                            backicon: true,
                                            showProgressBar: false,
                                            uid: _auth.currentUser!.uid,
                                            name: userModel!.username,
                                            showback: true,
                                          ),
                                        ),
                                      ),
                                    ];
                                    break;
                                  case 'help':
                                    [
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => Help(
                                                    nav: true,
                                                  )))
                                    ];
                                    break;
                                }
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              /// ✅ **إضافة العناصر ديناميكيًا من قائمة `allusers`**
                              ...uniqueusers.map((user) => PopupMenuItem(
                                  value:
                                      user, // يمكنك تحديد قيمة خاصة لكل مستخدم
                                  child: Card(
                                    color: 'Welcome $user' == widget.title
                                        ? Colors.grey
                                        : color,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            'Welcome $user' == widget.title
                                                ? Colors.grey
                                                : color,
                                        child: Image.asset(
                                            "images/${icon[user]}.png"),
                                      ),
                                      title: 'Welcome $user' == widget.title
                                          ? FittedBox(
                                              child: Text(
                                                user,
                                              ),
                                            )
                                          : Text(user),
                                      // عرض اسم المستخدم
                                      trailing: 'Welcome $user' == widget.title
                                          ? IconButton(
                                              onPressed: () {
                                                if (uniqueusers.length == 1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                      "You Can't Delete All Users !",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ));
                                                } else {
                                                  deletedocs(user);

                                                  print(
                                                      "User IS ===== : $user");
                                                }
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                          : Text(""),
                                    ),
                                  ))),

                              /// ✅ **إضافة العناصر الثابتة بعد العناصر الديناميكية**
                              const PopupMenuItem(
                                value: 'Add',
                                child: ListTile(
                                  leading: Icon(Icons.add, color: Colors.blue),
                                  title: Text('New Profile'),
                                ),
                              ),

                              const PopupMenuItem(
                                value: 'Edit',
                                child: ListTile(
                                  leading: Icon(Icons.manage_accounts,
                                      color: Colors.green),
                                  title: Text('Settings'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'change',
                                child: ListTile(
                                  leading: Icon(Icons.change_circle,
                                      color: Colors.green),
                                  title: Text('My Allergies'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'help',
                                child: ListTile(
                                  leading: Icon(Icons.help, color: Colors.blue),
                                  title: Text('Help'),
                                ),
                              ),
                            ],
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ), // أيقونة ثلاث نقاط
                          )
                        : Text(""))
            : const Text(''),
        Positioned(
          left: 15.0,
          bottom: 0.0,
          child: Text(
            widget.title == null ? '' : widget.title!,
            style: const TextStyle(
                fontSize: 25.0,
                fontFamily: 'Lato',
                color: Color(0xFF4B7e80),
                fontWeight: FontWeight.bold),
          ),
        ),
        widget.back != null
            ? Positioned(
                bottom: 30,
                left: 5,
                child: IconButton(
                  onPressed: () {
                    isload = false;

                    Navigator.of(context).pushReplacementNamed("homepage");
                  },
                  icon: Icon(
                    widget.back,
                    size: 40,
                    color: const Color(0xFF4B7e80),
                  ),
                ),
              )
            : const Text(""),
        widget.savelist == true
            ? const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Icon(
                  Icons.save_alt,
                  size: 50.0,
                  color: Color(0xFF4ECDC4),
                ),
              )
            : const Text(''),
        widget.backfromallergiestohomepage != null
            ? Positioned(
                bottom: 30,
                left: 5,
                child: IconButton(
                  onPressed: () {
                    isload = false;
                    if (checking) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "You Have Update the Allergies .. Clik On Save !",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ));
                    } else {
                      Navigator.of(context).pushReplacementNamed("homepage");
                    }
                    // getData();
                    // fetchAndPrintAllergies();
                    // if (mydata.isEmpty) {
                    // } else {
                    // }
                  },
                  icon: Icon(
                    widget.backfromallergiestohomepage,
                    size: 40,
                    color: const Color(0xFF4B7e80),
                  ),
                ),
              )
            : const Text(""),
      ],
    );
  }
}
