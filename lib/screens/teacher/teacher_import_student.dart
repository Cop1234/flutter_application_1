import 'dart:html';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/controller/registration_Controller.dart';
import 'package:flutter_application_1/controller/section_controller.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../../color.dart';
import '../widget/mainTextStyle.dart';
import 'list_class.dart';

import 'dart:html' as html;

class TeacherImportStu extends StatefulWidget {
  final String sectionId;
  const TeacherImportStu({super.key, required this.sectionId});

  @override
  State<TeacherImportStu> createState() => _TeacherImportStuState();
}

class _TeacherImportStuState extends State<TeacherImportStu> {
  final RegistrationController registrationController =
      RegistrationController();
  final SectionController sectionController = SectionController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();

  File? fileToDisplay;
  PlatformFile? pickedFile;

  String? fileName;
  Uint8List? fileBytes;
  Uint8List? uploadfile;
  bool? isLoaded;
  Section? section;

  TextEditingController subjectid = TextEditingController();
  TextEditingController subjectName = TextEditingController();
  TextEditingController teacherFName = TextEditingController();
  TextEditingController teacherLName = TextEditingController();
  TextEditingController sectionNumber = TextEditingController();
  //TextEditingController sectionTime = TextEditingController();
  DateTime sectionTime = DateTime.now();
  TextEditingController room = TextEditingController();
  TextEditingController sectiontype = TextEditingController();
  TextEditingController building = TextEditingController();
  void setDataToText() {
    subjectid.text = section?.course?.subject?.subjectId ?? "";
    subjectName.text = section?.course?.subject?.subjectName ?? "";
    teacherFName.text = section?.user?.fname ?? "";
    teacherLName.text = section?.user?.lname ?? "";
    sectionNumber.text = section?.sectionNumber ?? "";
    building.text = section?.room?.building ?? "";
    sectionTime = DateFormat('HH:mm').parse(section?.startTime ?? "");
    sectiontype.text = section?.type ?? "";
    room.text = section?.room?.roomName ?? "";
  }

  void userData(String sectionId) async {
    setState(() {
      isLoaded = false;
    });
    section = await sectionController.get_Section(sectionId);
    setDataToText();

    setState(() {
      isLoaded = true;
    });
  }

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
            builder: (context) => const ListClassScreen(),
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
          const SnackBar(content: Text('File uploaded successfully')),
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
    super.initState();
    // userData();
    userData(widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const NavbarTeacher(),
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Column(children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Card(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "รหัสวิชา : ${subjectid.text}",
                                            style:
                                                CustomTextStyle.mainFontStyle,
                                          ),
                                          Text(
                                            "ชื่อวิชา : ${subjectName.text}",
                                            style:
                                                CustomTextStyle.mainFontStyle,
                                          ),
                                          Text(
                                            "อาจารย์ : ${teacherFName.text} ${teacherLName.text}",
                                            style:
                                                CustomTextStyle.mainFontStyle,
                                          ),
                                          Text(
                                            "กลุ่ม : ${sectionNumber.text}   " +
                                                "เวลา : ${DateFormat('jm').format(sectionTime)}   ",
                                            style:
                                                CustomTextStyle.mainFontStyle,
                                          ),
                                          Text(
                                            "ห้อง : ${room.text}   " +
                                                "ตึก : ${building.text}   ",
                                            style:
                                                CustomTextStyle.mainFontStyle,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
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
                                                decoration:
                                                    const InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: "",
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40,
                                                        vertical: 15),
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40,
                                                        vertical: 15),
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0), // กำหนดมุม
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (uploadfile != null) {
                                                  print("Upload to API!");

                                                  var response =
                                                      await registrationController
                                                          .upload(
                                                              uploadfile!,
                                                              fileName,
                                                              '${section?.id.toString()}');
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
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
