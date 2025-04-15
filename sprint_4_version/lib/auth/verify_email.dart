import 'package:flutter/material.dart';

import 'package:mukawwin_3/models/myappbar.dart';

class Email_Verify extends StatelessWidget {
  const Email_Verify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Myappbar(
            show: true,
          ),
          const SizedBox(
            height: 100,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 50), // Only vertical padding now
            margin: const EdgeInsets.symmetric(
                horizontal: 20), // Adjust left/right space
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(30.0), // Rounded corners for the box
              border: Border.all(
                  color: const Color.fromARGB(255, 220, 217, 217), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 7,
                  blurRadius:
                      40, // Increased blur for a more "popup-like" effect
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize
                  .min, // Ensures the box only takes the needed height
              children: [
                Icon(
                  Icons.email,
                  color: Color(0xFF387F7F), // Match the theme color
                  size: 50, // Adjust icon size
                ),
                SizedBox(height: 16), // Space between the icon and the text
                Text(
                  "Just sent you a verification email !",
                  style: TextStyle(
                    fontFamily: 'Lato', // Matching font family
                    fontSize: 22, // Adjusted size to be slightly smaller
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
                horizontal: 80, vertical: 7), // Same padding as CustomButton
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Matching border radius
            ),
            color: const Color(0xff387f7f), // Matching button color
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("signin");
            },
            child: const Text(
              "OK",
              style: TextStyle(
                fontSize: 20, // Matching text size
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
