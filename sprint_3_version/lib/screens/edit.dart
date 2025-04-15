import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mukawwin_3/models/customtextfield.dart';
import 'package:mukawwin_3/models/myappbar.dart';
import 'package:mukawwin_3/screens/savelist.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as Path;

class Edit extends StatefulWidget {
  final String path;
  final String image;
  final String title;
  final String docid;
  const Edit(
      {super.key,
      required this.path,
      required this.image,
      required this.title,
      required this.docid});

  @override
  State<Edit> createState() => _HomepageState();
}

class _HomepageState extends State<Edit> {
  late TextEditingController productname;
  final firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? imagefile;
  final picker = ImagePicker();
  bool isload = false;
  String? downloadURL;
  bool wait = false;

  Future<void> deleteImage(String filePath) async {
    try {
      // قم بالإشارة إلى الملف باستخدام المسار
      Reference ref = _storage.ref(filePath);

      // احذف الملف
      await ref.delete();

      print('تم حذف الصورة بنجاح');
    } catch (e) {
      print('حدث خطأ أثناء حذف الصورة: $e');
    }
  }

  Future<void> uploadImage() async {
    if (imagefile == null) {
      print("Error: No image selected.");
      return;
    } else {
      print("image not empty");
      deleteImage(widget.path);
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
          .child('safe_list/${Path.basename(imagefile!.path)}');
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

    await FirebaseFirestore.instance
        .collection('savelist')
        .doc(widget.docid)
        .update({
      'image': downloadURL,
      'path': 'safe_list/${Path.basename(imagefile!.path)}',
    });

    print('Document updated successfully!');
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
    productname = TextEditingController(text: widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wait == false
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Myappbar(
                    show: false,
                    back: Icons.arrow_back,
                    savelist: true,
                    // title: 'Save List',
                  ),
                  const Text(
                    'Edit product',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 5.0,
                    indent: 100.0,
                    endIndent: 100.0,
                  ),
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
                                  fit: BoxFit.cover,
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
                        )
                      : Column(
                          children: [
                            Center(
                              child: Container(
                                width: 150.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                ),
                                child: Image.network(
                                  widget.image,
                                  height: 300,
                                  width: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            IconButton(
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
                                Icons.add_photo_alternate_outlined,
                                color: Color(0xff4ecdc4),
                                size: 25.0,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20.0),
                  Custom_TextField(
                    icon: Icons.production_quantity_limits_outlined,
                    hinttext: "product name",
                    mycontroller: productname,
                  ),
                  const SizedBox(height: 10.0),
                  // const Center(
                  //     child: Text(
                  //   'Add expiration date reminder',
                  //   style: TextStyle(
                  //       fontSize: 15.0,
                  //       fontFamily: 'Lato',
                  //       fontWeight: FontWeight.bold),
                  // )),
                  CustomButton(
                      onPressed: () async {
                        if (imagefile == null && productname.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please enter the name and image of the product"),
                              duration: Duration(seconds: 3), // مدة العرض
                            ),
                          );
                        } else {
                          setState(() {
                            wait = true;
                          });
                          if (productname.text != "") {
                            await FirebaseFirestore.instance
                                .collection('savelist')
                                .doc(widget.docid)
                                .update({
                              'title': productname.text,
                            });
                          }
                          // setState(() {
                          //   wait = true;
                          // });
                          if (imagefile != null) {
                            await uploadImage();
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Savelist(),
                            ),
                          );
                        }
                      },
                      buttonname: "Save"),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
