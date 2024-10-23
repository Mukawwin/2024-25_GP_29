import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep; 

  const ProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        
        Column(
          children: [
            GestureDetector(
              onTap: () {
                if (currentStep == 2) {
                  Navigator.of(context).pushReplacementNamed("signup");
                } 
              },
              child: CircleAvatar(
                radius: 18, 
                backgroundColor:
                    currentStep >= 1 ? const Color(0xff387f7f) : Colors.grey,
                child: currentStep >= 2
                    ? const Icon(Icons.check,
                        color: Colors.white,
                        size: 18) 
                    : const Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Account Setup',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),

        Expanded(
          child: Divider(
            thickness: 2,
            color: currentStep >= 2 ? const Color(0xff387f7f) : Colors.grey,
          ),
        ),

        
        Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: currentStep == 2
                  ? const Color(0xff387f7f)
                  : Colors.grey, 
              child: const Text(
                '2',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text(
                'Select Allergies',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}