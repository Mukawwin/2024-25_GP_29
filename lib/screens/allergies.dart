import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mukawwin_3/APIservice/Firebase/Auth.dart';
import 'package:mukawwin_3/APIservice/Firebase/database.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';
import 'package:mukawwin_3/Widget/myallergies.dart';
import 'package:mukawwin_3/Widget/progressBar.dart';
import 'package:mukawwin_3/Widget/myappbar.dart';

class Allergies extends StatefulWidget {
  final bool showProgressBar;
  const Allergies({super.key, required this.showProgressBar});

  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {
  final AuthService _authService = AuthService();
  bool showAlert = false;
  DatabaseService service = DatabaseService();

  bool isloading = false;
  List<AllergyModel> allAllergies = [];

  getData() async {
    setState(() {
      isloading = true;
    });
    await service.getAllergies().then((value) {
      allAllergies = value;
    });
    print(allAllergies.length);
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Myappbar(),
          if (widget.showProgressBar) const ProgressBar(currentStep: 2),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'Select your allergies',
                style: TextStyle(
                    color: Color(0xFF4B7e80),
                    fontFamily: 'Lato',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (showAlert)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Please select at least one allergy !",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(
            child: AnimationLimiter(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150.0,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 1,
                ),
                itemCount: allAllergies.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    columnCount: 3,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: Myallergies(allergyModel: allAllergies[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(30.0), 
              child: InkWell(
                onTap: () async {
                  await _authService.checkUseSetAllergies().then((onValue) {
                    if (onValue) {
                      if (widget.showProgressBar) {
                        popupcomplete();
                      } else {
                        Navigator.of(context).pushReplacementNamed("account");
                      }
                    } else {
                      setState(() {
                        showAlert =
                            true; // Set showAlert to true when no allergy is selected
                      });
                    }
                  });
                },
                child: Container(
                  width: 135.0,
                  height: 45.0,
                  color: const Color(0xFF4B7e80),
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'lato',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void popupcomplete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 16),
              Text(
                "Welcome!",
                style: TextStyle(
                  fontFamily: 'lato',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF387F7F),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "You have successfully completed your registration!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'lato',
                  fontSize: 18,
                  color: Color(0xFF4B7e80),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, 'account');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B7e80),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'lato',
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
