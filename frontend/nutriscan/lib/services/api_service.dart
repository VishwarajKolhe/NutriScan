import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ApiService {
  static Future<Map<String, dynamic>> sendToBackend(XFile imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://nutriscanproject-1085535174080.europe-west1.run.app/api/v1/scan'),
    );

    if (kIsWeb) {
      var bytes = await imageFile.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: imageFile.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
    }

    var response = await request.send();
    var body = await response.stream.bytesToString();

    return jsonDecode(body);
  }
}