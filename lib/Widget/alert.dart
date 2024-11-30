
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mukawwin_3/Widget/mybottombar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/imageselected.dart';

// ignore: must_be_immutable
class Alert extends StatefulWidget {
  final bool button;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final bool checkallregies;
  late List<String>? allergies = [];
  late String? onebutton;
  late String? towbutton1;
  late String? towbutton2;

  Alert({
    super.key,
    required this.checkallregies,
    required this.button,
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    this.allergies,
    this.onebutton,
    this.towbutton1,
    this.towbutton2,
  });

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 10.0,
                offset: const Offset(9, 9),
              )
            ],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  widget.icon,
                  size: 70.0,
                  color: widget.color,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Lato',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  height: 10.0,
                  indent: 50.0,
                  endIndent: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    widget.desc,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Lato',
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                widget.checkallregies == true
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'The product contains:\n${widget.allergies!.join(", ")}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Lato',
                            color: Color.fromARGB(255, 212, 26, 13),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox(height: 10.0),
                widget.button == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                isload = true;
                              });
                              Map<Permission, PermissionStatus> statuses =
                                  await [Permission.camera].request();
                              if (statuses[Permission.camera]!.isGranted) {
                                _imgFromCamera();
                              }
                              isload = false;
                            },
                            child: Text(
                              widget.towbutton1!,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Lato',
                                color: Color(0xFF4ECDC4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: 70.0,
                              child: Text(
                                widget.towbutton2!,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Lato',
                                  color: Color(0xFF4ECDC4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: TextButton(
                          onPressed: () async {
                            setState(() {
                              isload = true;
                            });
                            Map<Permission, PermissionStatus> statuses =
                                await [Permission.camera].request();
                            if (statuses[Permission.camera]!.isGranted) {
                              _imgFromCamera();
                            }
                            isload = false;
                          },
                          child: Text(
                            widget.onebutton!,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Lato',
                              color: Color(0xFF4ECDC4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  _imgFromCamera() async {
    await picker
        .pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    )
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
      sourcePath: imgFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: const Color.fromARGB(255, 2, 56, 13),
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
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
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
    } else {
      setState(() {
        isload = false;
      });
    }
  }
}
