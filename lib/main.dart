import 'package:flutter/material.dart';
import 'package:mukawwin_3/auth/resetpassword.dart';
import 'package:mukawwin_3/auth/signin.dart';
import 'package:mukawwin_3/auth/signup.dart';
import 'package:mukawwin_3/auth/verify_email.dart';
import 'package:mukawwin_3/auth/welcom.dart';
import 'package:mukawwin_3/screens/account.dart';
import 'package:mukawwin_3/screens/allergies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
      routes: {
        'allergies': (context) => const Allergies(
              showProgressBar: true,
            ),
        'account': (context) => const Account(),
        "signin": (context) => const SignIn(),
        "signup": (context) => const SignUp(),
        "verify": (context) => const Email_Verify(),
        "resetpassword": (context) => const ResetPassWord(),
      },
    );
  }
}
