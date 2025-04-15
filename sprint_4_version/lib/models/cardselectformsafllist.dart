import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/screens/selectforsafelist.dart';

// import 'package:table_calendar/table_calendar.dart';
class Cardselectformsafllist extends StatefulWidget {
  final String title;
  final String image;
  final String path;
  const Cardselectformsafllist(
      {super.key,
      required this.title,
      required this.image,
      required this.path});

  @override
  State<Cardselectformsafllist> createState() => _CardselectformsafllistState();
}

class _CardselectformsafllistState extends State<Cardselectformsafllist> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  DateTime? date;
  bool check = false;

  void showdialog(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // استخدام StatefulBuilder
            return Center(
              child: SizedBox(
                height: screenHeight / 1.5,
                child: AlertDialog(
                  title: Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          date = null;
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: screenWidth / 6,
                      ),
                    ),
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: screenWidth / 6,
                        color: const Color(0xFF4B7e80),
                      ),
                      Text(
                        "Add expiration date reminder for :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 25,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth / 15,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2200),
                          );

                          if (newDate != null) {
                            setStateDialog(() {
                              // تحديث الحالة داخل StatefulBuilder
                              date = newDate;
                            });
                          }
                        },
                        child: const Text(
                          'Select a date',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      date != null
                          ? Text('${date!.year}/${date!.month}/${date!.day}')
                          : const Text(''),
                    ],
                  ),
                  actions: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color(0xFF4B7e80),
                        ),
                        child: InkWell(
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 7.5,
                                  bottom: 7.5),
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onTap: () async {
                              if (date != null) {
                                QuerySnapshot querySnapshot = await firestore
                                    .collection(
                                        'savelist${_auth.currentUser!.uid}')
                                    .where('path', isEqualTo: widget.path)
                                    .get();

                                // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
                                for (var doc in querySnapshot.docs) {
                                  await firestore
                                      .collection(
                                          'savelist${_auth.currentUser!.uid}')
                                      .doc(doc.id)
                                      .update({
                                    'date': Timestamp.fromDate(date!),
                                    // 'image': downloadURL,
                                    // 'path': Path.basename(imagefile!.path),
                                  });
                                }

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Selectforsafelist()),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                print('++++++++++++++++++++++++++++++');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Enter The Expiration Date Please'),
                                  ),
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showdialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.black, width: 1),
            color: Colors.grey[200],
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 75, // عرض الحاوية
                height: 75, // ارتفاع الحاوية
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0), // حواف منحنية
                ),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 15.0, top: 5.0, bottom: 2.0),
              child: SizedBox(
                width: 100,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
