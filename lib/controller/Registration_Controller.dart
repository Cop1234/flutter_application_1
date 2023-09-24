import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../ws_config.dart';

class RegistrationController {
  Future upload(Uint8List file, String? filename, String id) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file,
        filename: filename, // Provide the desired file name and extension
      ),
    });

    // Adjust the URL to your Spring Boot server endpoint
    String url = baseURL + '/registrations/uploadstudent' + id;

    Response response = await dio.post(url, data: formData);

    print("Student : " + response.data);
    return response.statusCode;
  }
}
