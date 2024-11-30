// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mukawwin_3/APIservice/Firebase/Auth.dart';
import 'package:mukawwin_3/Widget/customtextfield.dart';
import 'package:mukawwin_3/Widget/myappbar.dart';
import 'package:mukawwin_3/Widget/progressBar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formstate,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Myappbar(),
              const SizedBox(
                height: 10,
              ),
              const ProgressBar(currentStep: 1),
              const Text(
                "Sign up",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff387f7f)),
              ),
              const SizedBox(
                height: 10,
              ),
              Custom_TextField(
                hinttext: "Name",
                icon: Icons.person_rounded,
                mycontroller: username,
                validator: (value) {
                  if (value!.length < 4) {
                    return "Name must be at least 4 characters long";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Custom_TextField(
                hinttext: "Email",
                icon: Icons.email_outlined,
                mycontroller: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Regular expression for email validation
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Custom_TextField(
                hinttext: "Password",
                icon: Icons.lock_open,
                mycontroller: password,
                obscure: true,
                validator: (value) {
                  if (value!.length < 6) {
                    return "Password must be at least 6 characters ";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              CustomButton(
                buttonname: 'Sign up',
                onPressed: () async {
                  var formdata = formstate.currentState;
                  if (formdata!.validate()) {
                    print(email.text);
                    print("++++++++++++++++++++++++++=");
                    await authService.signUpWithEmailPassword(
                        email: email.text,
                        password: password.text,
                        username: username.text,
                        context: context);
                  }
                },
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  const Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Divider(
                        color: Colors.black,
                        height: 5,
                      )),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 120,
                      color: Colors.white,
                      child: const Text(
                        "Or",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () async {
                  await authService.signUpWithGoogle(context);
                },
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: const Border(
                      right: BorderSide(
                          color: Color.fromARGB(255, 100, 98, 98), width: 2),
                      left: BorderSide(
                          color: Color.fromARGB(255, 100, 98, 98), width: 2),
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/9.png",
                        height: 30,
                        width: 30,
                      ),
                      const Text(
                        "      Sign up with Google",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?      "),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sign in now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff387f7f)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
