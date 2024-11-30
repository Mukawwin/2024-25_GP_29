import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mukawwin_3/screens/imageselected.dart';

import 'package:permission_handler/permission_handler.dart';

bool isload = false;

class Mybottombar extends StatefulWidget {
  const Mybottombar({super.key});

  @override
  State<Mybottombar> createState() => _MybottombarState();
}

class _MybottombarState extends State<Mybottombar> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 40.0,
            ),
            Container(
              height: 100.0,
              decoration: const BoxDecoration(
                color: Color(0xFF4B7e80),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            //AT SPRINT 2
                          },
                          icon: Image.asset(
                            "icons/list.png",
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),
                        const Text(
                          "Lists",
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15.0,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'account');
                          },
                          icon: Image.asset(
                            "icons/profile.png",
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),
                        const Text(
                          "Account",
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15.0,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: CircleAvatar(
            radius: 60.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50.0,
              backgroundColor: const Color(0xFF4B7e80),
              child: IconButton(
                onPressed: () async {
                  setState(() {
                    isload = true;
                  });
                  // Camera permission

                  Map<Permission, PermissionStatus> statuses =
                      await [Permission.camera].request();
                  if (statuses[Permission.camera]!.isGranted) {
                    _imgFromCamera();
                    print("================$imageFile=============");
                  }

                  isload = false;
                },
                icon: Image.asset(
                  "icons/scan.png",
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  final picker = ImagePicker();

  _imgFromCamera() async {
    await picker
        .pickImage(
            source: ImageSource.camera,
            imageQuality: 50) // call image picker library
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      } else {
        setState(() {
          isload = false;
        });
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      //   open image cropper interface
      sourcePath: imgFile.path,
      uiSettings: [
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
        /* IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),*/
      ],
    );
    if (croppedFile != null) {
      imageCache.clear(); // مسح ذاكرة التخزين المؤقت
      setState(() {
        imageFile = File(croppedFile.path); // حفظ ملف الصورة الجديدة بعد القص
      });
      if (imageFile != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ImageSelected(
              imageFile: imageFile!,
            ),
          ),
        );
      }
      print(
          "+=======================================================$imageFile");
    } else {
      setState(() {
        isload = false;
      });
    }
  }
}
