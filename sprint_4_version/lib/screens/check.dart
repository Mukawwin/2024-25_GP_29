import 'package:flutter/material.dart';
import 'package:mukawwin_3/models/alertlist.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/models/mybottombar.dart';

class Check extends StatelessWidget {
  final int select;
  const Check({super.key, required this.select});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Myappbar(
            show: false,
          ),
          allalert[select],
          const Mybottombar(),
        ],
      ),
    );
  }
}
