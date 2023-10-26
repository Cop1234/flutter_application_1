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
  bool? isLoaded = false;
  List<Registration>? registration;
  String? IdUser;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      print(user?.id);
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
                  })
              .toList();
          isLoaded = true;
        });
      }
    }
  }

  void showSureToDeleteStudent(String id) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการลบข้อมูลหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        onConfirmBtnTap: () async {
          http.Response response = await userController.deleteTeacher(id);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpDeleteStudentSuccessAlert();
          } else {
            showFailToDeleteStudentAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToDeleteStudentAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถลบข้อมูลได้",
        type: QuickAlertType.error);
  }

  void showUpDeleteStudentSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const ViewStudentSubject()));
        });
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      DataTable(
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => maincolor),
                                        dataRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.black),
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
                                        rows: data.asMap().entries.map((entry) {
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
                                                        .TextGeneral,
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
                                                          .TextGeneral,
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
                                                          .TextGeneral,
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
                                                          .TextGeneral,
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
                                                        color: Colors.white,
                                                      ),
                                                      itemBuilder: (context) =>
                                                          [
                                                        PopupMenuItem(
                                                            child: Row(
                                                              children: const <
                                                                  Widget>[
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
