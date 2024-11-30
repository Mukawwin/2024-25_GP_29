
import 'package:flutter/material.dart';
import 'package:mukawwin_3/APIservice/Firebase/Auth.dart';
import 'package:mukawwin_3/auth/resetpassword.dart';
import 'package:mukawwin_3/Widget/customtextfield.dart';
import 'package:mukawwin_3/Widget/myappbar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
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
              const Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff387f7f),
                ),
              ),
              const SizedBox(height: 30),
              Custom_TextField(
                hinttext: "Email",
                icon: Icons.email_outlined,
                mycontroller: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
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
                    return "password must be at least 6 characters long";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ResetPassWord(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forget password?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xff387f7f)),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                  buttonname: 'Sign in',
                  onPressed: () async {
                    var formdata = formstate.currentState;
                    if (formdata!.validate()) {
                      print(email.text);
                      print("++++++++++++++++++++++++++=");
                      await authService.signInWithEmailPassword(
                          email: email.text,
                          password: password.text,
                          context: context);
                    }
                  }),
              const SizedBox(height: 25),
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
              const SizedBox(height: 30),
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
                        "      Sign in with Google",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?      "),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("signup");
                    },
                    child: const Text(
                      "Sign up now",
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
