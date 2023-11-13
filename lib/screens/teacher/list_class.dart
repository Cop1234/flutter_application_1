import 'package:auto_size_text/auto_size_text.dart';
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
  List<Map<String, dynamic>> filterSemesterData = [];
  List<Map<String, dynamic>> filterTermData = [];

  bool? isLoaded = false;
  List<Subject>? subjects;
  List<Course>? courses;
  List<Section>? sections;
  User? userNow;
  String? IdUser;
  String? selectedSemester = 'ทั้งหมด';
  List<String> semesters = ['ทั้งหมด'];
  String? selectedTerm = 'ทั้งหมด';
  List<String> terms = ['ทั้งหมด', '1', '2'];

  void fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "Tanakorn63@gmail.com";
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      if (user != null) {
        IdUser = user.id.toString();
        //print(IdUser);
        // เมื่อค้นพบ id ของผู้ใช้ ให้ดึงรายการคอร์สและเซคชันต่อไป
        fetchUserCourses(IdUser);
      }
    }
    setState(() {
      isLoaded = true;
    });
  }

  void fetchUserCourses(String? IdUser) async {
    if (IdUser != null) {
      // ค้นหาคอร์สของผู้ใช้โดยใช้ userId
      List<Course> userCourses =
          await courseController.listCoursesByUserId(IdUser);

      // ค้นหาเซคชันที่เกี่ยวข้องโดยใช้รายการคอร์สที่ค้นพบ
      List<Section> userSections =
          await sectionController.get_ListClasstbyUserId(IdUser);

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
          'semester': course.semester,
          'term': course.term,
          'type': section.type,
          'sectionNumber': section.sectionNumber,
        });
        // ทำอะไรกับ combinedData ต่อไปได้ตามที่คุณต้องการ
        // เช่น นำข้อมูลไปแสดงใน DataTable
        //----------------------------------------------//
        // เพิ่มค่า semester ลงใน semesters
        combinedData.forEach((row) {
          String? semester = row['semester'].toString();
          if (semester != null && !semesters.contains(semester)) {
            semesters.add(semester);
          }
        });
        filterSemesterData = combinedData
            .where((row) =>
                selectedSemester == 'ทั้งหมด' ||
                row['semester'].toString() == selectedSemester)
            .toList();
        filterData();
      }
    });
  }

  void filterData() {
    filterTermData = filterSemesterData.where((row) {
      return (selectedTerm == 'ทั้งหมด' ||
          row['term'].toString() == selectedTerm);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchUserId();
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
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: const Color.fromARGB(255, 226, 226, 226),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: IntrinsicWidth(
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "ปีการศึกษา : ",
                                            style: CustomTextStyle.TextGeneral2,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 120,
                                            height: 50,
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                top: 1.0,
                                                right: 10.0,
                                                bottom: 5.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child:
                                                DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              value: selectedSemester,
                                              items: semesters.map((semester) {
                                                return DropdownMenuItem(
                                                  value: semester,
                                                  child: Text(
                                                    semester,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedSemester = newValue;
                                                  filterSemesterData = combinedData
                                                      .where((row) =>
                                                          selectedSemester ==
                                                              'ทั้งหมด' ||
                                                          row['semester']
                                                                  .toString() ==
                                                              selectedSemester)
                                                      .toList();
                                                  selectedTerm = 'ทั้งหมด';
                                                  filterData();
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder
                                                    .none, // กำหนด border เป็น InputBorder.none เพื่อลบ underline
                                              ),
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Text(
                                            "เทอม : ",
                                            style: CustomTextStyle.TextGeneral2,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 120,
                                            height: 50,
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                top: 1.0,
                                                right: 10.0,
                                                bottom: 5.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child:
                                                DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              value: selectedTerm,
                                              items: terms.map((term) {
                                                return DropdownMenuItem(
                                                  value: term,
                                                  child: Text(term),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedTerm = newValue;
                                                  filterData();
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder
                                                    .none, // กำหนด border เป็น InputBorder.none เพื่อลบ underline
                                              ),
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      DataTable(
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => maincolor),
                                        dataRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.white),
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  100, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'รหัสวิชา',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  400, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'ชื่อวิชา',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  150, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'ประเภท',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  100, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'กลุ่ม',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  100, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'จัดการ',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Add more DataColumn as needed
                                        ],
                                        rows: (filterTermData ?? [])
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key +
                                              1; // นับลำดับเริ่มจาก 1
                                          Map<String, dynamic> row =
                                              entry.value;
                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Container(
                                                  width: 100,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      row['subjectId'],
                                                      style: CustomTextStyle
                                                          .TextGeneral2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Container(
                                                  width: 400,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      row['subjectName'],
                                                      style: CustomTextStyle
                                                          .TextGeneral2,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign
                                                          .center, // จัดให้อยู่ตรงกลาง
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Container(
                                                  width: 150,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      row['type'],
                                                      style: CustomTextStyle
                                                          .TextGeneral2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Container(
                                                  width: 100,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      row['sectionNumber'],
                                                      style: CustomTextStyle
                                                          .TextGeneral2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Container(
                                                  width: 100,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: PopupMenuButton(
                                                      icon: const Icon(
                                                        Icons.settings,
                                                        color: Colors.black,
                                                      ),
                                                      itemBuilder: (context) =>
                                                          [
                                                        PopupMenuItem(
                                                            child: Row(
                                                              children: const <
                                                                  Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .inventory_outlined,
                                                                    color: Colors
                                                                        .black),
                                                                SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Text(
                                                                    'การเข้าเรียน'),
                                                              ],
                                                            ),
                                                            onTap: () async {
                                                              await Future.delayed(
                                                                  Duration
                                                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                              Navigator
                                                                  .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                  return TeacherAtten(
                                                                      sectionId:
                                                                          row['sectionId']
                                                                              .toString());
                                                                }),
                                                                (route) =>
                                                                    false,
                                                              );
                                                            }),
                                                        PopupMenuItem(
                                                          child: Row(
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                  Icons
                                                                      .qr_code_outlined,
                                                                  color: Colors
                                                                      .black),
                                                              SizedBox(
                                                                  width: 10.0),
                                                              Text(
                                                                  'แสดงคิวอาร์โค้ด'),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            await Future.delayed(
                                                                Duration
                                                                    .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                return TeacherQR(
                                                                    sectionId: row[
                                                                            'sectionId']
                                                                        .toString());
                                                              }),
                                                              (route) => false,
                                                            );
                                                          },
                                                        ),
                                                        PopupMenuItem(
                                                          child: Row(
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                  Icons
                                                                      .people_alt,
                                                                  color: Colors
                                                                      .black),
                                                              SizedBox(
                                                                  width: 10.0),
                                                              Text(
                                                                  'ดูรายชื่อนักศึกษา'),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            await Future.delayed(
                                                                Duration
                                                                    .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                return TeacherViewStudent(
                                                                    sectionId: row[
                                                                            'sectionId']
                                                                        .toString());
                                                              }),
                                                              (route) => false,
                                                            );
                                                          },
                                                        ),
                                                        PopupMenuItem(
                                                          child: Row(
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                  Icons
                                                                      .settings,
                                                                  color: Colors
                                                                      .black),
                                                              SizedBox(
                                                                  width: 10.0),
                                                              Text(
                                                                  'แก้ไขคลาสเรียน'),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            await Future.delayed(
                                                                Duration
                                                                    .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                return TeacherUpdateClass(
                                                                    courseId: row[
                                                                            'courseId']
                                                                        .toString(),
                                                                    sectionId: row[
                                                                            'sectionId']
                                                                        .toString());
                                                              }),
                                                              (route) => false,
                                                            );
                                                          },
                                                        ),
                                                        PopupMenuItem(
                                                          child: Row(
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                  Icons
                                                                      .group_add,
                                                                  color: Colors
                                                                      .black),
                                                              SizedBox(
                                                                  width: 10.0),
                                                              Text(
                                                                  'เพิ่มนักศึกษา'),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            await Future.delayed(
                                                                Duration
                                                                    .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                return TeacherImportStu(
                                                                    sectionId: row[
                                                                            'sectionId']
                                                                        .toString());
                                                              }),
                                                              (route) => false,
                                                            );
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
                ),
              ],
            ),
    );
  }
}
