import 'package:flutter/material.dart';
import 'package:mukawwin_3/Widget/myappbar.dart';

class Email_Verify extends StatelessWidget {
  const Email_Verify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Myappbar(),
          const SizedBox(
            height: 100,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 50), 
            margin: const EdgeInsets.symmetric(
                horizontal: 20), 
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(30.0), 
              border: Border.all(
                  color: const Color.fromARGB(255, 220, 217, 217), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 7,
                  blurRadius:
                      40, 
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize
                  .min, 
              children: [
                Icon(
                  Icons.email,
                  color: Color(0xFF387F7F), 
                  size: 50, 
                ),
                SizedBox(height: 16), 
                Text(
                  "Just sent you a verification email !",
                  style: TextStyle(
                    fontFamily: 'Lato', 
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF387F7F),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Click the link, and we'll take you to the sign in page.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18,
                    color: Color(0xFF4B7e80),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            padding: const EdgeInsets.symmetric(
                horizontal: 80, vertical: 7), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), 
            ),
            color: const Color(0xff387f7f), 
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("signin");
            },
            child: const Text(
              "OK",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
