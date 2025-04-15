import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/customtextfield.dart';
import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/models/mybottombar.dart';
import 'package:mukawwin_3/screens/incidentloglist.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as Path;

class Incidentedit extends StatefulWidget {
  final String title;
  final String details;
  final DateTime date;
  final String image;
  final String path;
  const Incidentedit(
      {super.key,
      required this.title,
      required this.details,
      required this.date,
      required this.image,
      required this.path});

  @override
  State<Incidentedit> createState() => _IncidenteditState();
}

class _IncidenteditState extends State<Incidentedit> {
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  TimeOfDay? _selectedTime;
  DateTime? date;
  UserDetails? userDetails;
  final picker = ImagePicker();
  File? imagefile;
  String? downloadURL;
  bool show = true;
  bool wait = false;

  Future<void> uploadImage() async {
    if (imagefile == null) {
      print("Error: No image selected.");
      return;
    } else {
      print("image not empty");
      await deleteImage(widget.path);
    }
    var storage = FirebaseStorage.instance;
    final filePath = imagefile!.path;
    if (!File(filePath).existsSync()) {
      print("Error: File does not exist at path $filePath");
      return;
    }

    try {
      Reference storageReference = await storage
          .ref()
          .child('incidents/${Path.basename(imagefile!.path)}');
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

    QuerySnapshot querySnapshot = await firestore
        .collection('incidents${_auth.currentUser!.uid}')
        .where('path', isEqualTo: widget.path)
        .get();

    // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    for (var doc in querySnapshot.docs) {
      await firestore
          .collection('incidents${_auth.currentUser!.uid}')
          .doc(doc.id)
          .update({
        'image': downloadURL,
        'path': Path.basename(imagefile!.path),
      });
    }

    print('Document updated successfully!');
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
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

  void getUser() async {
    DatabaseService databaseService = DatabaseService();
    try {
      List<UserDetails> users = await databaseService.getuserdetails();

      if (users.isEmpty) {
        print('No allergies found for this user.');
      } else {
        print('User Allergies:');
        for (var user in users) {
          userDetails = user;
        }
        // getsavelist();
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  _imgFromCamera() async {
    print("helllllllllllllllowwwwwwwwww");
    await picker
        .pickImage(
            source: ImageSource.camera,
            imageQuality: 50) // استدعاء مكتبة image picker
        .then((value) {
      if (value != null) {
        _cropImage(File(value
            .path)); // استدعاء تابع قص الصور مع تمرير الصورة ك ملف للمعالجة
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
          "+=======================================================$imagefile");
    }
  }

  @override
  void initState() {
    title.text = widget.title;
    desc.text = widget.details;
    date = widget.date;
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: wait == false
          ? SizedBox(
              height: screenHeight,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Myappbar(
                      title: 'Incident Log',
                      show: false,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Date & Time Of Incident',
                      style:
                          TextStyle(fontSize: 25.0, color: Color(0xFF4B7e80)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer),
                            TextButton(
                                onPressed: () {
                                  _pickTime();
                                },
                                child: _selectedTime == null
                                    ? Text('${date!.hour}:${date!.minute}')
                                    : Text(
                                        '${_selectedTime!.hour}:${_selectedTime!.minute}'))
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.date_range),
                            TextButton(
                                onPressed: () async {
                                  DateTime? newDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2200),
                                  );

                                  if (newDate != null) {
                                    setState(() {
                                      date = newDate;
                                    });
                                  }
                                },
                                child: date == null
                                    ? const Text('Enter the date')
                                    : Text(
                                        '${date!.year}/${date!.month}/${date!.day}')),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      endIndent: 20.0,
                      indent: 20.0,
                    ),
                    const Text(
                      ' Product Image',
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Color(0xFF4B7e80),
                          fontWeight: FontWeight.bold),
                    ),
                    imagefile == null
                        ? show == false
                            ? IconButton(
                                onPressed: () async {
                                  Map<Permission, PermissionStatus> statuses =
                                      await [Permission.camera].request();
                                  if (statuses[Permission.camera]!.isGranted) {
                                    _imgFromCamera();

                                    print(
                                        "================$imagefile=============");
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 100.0,
                                  color: Color(0xFF4B7e80),
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                      height: 150.0,
                                      width: 150.0,
                                      child: Image.network(widget.image)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          show = false;
                                        });
                                      },
                                      icon: const Icon(Icons.cancel))
                                ],
                              )
                        : Column(
                            children: [
                              Center(
                                child: Container(
                                  width: 150.0,
                                  height: 150.0,
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
                                  icon: const Icon(Icons.cancel))
                            ],
                          ),
                    Custom_TextField(
                        icon: Icons.title,
                        hinttext: 'Enter Product Name',
                        mycontroller: title),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Custom_TextField(
                        icon: Icons.details,
                        hinttext: 'Enter More Details',
                        mycontroller: desc),
                    CustomButton(
                        onPressed: () async {
                          if (date == null || title.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Enter Your Data Please'),
                              ),
                            );
                          } else {
                            if (_selectedTime != null) {
                              date = DateTime(
                                  date!.year,
                                  date!.month,
                                  date!.day,
                                  _selectedTime!.hour,
                                  _selectedTime!.minute);
                            }
                            setState(() {
                              wait = true;
                            });
                            await uploadImage();
                            QuerySnapshot querySnapshot = await firestore
                                .collection(
                                    'incidents${_auth.currentUser!.uid}')
                                .where('path', isEqualTo: widget.path)
                                .get();

                            // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
                            for (var doc in querySnapshot.docs) {
                              await firestore
                                  .collection(
                                      'incidents${_auth.currentUser!.uid}')
                                  .doc(doc.id)
                                  .update({
                                'title': title.text,
                                // 'image': downloadURL,
                                // 'path': 'incidents/${Path.basename(imagefile!.path)}',
                                'date': Timestamp.fromDate(date!),
                                'desc': desc.text,
                              });
                            }

                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const Incidentloglist(),
                            ));
                          }
                        },
                        buttonname: 'Save Changes'),
                    const Mybottombar(),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}







  // else {
                    //   if (title.text != '' && date != null) {
                    //     date = DateTime(date!.year, date!.month, date!.day,
                    //         _selectedTime!.hour, _selectedTime!.minute);
                    //     QuerySnapshot querySnapshot = await firestore
                    //         .collection('incidents${_auth.currentUser!.uid}')
                    //         .where('path', isEqualTo: widget.path)
                    //         .get();

                    //     // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
                    //     for (var doc in querySnapshot.docs) {
                    //       await firestore
                    //           .collection('incidents${_auth.currentUser!.uid}')
                    //           .doc(doc.id)
                    //           .update({
                    //         'title': title.text,
                    //         'date': Timestamp.fromDate(date!),
                    //         'desc': desc.text,
                    //       });
                    //     }
                    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //       builder: (context) => const Incidentloglist(),
                    //     ));
                    //   } else {
                    //     print("Error: No image selected.");
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('Enter Your Data Please'),
                    //       ),
                    //     );
                    //   }
                    // }





















// QuerySnapshot querySnapshot = await firestore
    //     .collection('incidents${_auth.currentUser!.uid}')
    //     .where('path', isEqualTo: widget.path)
    //     .get();

    // // الخطوة 2: تحديث الوثيقة إذا تم العثور عليها
    // for (var doc in querySnapshot.docs) {
    //   await firestore
    //       .collection('incidents${_auth.currentUser!.uid}')
    //       .doc(doc.id)
    //       .update({
    //     'title': title.text,
    //     'image': downloadURL,
    //     'path': 'incidents/${Path.basename(imagefile!.path)}',
    //     'date': Timestamp.fromDate(date!),
    //     'desc': desc.text,
    //   });
    // }