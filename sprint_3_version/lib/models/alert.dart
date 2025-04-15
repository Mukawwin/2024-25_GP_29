import 'package:flutter/material.dart';
import 'package:mukawwin_3/models/mybottombar.dart';
import 'package:mukawwin_3/screens/account.dart';
import 'package:mukawwin_3/screens/addToSafeList.dart';

// ignore: must_be_immutable
class Alert extends StatelessWidget {
  final bool button;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final bool checkallregies;
  late List<String>? allergies = [];
  late String? onebutton;
  late String? towbutton1;
  late String? towbutton2;

  Alert({
    super.key,
    required this.checkallregies,
    required this.button,
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    this.allergies,
    this.onebutton,
    this.towbutton1,
    this.towbutton2,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), // لون الظل مع شفافية
              spreadRadius: 0, // مدى انتشار الظل
              blurRadius: 10.0, // مدى ضبابية الظل
              offset: const Offset(9, 9),
            )
          ],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 70.0,
              color: color,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 40.0,
              indent: 50.0,
              endIndent: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
              child: Text(
                desc,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Lato',
                  color: Color(0xFF000000),
                ),
              ),
            ),
            checkallregies == true
                ? Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: allergies!.length,
                        itemBuilder: (context, index) {
                          return Text(
                            '  ${allergies![index]} ,',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Lato',
                              color: Color.fromARGB(255, 212, 26, 13),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 10.0,
                  ),
            button == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          isload = false;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Account(),
                            ),
                          );
                        },
                        child: Text(
                          towbutton1!,
                          style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Lato',
                              color: Color(0xFF4ECDC4),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Addtosafelist(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 70.0,
                          child: Text(
                            towbutton2!,
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Lato',
                                color: Color(0xFF4ECDC4),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: TextButton(
                        onPressed: () {
                          isload = false;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Account(),
                            ),
                          );
                        },
                        child: Text(
                          onebutton!,
                          style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Lato',
                              color: Color(0xFF4ECDC4),
                              fontWeight: FontWeight.bold),
                        )),
                  ),
          ],
        ),
      ),
    ));
  }
}

// const Color(0xff4B7E80),
