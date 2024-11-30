import 'package:flutter/material.dart';
import 'package:mukawwin_3/APIservice/Firebase/Auth.dart';

// ignore: must_be_immutable
class Welcome extends StatelessWidget {
  Welcome({super.key});
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xff387f7f),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
                child: Image.asset(
              "images/0.png",
            )),
          ),
          Positioned(
              right: 10,
              bottom: 100,
              child: IconButton(
                  onPressed: () async {
                    await authService.checkWelcomNavigate(context);
                  },
                  icon: const Icon(
                    Icons.navigate_next_outlined,
                    color: Colors.white,
                    size: 50,
                  ))),
        ],
      ),
    );
  }
}
