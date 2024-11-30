import 'package:flutter/material.dart';
import 'package:mukawwin_3/Widget/alertlist.dart';
import 'package:mukawwin_3/Widget/myappbar.dart';
import 'package:mukawwin_3/Widget/mybottombar.dart';

class Check extends StatelessWidget {
  const Check({super.key, required this.select, required this.allergies});
  final int select;
  final List<String> allergies;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Myappbar(),
          // allalert[select],
          returAlert(select, allergies),
          const Mybottombar(),
        ],
      ),
    );
  }
}
