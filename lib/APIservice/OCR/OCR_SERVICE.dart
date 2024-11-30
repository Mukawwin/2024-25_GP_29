import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mukawwin_3/APIservice/Firebase/database.dart';

import '../../models/OCRModel.dart';

class OcrService {
  Future<OcrResponse?> sendFileToOCR(File file, BuildContext context) async {
    const String apiUrl = "https://mashaelalbu-ocrsensitive.hf.space/api/ocr";

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    String allergens = "";
    DatabaseService databaseService = DatabaseService();

    await databaseService.getUserAllergiesTitle().then((response) {
      allergens = response.map((allerg) => allerg.title).join(',');
    });
    print(allergens);

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Attach the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
      ));

      // Add allergens to the request
      request.fields['allergens'] = allergens;

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody);

        print("Response: $decodedResponse");

        final ocrResponse = OcrResponse.fromJson(decodedResponse);

        Navigator.pop(context);
        return ocrResponse;
      } else {
        print("Error: ${response.statusCode}");
        Navigator.pop(context);
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      Navigator.pop(context);
      return null;
    }
  }
}
