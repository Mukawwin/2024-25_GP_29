import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/customtextfield.dart';
import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/screens/homepage.dart';
import 'package:mukawwin_3/screens/savelist.dart';
import 'package:permission_handler/permission_handler.dart';
import '../methods/alarm_service.dart';
import '../models/mybottombar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class Addtosafelist extends StatefulWidget {
  const Addtosafelist({super.key});

  @override
  State<Addtosafelist> createState() => _HomepageState();
}

class _HomepageState extends State<Addtosafelist> {
  TextEditingController productname = TextEditingController();
  TextEditingController exdate = TextEditingController();
  TextEditingController befor = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool value = false;
  File? imagefile;
  final picker = ImagePicker();
  String? downloadURL;
  bool wait = false;
  DateTime? date;
  DateTime dateNow = DateTime.now();
  UserDetails? userDetails;

  void getUser() async {
    DatabaseService databaseService = DatabaseService();
    try {
      // جلب الحساسيات
      List<UserDetails> users = await databaseService.getuserdetails();

      // طباعة البيانات في الـ Console
      if (users.isEmpty) {
        print('No allergies found for this user.');
      } else {
        print('User Allergies:');
        for (var user in users) {
          userDetails = user;
          // print('Allergy: ${allergy.allergie}, ID: ${allergy.id}');
        }
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
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
                  Icon(Icons.warning_amber, size: 60.0, color: Colors.red),
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
                    "The product is expire : ",
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
                            left: 15.0,
                            right: 15.0,
                            top: 7.5,
                            bottom: 7.5,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            date = null;
                          });
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
                            left: 15.0,
                            right: 15.0,
                            top: 7.5,
                            bottom: 7.5,
                          ),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
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

  // checkdate(DateTime d1, DateTime d2) {
  //   if (d1.year > d2.year ||
  //       (d1.year == d2.year && d1.month > d2.month) ||
  //       (d1.year == d2.year && d1.month == d2.month && d1.day > d2.day)) {
  //     return;
  //   } else {
  //     return showdialog(context);
  //   }
  // }

  Future<void> uploadImage() async {
    if (imagefile == null) {
      print("Error: No image selected.");
      return;
    } else {
      print("image not empty");
    }
    var storage = FirebaseStorage.instance;
    final filePath = imagefile!.path;
    if (!File(filePath).existsSync()) {
      print("Error: File does not exist at path $filePath");
      return;
    }

    try {
      Reference storageReference = await storage.ref().child(
            'safe_list/${Path.basename(imagefile!.path)}',
          );
      print("******************1*****************");
      UploadTask uploadTask = storageReference.putFile(imagefile!);
      print("******************2*****************");

      // ignore: body_might_complete_normally_catch_error
      await uploadTask.catchError((e) {
        print("The error is $e");
      });
      print("******************3*****************");

      downloadURL = await storageReference.getDownloadURL();
      print("******************4*****************");

      // print('File Uploaded: $imageurl');
      print("Upload successful! File URL: $downloadURL");
    } on FirebaseException catch (e) {
      print("======================================");
      print(e);
      print("======================================");
      print("FirebaseException: ${e.message}");
    } catch (e) {
      print("Error: $e");
    }

    firestore.collection('savelist${_auth.currentUser!.uid}').add({
      'path': 'safe_list/${Path.basename(imagefile!.path)}',
      'title': productname.text,
      'image': downloadURL,
      'uid': _auth.currentUser!.uid,
      'name': userDetails!.username,
    });
    if (date != null) {
      QuerySnapshot querySnapshot = await firestore
          .collection('savelist${_auth.currentUser!.uid}')
          .where(
            'path',
            isEqualTo: 'safe_list/${Path.basename(imagefile!.path)}',
          )
          .get();

      // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
      for (var doc in querySnapshot.docs) {
        await firestore
            .collection('savelist${_auth.currentUser!.uid}')
            .doc(doc.id)
            .update({'date': Timestamp.fromDate(date!)});
      }
    }
  }

  _imgFromCamera() async {
    print("helllllllllllllllowwwwwwwwww");
    await picker
        .pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    ) // استدعاء مكتبة image picker
        .then((value) {
      if (value != null) {
        _cropImage(
          File(value.path),
        ); // استدعاء تابع قص الصور مع تمرير الصورة ك ملف للمعالجة
      } else {
        setState(() {
          isload = false;
        });
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      //   فتح واجهة قص الصورة
      sourcePath: imgFile.path,
      uiSettings: [
        //    إعدادات واجهة المستخدم
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      imageCache.clear(); // مسح ذاكرة التخزين المؤقت
      setState(() {
        imagefile = File(croppedFile.path); // حفظ ملف الصورة الجديدة بعد القص
      });
      print(
        "+=======================================================$imagefile",
      );
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: wait == false
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Myappbar(
                    show: false,
                    back: Icons.arrow_back,
                    savelist: true,
                  ),
                  const Text(
                    'Save product',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 5.0, indent: 100.0, endIndent: 100.0),
                  imagefile != null
                      ? Column(
                          children: [
                            Center(
                              child: Container(
                                width: 150.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                ),
                                child: Image.file(
                                  imagefile!,
                                  height: 300,
                                  width: 300,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  imagefile = null;
                                });
                              },
                              icon: const Icon(Icons.cancel),
                            ),
                          ],
                        )
                      : IconButton(
                          onPressed: () async {
                            Map<Permission, PermissionStatus> statuses =
                                await [Permission.camera].request();
                            if (statuses[Permission.camera]!.isGranted) {
                              _imgFromCamera();

                              print("================$imagefile=============");
                            }
                          },
                          icon: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Color(0xff4ecdc4),
                            size: 100.0,
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  Custom_TextField(
                    icon: Icons.production_quantity_limits_outlined,
                    hinttext: "product name",
                    mycontroller: productname,
                  ),
                  const SizedBox(height: 10.0),
                  const Center(
                    child: Text(
                      'Add expiration date reminder',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 50.0,
                          height: 30.0,
                          child: Transform.scale(
                            scale: 1.5,
                            child: Switch(
                              value: value,
                              onChanged: (newValue) {
                                setState(() {
                                  value = newValue;
                                  print(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      value == true
                          ? Column(
                              children: [
                                date == null
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          DateTime? newDate =
                                              await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2200),
                                          );

                                          if (newDate == null) {
                                            return;
                                          } else {
                                            print('find new date ++++++++');
                                            setState(() {
                                              date = newDate;
                                            });
                                            // checkdate(date!, dateNow);
                                          }
                                        },
                                        child: const Text(
                                          'Select a date',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 50.0,
                                        width: 200.0,
                                        // color: Colors.amber,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              '\t${date!.day}/${date!.month}/${date!.year}',
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  date = null;
                                                });
                                              },
                                              icon: const Icon(Icons.cancel),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (imagefile == null || productname.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please enter the name and image of the product",
                            ),
                            duration: Duration(seconds: 3), // مدة العرض
                          ),
                        );
                      } else {
                        if (value) {
                          if (date != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a date first"),
                                duration: Duration(seconds: 3), // مدة العرض
                              ),
                            );
                          } else {
                            DateTime alarmTime = date!.subtract(
                              Duration(days: 5),
                            );
                            await scheduleAlarm(
                              alarmTime,
                              title: "Warning",
                              body:
                                  "The product '${productname.text}' will expire in 5 days",
                            );

                            await scheduleAlarm(
                              date!,
                              title: "Warning",
                              body:
                                  "The product '${productname.text}' has expired",
                            );
                          }
                        }

                        setState(() {
                          wait = true;
                        });
                        await uploadImage();
                        // For example:

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Savelist(),
                          ),
                        );
                      }
                    },
                    buttonname: "Save",
                  ),

                  // const Mybottombar(),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
