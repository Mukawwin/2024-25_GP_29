import 'package:flutter/material.dart';

class Mybottombar extends StatefulWidget {
  const Mybottombar({super.key});

  @override
  State<Mybottombar> createState() => _MybottombarState();
}

class _MybottombarState extends State<Mybottombar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 40.0,
            ),
            Container(
              height: 100.0,
              decoration: const BoxDecoration(
                color: Color(0xFF4B7e80),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            //AT SPRINT 2
                          },
                          icon: Image.asset(
                            "icons/list.png",
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),
                        const Text(
                          "Lists",
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15.0,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'account');
                          },
                          icon: Image.asset(
                            "icons/profile.png",
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),
                        const Text(
                          "Account",
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15.0,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: CircleAvatar(
            radius: 60.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50.0,
              backgroundColor: const Color(0xFF4B7e80),
              child: IconButton(
                onPressed: () {
                  //AT SPRINT 2
                },
                icon: Image.asset(
                  "icons/scan.png",
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
