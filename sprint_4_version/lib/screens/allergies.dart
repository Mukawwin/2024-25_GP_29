import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mukawwin_3/Firebase/Auth.dart';
import 'package:mukawwin_3/list/listallergies.dart';
import 'package:mukawwin_3/models/progressBar.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/screens/select_icon.dart';

// ignore: must_be_immutable
class Allergies extends StatefulWidget {
  late bool? showback;
  final bool showProgressBar;
  late String? name;
  late bool? female;
  late bool? male;
  late String? uid;
  late bool? backicon;
  Allergies({
    super.key,
    required this.showProgressBar,
    this.backicon,
    this.showback,
    this.name,
    this.male,
    this.uid,
    this.female,
  });

  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {
  final AuthService _authService = AuthService();
  bool showAlert = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          widget.backicon == true
              ? Myappbar(
                  menu: true,
                  backfromallergiestohomepage: Icons.arrow_back,
                  show: false,
                )
              : Myappbar(
                  menu: true,
                  show: false,
                ),
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
                itemCount: myalleries.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    columnCount: 3,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: myalleries[index],
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
                    BorderRadius.circular(30.0), // ضبط قيمة الانحناء حسب الحاجة
                child: InkWell(
                  onTap: () async {
                    await _authService
                        .checkAllergies(widget.name!)
                        .then((onValue) {
                      if (onValue) {
                        if (widget.showProgressBar) {
                          popupcomplete();
                        } else {
                          if (widget.showback == null) {
                            if (widget.male == null && widget.female == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectIcon(
                                    editable: true,
                                    // docid: widget.uid!,
                                    name: widget.name,
                                    male: false,
                                    female: false,
                                  ),
                                ),
                              );
                            } else if (widget.male!) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectIcon(
                                    editable: true,
                                    // docid: widget.uid!,
                                    name: widget.name,
                                    male: true,
                                    female: false,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectIcon(
                                    editable: true,
                                    // docid: widget.uid!,
                                    name: widget.name,
                                    female: true,
                                    male: false,
                                  ),
                                ),
                              );
                            }
                          } else {
                            Navigator.of(context)
                                .pushReplacementNamed("homepage");
                          }
                        }
                      } else {
                        setState(() {
                          showAlert =
                              true; // Set showAlert to true when no allergy is selected
                        });
                      }
                    });
                    if (checking = true) {
                      checking = false;
                    }
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
                )),
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
