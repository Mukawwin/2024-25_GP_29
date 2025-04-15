import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mukawwin_3/screens/incidentedit.dart';
import 'package:mukawwin_3/screens/incidentloglist.dart';

class Incidentlogcard extends StatefulWidget {
  final String image;
  final String title;
  final DateTime date;
  final String description;
  final String path;
  const Incidentlogcard(
      {super.key,
      required this.image,
      required this.title,
      required this.date,
      required this.description,
      required this.path});

  @override
  State<Incidentlogcard> createState() => _IncidentlogcardState();
}

class _IncidentlogcardState extends State<Incidentlogcard> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<int, String> mymonth = {
    1: 'Sat',
    2: 'Sun',
    3: 'Mon',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

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
                    "Delete a product ",
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
                          //تنفيذ عملية الحذف

                          deleteImage(widget.path);
                          deletsafedoc(widget.path);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const Incidentloglist(),
                          ));
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

  Future<void> deletsafedoc(String valueToSearch) async {
    // الخطوة 1: إنشاء استعلام للبحث عن الوثيقة
    QuerySnapshot querySnapshot = await firestore
        .collection('incidents${_auth.currentUser!.uid}')
        .where('path', isEqualTo: valueToSearch)
        .get();

    // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    for (var doc in querySnapshot.docs) {
      await firestore
          .collection('incidents${_auth.currentUser!.uid}')
          .doc(doc.id)
          .delete();
    }
    print("تم حذف المستند بنجاح");
  }

  Future<void> deleteImage(String filePath) async {
    try {
      // قم بالإشارة إلى الملف باستخدام المسار
      Reference ref = _storage.ref('incidents/$filePath');

      // احذف الملف
      await ref.delete();

      print('تم حذف الصورة بنجاح');
    } catch (e) {
      print('حدث خطأ أثناء حذف الصورة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
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
                widget.image,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                      child: Text(
                    '${widget.description} ',
                    style: const TextStyle(color: Colors.black),
                  )),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => Incidentedit(
                                title: widget.title,
                                details: widget.description,
                                date: widget.date,
                                image: widget.image,
                                path: widget.path,
                              ),
                            ));
                          },
                          icon: const Icon(
                            Icons.note_alt_outlined,
                            size: 40.0,
                            color: Color(0xFF4B7e80),
                          )),
                      IconButton(
                          onPressed: () async {
                            showdialog(context);
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 40.0,
                            color: Colors.red,
                          )),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.date_range_outlined),
                  FittedBox(
                      child: Text(
                    '${DateFormat('EEE').format(widget.date)} ${widget.date.day} ${mymonth[widget.date.month]} ${widget.date.year}',
                    style: const TextStyle(color: Colors.black),
                  )),
                  const Icon(Icons.timer),
                  FittedBox(
                      child:
                          Text('${DateFormat('hh:mm a').format(widget.date)} ')
                      // '${widget.expirationdate.year}/${widget.expirationdate.month}/${widget.expirationdate.day}'),
                      )
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}
