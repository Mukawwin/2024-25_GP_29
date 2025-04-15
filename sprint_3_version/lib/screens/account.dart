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
  UserModel? userModel;
  bool isloading = true;
  AuthService authService = AuthService();
  getData() async {
    isloading = true;
    await authService.getUserData().then((value) => userModel = value);
    setState(() {
      isloading = false;
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
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Myappbar(
            show: false,
            exit: Icons.exit_to_app,
            title: "Welcome ${isloading ? "" : userModel!.username}",
          ),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Text(
                                    userModel!.username,
                                    style: const TextStyle(
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
                                        color: Color(0xFF4A9A9B),
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
          const Mybottombar(),
        ],
      ),
    );
  }
}
