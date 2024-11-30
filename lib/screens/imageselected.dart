import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mukawwin_3/APIservice/OCR/OCR_SERVICE.dart';
import 'package:mukawwin_3/Widget/customtextfield.dart';
import 'package:mukawwin_3/Widget/myappbar.dart';
import 'package:mukawwin_3/Widget/mybottombar.dart';

import 'package:mukawwin_3/screens/check.dart';

class ImageSelected extends StatefulWidget {
  final File imageFile;
  const ImageSelected({super.key, required this.imageFile});

  @override
  State<ImageSelected> createState() => _ImageSelectedState();
}

class _ImageSelectedState extends State<ImageSelected> {
  OcrService ocrService = OcrService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isload
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Myappbar(
                  back: Icons.arrow_back,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: Image.file(
                      widget.imageFile,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                    onPressed: () async {
                      int select = 0;
                      List<String> responseAllergies = [];
                      await ocrService
                          .sendFileToOCR(widget.imageFile, context)
                          .then((response) {
                        if (response!.extractedText.substring(1, 5) == "text") {
                          select = 2;
                        } else if (response.analysis.hasAllergens &&
                            response.analysis.foundAllergens.isNotEmpty) {
                          select = 1;
                          responseAllergies = response.analysis.foundAllergens
                              .map((item) => item.toString())
                              .toList();
                        } else if (!response.analysis.hasAllergens) {
                          select = 0;
                        } else {
                          select = 2;
                        }

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Check(
                              select: select,
                              allergies: responseAllergies,
                            ),
                          ),
                        );
                      });
                    },
                    buttonname: "Done")
              ],
            ),
    );
  }
}
