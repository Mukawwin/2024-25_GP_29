import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/Auth.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/models/mybottombar.dart';
import 'package:mukawwin_3/models/UserModel.dart';

class Account extends StatefulWidget {
  const Account({
    super.key,
  });

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  bool changename = false;
  UserModel? userModel;
  bool isloading = true;
  bool wait = false;
  AuthService authService = AuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController username = TextEditingController();

  getData() async {
    isloading = true;
    await authService.getUserData().then((value) => userModel = value);
    setState(() {
      isloading = false;
    });
  }

  Future<void> updateDocument(String valueToSearch, String newValue) async {
    // الخطوة 1: إنشاء استعلام للبحث عن الوثيقة
    QuerySnapshot querySnapshot = await firestore
        .collection(_auth.currentUser!.uid)
        .where('name', isEqualTo: valueToSearch)
        .get();

    // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    for (var doc in querySnapshot.docs) {
      await firestore.collection(_auth.currentUser!.uid).doc(doc.id).update({
        'name': newValue,
      });
    }
    QuerySnapshot querySnapshot1 = await firestore
        .collection("savelist${_auth.currentUser!.uid}")
        .where('name', isEqualTo: valueToSearch)
        .get();

    // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    for (var doc in querySnapshot1.docs) {
      await firestore
          .collection("savelist${_auth.currentUser!.uid}")
          .doc(doc.id)
          .update({
        'name': newValue,
      });
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'username': username.text,
    });
    setState(() {
      changename = false;
      wait = false;
      getData();
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Myappbar(
            // back: Icons.arrow_back,
            show: false,
            menu: true,
            title: "Welcome ${isloading ? "" : userModel!.username}",
          ),
          const SizedBox(height: 25),
          Center(
            child: isloading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, bottom: 25.0, left: 15.0, right: 15.0),
                    child: Container(
                      padding: const EdgeInsets.all(25.0),
                      width: double.infinity,
                      height: 260.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: const Offset(0, 0),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: -7,
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            spreadRadius: -7,
                            blurRadius: 10,
                            offset: Offset(0, -10),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              changename == false
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.person,
                                            color: Color(0xFF4A9A9B)),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Name  ',
                                          style: TextStyle(
                                              fontFamily: 'lato',
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            userModel!.username,
                                            style: const TextStyle(
                                                fontFamily: 'lato',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                changename = true;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Color(0xFF4A9A9B),
                                            ))
                                      ],
                                    )
                                  : wait == false
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: TextFormField(
                                                controller: username,
                                                decoration: InputDecoration(
                                                  label: Center(
                                                      child: Text(
                                                    "Name",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25,
                                                      color: Colors.grey[600],
                                                    ),
                                                  )),
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  if (username.text != "") {
                                                    setState(() {
                                                      wait = true;
                                                    });
                                                    updateDocument(
                                                        userModel!.username,
                                                        username.text);
                                                  }
                                                },
                                                icon: const Icon(Icons.check))
                                          ],
                                        )
                                      : const CircularProgressIndicator(),
                              const Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.email,
                                      color: Color(0xFF4A9A9B)),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        fontFamily: 'lato',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      userModel!.email,
                                      style: const TextStyle(
                                          fontFamily: 'lato',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 18.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                              const Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock,
                                      color: Color(0xFF4A9A9B)),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                        fontFamily: 'lato',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "******",
                                    style: TextStyle(
                                        fontFamily: 'lato',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 18.0),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xFF4A9A9B),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          MaterialButton(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: Colors.red[700],
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
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("signin", (route) => false));
              }
            },
            child: const Text(
              "Sign Out",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          // Mybottombar(),
          isKeyboardOpen(context)
              ? const SizedBox.shrink()
              : const Mybottombar(),
        ],
      ),
    );
  }
}
