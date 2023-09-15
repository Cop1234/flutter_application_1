import 'dart:convert';
import 'dart:io';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/student_controller.dart';
import 'package:http/http.dart' as http;
import '../../controller/user_controller.dart';
import '../widget/my_abb_bar.dart';
import '../widget/navbar_admin.dart';

class InsertDataStudent extends StatefulWidget {
  const InsertDataStudent({super.key});
  @override
  State<InsertDataStudent> createState() => _InsertDataStudent();
}

class _InsertDataStudent extends State<InsertDataStudent> {
  TextEditingController _controller = new TextEditingController();
  final StudentController studentController = StudentController();
  File? fileToDisplay;
  PlatformFile? pickedFile;

  String? fileName;
  Uint8List? fileBytes;
  Uint8List? uploadfile;

  // Function to handle file selection
  void handleFileUpload(html.File file) {
    final reader = html.FileReader();

    reader.onLoad.listen((event) {
      setState(() {
        fileName = file.name;
        fileBytes = reader.result as Uint8List?;
      });
    });

    reader.readAsArrayBuffer(file);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Step 2 <- SEE HERE
    _controller.text = 'Complete the story from here...';
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom, // ตรวจสอบอย่างอื่น ๆ ในเอกสาร
          allowedExtensions: ['xls', 'xlsx']);

      if (result != null) {
        //final filePath = result.files.first.bytes;
        uploadfile = result.files.single.bytes;
        fileName = result.files.first.name;
        //pickedFile = result.files.first;
        //fileToDisplay = File(pickedFile!.path.toString());
        _controller.text = fileName ?? "";

        print(fileName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file:')),
        );
      }
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: Column(children: [
        NavbarAdmin(),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromARGB(255, 226, 226, 226),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 1200,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: "",
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _pickFile(context);
                                  },
                                  child: Text('เลือกไฟล์'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    var response = studentController
                                        .uploadUint8ListFile(uploadfile!);
                                    print(response);
                                  },
                                  child: Text("เพิ่ม")),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
