import 'package:flutter/material.dart';
import 'package:mukawwin_3/APIservice/Firebase/Auth.dart';
import 'package:mukawwin_3/Widget/mybottombar.dart';
import 'package:mukawwin_3/screens/account.dart';

// ignore: must_be_immutable
class Myappbar extends StatelessWidget {
  late String? title;
  late IconData? exit;
  late IconData? back;
  Myappbar({super.key, this.title, this.exit, this.back});
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("images/6.png"),
        exit != null
            ? Positioned(
                top: 30,
                left: 5,
                child: IconButton(
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
                    exit,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            : const Text(""),
        Positioned(
          left: 15.0,
          bottom: 5.0,
          child: Text(
            title == null ? '' : title!,
            style: const TextStyle(
                fontSize: 25.0,
                fontFamily: 'Lato',
                color: Color(0xFF4B7e80),
                fontWeight: FontWeight.bold),
          ),
        ),
        back != null
            ? Positioned(
                bottom: 5,
                left: 5,
                child: IconButton(
                  onPressed: () {
                    isload = false;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Account(),
                      ),
                    );
                  },
                  icon: Icon(
                    back,
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
