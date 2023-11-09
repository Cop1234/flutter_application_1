import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/registration_Controller.dart';
import 'package:flutter_application_1/screens/student/view_student_attendance%20.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../color.dart';
import '../../controller/student_controller.dart';
import '../../controller/user_controller.dart';
import '../../model/registration.dart';
import '../../model/user.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../admin/insert_DataStudent.dart';
import '../widget/mainTextStyle.dart';
import 'edit_student_password.dart';
import 'detail_student_profile.dart';

class ViewStudentSubject extends StatefulWidget {
  const ViewStudentSubject({super.key});

  @override
  State<ViewStudentSubject> createState() => _ViewStudentSubjectState();
}

class _ViewStudentSubjectState extends State<ViewStudentSubject> {
  final RegistrationController registrationController =
      RegistrationController();
  final UserController userController = UserController();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filterSemesterData = [];
  List<Map<String, dynamic>> filterTermData = [];
  bool? isLoaded = false;
  List<Registration>? registration;
  String? IdUser;
  String? selectedSemester = 'ทั้งหมด';
  List<String> semesters = ['ทั้งหมด'];
  String? selectedTerm = 'ทั้งหมด';
  List<String> terms = ['ทั้งหมด', '1', '2'];

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "MJU6304106304";

    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      IdUser = user?.id.toString();
      if (user != null) {
        print(IdUser);
        List<Registration> reg =
            await registrationController.get_ViewSubject(user.id.toString());

        setState(() {
          IdUser = user.id.toString();
          registration = reg;
          data = reg
              .map((reg) => {
                    'regid': reg.id ?? "",
                    'id': reg.section?.id ?? "",
                    'subjectid': reg.section?.course?.subject?.subjectId ?? "",
                    'subjectName':
                        reg.section?.course?.subject?.subjectName ?? "",
                    'type': reg.section?.type ?? "",
                    'group': reg.section?.sectionNumber,
                    'semester': reg.section?.course?.semester,
                    'term': reg.section?.course?.term,
                  })
              .toList();
          isLoaded = true;

          // เพิ่มค่า semester ลงใน semesters
          data.forEach((row) {
            String? semester = row['semester'].toString();
            if (semester != null && !semesters.contains(semester)) {
              semesters.add(semester);
            }
          });
          filterSemesterData = data
              .where((row) =>
                  selectedSemester == 'ทั้งหมด' ||
                  row['semester'].toString() == selectedSemester)
              .toList();
          filterData();
        });
      }
    }
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
    fetchData();
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
                const NavbarStudent(),
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
                                                  filterSemesterData = data
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
                                        rows: filterTermData
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          Map<String, dynamic> row =
                                              entry.value;

                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(Container(
                                                width: 100,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    row['subjectid'],
                                                    style: CustomTextStyle
                                                        .TextGeneral2,
                                                  ),
                                                ),
                                              )),
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
                                                      row['group'],
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
                                                              children: const <Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .change_circle,
                                                                    color: Colors
                                                                        .black),
                                                                SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Text(
                                                                    'ดูการเข้าห้อง'),
                                                              ],
                                                            ),
                                                            onTap: () async {
                                                              await Future.delayed(
                                                                  Duration
                                                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                      MaterialPageRoute(builder:
                                                                          (BuildContext
                                                                              context) {
                                                                return StudentAtten(
                                                                  sectionId: row[
                                                                          'id']
                                                                      .toString(),
                                                                  regid: row[
                                                                          'regid']
                                                                      .toString(),
                                                                );
                                                              }));
                                                            }),
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
