import 'dart:html';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/controller/registration_Controller.dart';
import 'package:flutter_application_1/controller/section_controller.dart';
import 'package:flutter_application_1/controller/student_controller.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';
import 'package:popup_banner/popup_banner.dart';
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
  final StudentController studentController = StudentController();
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
  bool? showDataStudent = false;

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

  void showErrorUserNameExistsAlert() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "กรุณาเลือกไฟล์!!!",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
      //barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
    );
  }

  void showErrorNullValue() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "ในไฟล์ควรไม่มีค่าว่าง!",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
      //barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
    );
  }

  void showErrorValueError() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "ข้อความในไฟล์มีข้อผิดพลาด",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
      //barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
    );
  }

  // void setuserData() async {

  //   List<Map<String, dynamic>> data = [];
  //   setDataToText();
  //   setState(() {

  //     data = userstudent
  //         .map((user) => {
  //               'userid': user.userid ?? "",
  //               'fname': user.fname ?? "",
  //               'lname': user.lname ?? "",
  //             })
  //         .toList();
  //   });
  // }

  List<List<String>> tableData = [];
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

        // Open the Excel file
        final excel = Excel.decodeBytes(uploadfile!);

        // Assuming that you want to read data from the first sheet
        final sheet = excel.tables.keys.first;

        // Clear the existing data
        tableData.clear();

        // Get the userstudent data
        List<User> userstudent = await studentController.listAllStudent();
        List<Map<String, dynamic>> userData = userstudent
            .map((user) => {
                  'userid': user.userid ?? "",
                  'fname': user.fname ?? "",
                  'lname': user.lname ?? "",
                })
            .toList();

        for (var i = 1; i <= excel[sheet]!.maxCols; i++) {
          List<String> rowData = [];
          for (var cell in excel[sheet]!.row(i)) {
            rowData.add(cell!.value.toString());
          }

          // Check if rowData matches any user from userstudent
          bool matchFound = false;
          for (var userDataItem in userData) {
            if (userDataItem['userid'] == rowData[0] &&
                userDataItem['fname'] == rowData[1] &&
                userDataItem['lname'] == rowData[2]) {
              matchFound = true;
              break;
            }
          }

          if (!matchFound) {
            tableData.add(rowData); // Add to tableData if no match is found
          }
        }

        setState(() {
          showDataStudent = true;
        });

        // You can display a message indicating that the file was uploaded successfully.
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

  List<String> images = [
    "images/import/ImportStudent_class.png",
  ];
  void showHideDotsPopup() {
    PopupBanner(
      context: context,
      images: images,
      autoSlide: false,
      useDots: false,
      onClick: (index) {
        debugPrint("CLICKED $index");
      },
    ).show();
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
        body: isLoaded == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(maincolor),
                    ),
                  ),
                ],
              )
            : Column(
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: const Color.fromARGB(
                                          255, 226, 226, 226),
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
                                                const Center(
                                                    child: Text(
                                                        "เพิ่มนักศึกษาเข้าคลาสเรียน",
                                                        style: CustomTextStyle
                                                            .Textheader)),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "รหัสวิชา : ${subjectid.text}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "ชื่อวิชา : ${subjectName.text}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "อาจารย์ : ${teacherFName.text} ${teacherLName.text}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "กลุ่ม : ${sectionNumber.text}   " +
                                                      "เวลา : ${DateFormat('jm').format(sectionTime)}   ",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "ห้อง : ${room.text}   " +
                                                      "ตึก : ${building.text}   ",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
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
                                    horizontal: 20, vertical: 10),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color:
                                      const Color.fromARGB(255, 226, 226, 226),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 1200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: TextFormField(
                                                        controller: _controller,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText: "",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40,
                                                          vertical: 22),
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    onPressed: () {
                                                      _pickFile(context);
                                                    },
                                                    child:
                                                        const Text('เลือกไฟล์'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    showHideDotsPopup();
                                                  },
                                                  child: const Align(
                                                    alignment: Alignment
                                                        .centerLeft, // กำหนดให้ชิดซ้าย
                                                    child: Text(
                                                      "ตัวอย่างไฟล์",
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontSize: 16,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            ShowSelectDate(),
                                            Padding(
                                              padding: const EdgeInsets.all(40),
                                              child: Center(
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40,
                                                          vertical: 15),
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20.0), // กำหนดมุม
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      try {
                                                        var response =
                                                            await registrationController
                                                                .upload(
                                                                    uploadfile!,
                                                                    fileName,
                                                                    '${section?.id.toString()}');
                                                        if (response == 200) {
                                                          showSuccessToAddStudentAlert();
                                                          print("บันทึกสำเร็จ");
                                                        } else {
                                                          showErrorValueError();
                                                        }
                                                      } on DioError catch (e) {
                                                        // จัดการข้อผิดพลาดจาก Dio
                                                        print(
                                                            "DioError: ${e.message}");
                                                        if (e.response !=
                                                            null) {
                                                          print(
                                                              "ข้อมูลการตอบรับ: ${e.response!.data}");
                                                          showErrorNullValue();
                                                        }
                                                        // คุณสามารถแสดงข้อความข้อผิดพลาดให้ผู้ใช้หรือบันทึกรายละเอียดเพิ่มเติมเกี่ยวกับข้อผิดพลาด.
                                                      } catch (e) {
                                                        // จัดการข้อยกเว้นอื่น ๆ
                                                        print("ข้อผิดพลาด: $e");
                                                        showErrorUserNameExistsAlert();
                                                        // จัดการข้อยกเว้นอื่น ๆ ตามความจำเป็น
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

  Widget ShowSelectDate() {
    if (showDataStudent == true) {
      // Replace this with the data you want to display in the table

      return Column(
        children: [
          const Text(
            'หมายเหตุ * : รายชื่อที่แสดงไม่มีข้อมูลนักศึกษา',
            style: TextStyle(color: Colors.red),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('รหัสนักศึกษา')),
              DataColumn(label: Text('ชื่อ')),
              DataColumn(label: Text('นามสกุล')),
            ],
            rows: tableData.map((row) {
              return DataRow(
                cells: row.map((cell) {
                  return DataCell(Text(
                    cell,
                    style: const TextStyle(color: Colors.red),
                  ));
                }).toList(),
              );
            }).toList(),
          )
        ],
      );
    } else {
      return const SizedBox
          .shrink(); // Hide the table when showDataStudent is false
    }
  }
}
