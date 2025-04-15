import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/screens/edit.dart';
import 'package:mukawwin_3/screens/savelist.dart';

class Mycard extends StatefulWidget {
  final String img;
  final String title;
  final String exdate;
  final String path;
  final String docid;
  const Mycard({
    super.key,
    required this.img,
    required this.title,
    required this.exdate,
    required this.path,
    required this.docid,
  });

  @override
  State<Mycard> createState() => _MycardState();
}

class _MycardState extends State<Mycard> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> deletsafedoc(String valueToSearch) async {
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
          .delete();
    }
    print("تم حذف المستند بنجاح");
  }

  // Future<void> DeleteDocs(String docsid) async {
  //   await FirebaseFirestore.instance
  //       .collection("savelist")
  //       .doc(docsid)
  //       .delete();
  //   print("تم حذف المستند بنجاح");
  // }

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
                            builder: (context) => Savelist(),
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

  Future<void> deleteImage(String filePath) async {
    try {
      // قم بالإشارة إلى الملف باستخدام المسار
      Reference ref = _storage.ref('safe_list/$filePath');

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
          // border: Border.all(color: Colors.black, width: 1),
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
                      fontFamily: 'Lato'),
                ),
              ),
            ),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Edit(
                        path: widget.path,
                        image: widget.img,
                        title: widget.title,
                        docid: widget.docid),
                  ),
                );
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
