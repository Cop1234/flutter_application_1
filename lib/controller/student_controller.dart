import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import '../ws_config.dart';

class StudentController {
  Future<void> uploadUint8ListFile(Uint8List fileBytes) async {
    final url =
        Uri.parse(baseURL + '/student/add'); // Replace with your API endpoint
    final response = await http.post(
      url,
      body: fileBytes,
      headers: {
        'Content-Type':
            'application/octet-stream', // Set the appropriate content type
      },
    );

    if (response.statusCode == 200) {
      // File uploaded successfully
      print('File uploaded');
    } else {
      // Handle the error
      print('File upload failed: ${response.body}');
    }
  }
}
