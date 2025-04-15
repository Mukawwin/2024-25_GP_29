import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mukawwin_3/auth/resetpassword.dart';
import 'package:mukawwin_3/auth/signin.dart';
import 'package:mukawwin_3/auth/signup.dart';
import 'package:mukawwin_3/auth/verify_email.dart';
import 'package:mukawwin_3/auth/welcom.dart';
import 'package:mukawwin_3/screens/account.dart';
import 'package:mukawwin_3/screens/allergies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mukawwin_3/screens/help.dart';
import 'package:mukawwin_3/screens/homepage.dart';
import 'firebase_options.dart';
import 'methods/alarm_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeNotifications();
  tz.initializeTimeZones();
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
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Schyler',
      ),
      debugShowCheckedModeBanner: false,
      home: Welcome(),
      routes: {
        'allergies': (context) => Allergies(
              showProgressBar: true,
            ),
        'account': (context) => const Account(),
        'help': (context) => Help(),
        "signin": (context) => const SignIn(),
        "signup": (context) => const SignUp(),
        "verify": (context) => const Email_Verify(),
        "homepage": (context) => const Homepage(),
        "resetpassword": (context) => const ResetPassWord(),
      },
    );
  }
}
