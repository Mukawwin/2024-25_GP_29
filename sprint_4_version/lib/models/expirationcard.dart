import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/screens/expirationlist.dart';

class Expirationcard extends StatefulWidget {
  final String title;
  final String img;
  final DateTime expirationdate;
  const Expirationcard(
      {super.key,
      required this.title,
      required this.img,
      required this.expirationdate});

  @override
  State<Expirationcard> createState() => _ExpirationcardState();
}

class _ExpirationcardState extends State<Expirationcard> {
  Color color = Colors.black;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  DateTime? date;
  int? counter;

  Future<void> deleteField(String val) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('savelist${_auth.currentUser!.uid}')
          .where('image', isEqualTo: val)
          .get();

      // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
      for (var doc in querySnapshot.docs) {
        await firestore
            .collection('savelist${_auth.currentUser!.uid}')
            .doc(doc.id)
            .update({
          'date': FieldValue.delete(),
        });
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Expirationlist()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Error deleting field: $e');
    }
  }

  int remaindays(DateTime expirationdate) {
    int days = 0;
    days = expirationdate.difference(DateTime.now()).inDays;
    if (days < 0) {
      days = 0;
    }
    if (days == 0) {
      setState(() {
        color = Colors.red;
      });
    } else if (days <= 10) {
      color = const Color.fromARGB(255, 197, 182, 46);
    } else {
      color = Colors.green;
    }
    // days=((expirationdate.year - DateTime.now().year)*265)+((expirationdate.month));

    return days;
  }

  Future<void> updateDocument(String valueToSearch, DateTime newValue) async {
    // الخطوة 1: إنشاء استعلام للبحث عن الوثيقة
    QuerySnapshot querySnapshot = await firestore
        .collection('savelist${_auth.currentUser!.uid}')
        .where('path', isEqualTo: valueToSearch)
        .get();

    // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    for (var doc in querySnapshot.docs) {
      await firestore
          .collection('savelist${_auth.currentUser!.uid}')
          .doc(doc.id)
          .update({
        'date': newValue,
      });
    }
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.docid)
    //     .update({
    //   'username': newValue,
    // });
    // setState(() {
    //   changename = false;
    //   wait = false;
    //   getData();
    // });
  }

  void showdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            height: 350.0,
            child: AlertDialog(
              title: const Column(
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: 60.0,
                    color: Colors.red,
                  ),
                  Text(
                    "Are you sure!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
              content: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Delete a product form expiration list",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red,
                      ),
                      child: InkWell(
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          print('تم اختيار إلغاء');
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFF4B7e80),
                      ),
                      child: InkWell(
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          deleteField(widget.img);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showupdate(BuildContext context) {
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
                        "Edit expiration date reminder for :",
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
                                    .where('image', isEqualTo: widget.img)
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

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const Expirationlist()),
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
  void initState() {
    date = widget.expirationdate;
    counter = remaindays(widget.expirationdate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: color == Colors.red ? color : Colors.black, width: 1),
          color: Colors.grey[200],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 75, // عرض الحاوية
              height: 75, // ارتفاع الحاوية
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // حواف منحنية
              ),
              child: Image.network(
                widget.img,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            children: [
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
              Row(
                children: [
                  const Icon(Icons.timer),
                  FittedBox(
                      child: Text(
                    '$counter Days',
                    style: TextStyle(color: color),
                  ))
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  FittedBox(
                    child: Text(
                        '${widget.expirationdate.year}/${widget.expirationdate.month}/${widget.expirationdate.day}'),
                  )
                ],
              )
            ],
          ),
          IconButton(
              onPressed: () async {
                showdialog(context);
              },
              icon: const Icon(
                Icons.delete,
                size: 40.0,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {
                showupdate(context);
              },
              icon: const Icon(
                Icons.note_alt_outlined,
                size: 40.0,
                color: Color(0xFF4B7e80),
              )),
        ]),
      ),
    );
  }
}
