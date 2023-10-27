import 'dart:convert';
import 'dart:io';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/student_controller.dart';
import 'package:flutter_application_1/screens/admin/list_student.dart';
import 'package:http/http.dart' as http;
import '../../color.dart';
import '../../controller/user_controller.dart';
import '../widget/my_abb_bar.dart';
import '../widget/navbar_admin.dart';
import 'package:quickalert/quickalert.dart';

class InsertDataStudent extends StatefulWidget {
  const InsertDataStudent({super.key});
  @override
  State<InsertDataStudent> createState() => _InsertDataStudent();
}

class _InsertDataStudent extends State<InsertDataStudent> {
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
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

  void showSuccessToAddStudentAlert() {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มชื่อสำเร็จ",
      text: "ข้อมูลชื่อถูกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ListStudent(),
          ),
        );
      },
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );

      if (result != null) {
        uploadfile = result.files.single.bytes;
        fileName = result.files.first.name;

        _controller.text = fileName ?? "";

        print(fileName);

        // สามารถลบบรรทัดนี้ได้หากไม่ต้องการแสดงผล response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File upload failed: $e')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Step 2 <- SEE HERE
    _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: Column(children: [
        const NavbarAdmin(),
        Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: const Color.fromARGB(255, 226, 226, 226),
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
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0), // กำหนดมุม
                                          ),
                                        ),
                                        onPressed: () {
                                          _pickFile(context);
                                        },
                                        child: const Text('เลือกไฟล์'),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0), // กำหนดมุม
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (uploadfile != null) {
                                            print("Upload to API!");

                                            var response =
                                                await studentController.upload(
                                                    uploadfile!, fileName);
                                            if (response == 200) {
                                              showSuccessToAddStudentAlert();
                                              print("บันทึกสำเร็จ");
                                            }
                                          }
                                        },
                                        child: const Text("เพิ่ม")),
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
            ],
          ),
        ),
      ]),
    );
  }
}
