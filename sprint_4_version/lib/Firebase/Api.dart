import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukawwin_3/Firebase/database.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';

import '../models/AllergyAnalysisModel.dart';

class AIAPI {
  DatabaseService databaseService = DatabaseService();
  Future<AllergyAnalysis> postOCRData({
    required File imageFile,
    required String allergies,
  }) async {
    const url = 'https://mashaelalbu-ocrsensitive.hf.space/api/ocr';
    // String allergies = "";
    // await databaseService.getUserAllergies().then((value) {
    //   for (UserAllergy val in value) {
    //     allergies += "${val.allergie},";
    //   }
    // });
    print(allergies);
    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      print("start");
      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: 'Image.jpeg',
        ),
      );
      print("1111");
      // Add text fields
      request.fields['user_allergies'] = allergies;
      request.fields['key'] = 'Value'; // As shown in your table
      print("2222");

      // Send the request and get response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print("33333");

      if (response.statusCode == 200) {
        print("44444");

        // Parse JSON and convert to AllergyAnalysis object
        final jsonResponse = json.decode(response.body);
        print(response.body);
        return AllergyAnalysis.fromJson(jsonResponse);
      } else {
        print("status code !!");
        // Try to parse error message if available
        final errorResponse = json.decode(response.body);
        throw ApiException(
          statusCode: response.statusCode,
          message: errorResponse['message'] ?? 'Failed to process request',
          details: errorResponse,
        );
      }
    } on SocketException {
      print('No Internet connection');
      throw const ApiException(message: 'No Internet connection');
    } on FormatException {
      print('Invalid API response format');
      throw const ApiException(message: 'Invalid API response format');
    } catch (e) {
      print('Unexpected error: ${e.toString()}');
      throw ApiException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic details;

  const ApiException({
    this.statusCode,
    required this.message,
    this.details,
  });

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status $statusCode)' : ''}';
}
