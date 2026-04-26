import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static Future<void> sendToBackend(XFile imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8000/analyze'),
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

    print("Response: ${response.statusCode}");
  }
}