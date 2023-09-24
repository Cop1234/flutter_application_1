import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/course_controller.dart';
import 'package:flutter_application_1/controller/room_controller.dart';
import 'package:flutter_application_1/controller/section_controller.dart';
import 'package:flutter_application_1/controller/subject_controller.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/model/course.dart';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/screens/teacher/teacher_import_student.dart';
import 'package:flutter_application_1/screens/teacher/update_class.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_attendance%20.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_qrcode.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_student.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../color.dart';

class ListClassScreen extends StatefulWidget {
  const ListClassScreen({super.key});

  @override
  State<ListClassScreen> createState() => _ListClassScreenState();
}

class _ListClassScreenState extends State<ListClassScreen> {
  final SubjectController subjectController = SubjectController();
  final CourseController courseController = CourseController();
  final SectionController sectionController = SectionController();
  final UserController userController = UserController();

  List<Map<String, dynamic>> dataSubject = [];
  List<Map<String, dynamic>> dataCourse = [];
  List<Map<String, dynamic>> dataSection = [];
  List<Map<String, dynamic>> combinedData = [];

  bool? isLoaded = false;
  List<Subject>? subjects;
  List<Course>? courses;
  List<Section>? sections;
  User? userNow;

  String? IdUser;

  void fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      if (user != null) {
        IdUser = user.id.toString();
        //print(IdUser);
        // เมื่อค้นพบ id ของผู้ใช้ ให้ดึงรายการคอร์สและเซคชันต่อไป
        fetchUserCourses(IdUser);
      }
    }
  }

  void fetchUserCourses(String? IdUser) async {
    if (IdUser != null) {
      // ค้นหาคอร์สของผู้ใช้โดยใช้ userId
      List<Course> userCourses =
          await courseController.listCoursesByUserId(IdUser);

      // ค้นหาเซคชันที่เกี่ยวข้องโดยใช้รายการคอร์สที่ค้นพบ
      List<Section> userSections =
          await sectionController.listSectionsByUserId(IdUser);

      // ตอนนี้คุณมีข้อมูล userCourses และ userSections
      // สามารถใช้ข้อมูลเหล่านี้ในการสร้างตารางหรือแสดงข้อมูลอื่น ๆ ตามที่คุณต้องการ

      fetchData(userCourses, userSections);
    }
  }

  void fetchData(List<Course> userCourses, List<Section> userSections) {
    setState(() {
      // สร้างรายการข้อมูลที่ต้องการจาก userCourses และ userSections

      for (Course course in userCourses) {
        Section? section = userSections.firstWhere(
          (s) => s.course?.id == course.id, // แก้ไขการเปรียบเทียบ ID ของ Course
          orElse: () => Section(id: null, type: 'N/A'),
        );
        // ตรวจสอบว่า section ไม่เป็น null ก่อนที่จะเข้าถึง section.id
        int sectionId = section != null ? section.id ?? 0 : 0;
        combinedData.add({
          'courseId': course.id,
          'sectionId': sectionId,
          'subjectName': course.subject?.subjectName,
          'subjectId': course.subject?.subjectId,
          'type': section.type,
          'sectionNumber': section.sectionNumber,
        });
      }

      // ทำอะไรกับ combinedData ต่อไปได้ตามที่คุณต้องการ
      // เช่น นำข้อมูลไปแสดงใน DataTable
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserId();
    print(combinedData);
  }

  static const double columnWidth = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              NavbarTeacher(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromARGB(255, 226, 226, 226),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: IntrinsicWidth(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => maincolor),
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black),
                            columns: const <DataColumn>[
                              DataColumn(
                                label: SizedBox(
                                  width:
                                      columnWidth, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'รหัสวิชา',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width:
                                      columnWidth, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'ชื่อวิชา',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width:
                                      columnWidth, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'ประเภท',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width:
                                      columnWidth, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'กลุ่ม',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width:
                                      columnWidth, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'จัดการ',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              // Add more DataColumn as needed
                            ],
                            rows: (combinedData ?? [])
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key + 1; // นับลำดับเริ่มจาก 1
                              Map<String, dynamic> row = entry.value;
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Container(
                                      width: columnWidth,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          row['subjectId'],
                                          style: CustomTextStyle.TextGeneral,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: columnWidth,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          row['subjectName'],
                                          style: CustomTextStyle.TextGeneral,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: columnWidth,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          row['type'],
                                          style: CustomTextStyle.TextGeneral,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: columnWidth,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          row['sectionNumber'],
                                          style: CustomTextStyle.TextGeneral,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      width: columnWidth,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: PopupMenuButton(
                                          icon: Icon(
                                            Icons.settings,
                                            color: Colors.white,
                                          ),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                        Icons
                                                            .inventory_outlined,
                                                        color: Colors.black),
                                                    SizedBox(width: 10.0),
                                                    Text('การเข้าเรียน'),
                                                  ],
                                                ),
                                                onTap: () async {
                                                  await Future.delayed(Duration
                                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                    return TeacherAtten();
                                                  }));
                                                }),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.qr_code_scanner,
                                                      color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('QR CODE'),
                                                ],
                                              ),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(seconds: 0),
                                                    () => TeacherQR());
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.people_alt,
                                                      color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('แก้ไขนักศึกษา'),
                                                ],
                                              ),
                                              onTap: () async {
                                                /*await Future.delayed(Duration
                                                    .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                  return TeacherUpdateClass();
                                                }));*/
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.settings,
                                                      color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('แก้ไขคลาสเรียน'),
                                                ],
                                              ),
                                              onTap: () async {
                                                print(row['courseId']);
                                                print(row['sectionId']);
                                                await Future.delayed(Duration
                                                    .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                  return TeacherUpdateClass(
                                                      courseId: row['courseId']
                                                          .toString(),
                                                      sectionId:
                                                          row['sectionId']
                                                              .toString());
                                                }));
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.group_add,
                                                      color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('เพิ่มนักศึกษา'),
                                                ],
                                              ),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(seconds: 0),
                                                    () => TeacherImportStu());
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                  // Add more DataCell as needed
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
