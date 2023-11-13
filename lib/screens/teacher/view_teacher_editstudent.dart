import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/model/registration.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_addstudent.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_student.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';

import '../../color.dart';
import '../../controller/registration_Controller.dart';
import '../../controller/section_controller.dart';
import '../../model/section.dart';
import '../widget/mainTextStyle.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class TeacherEditStudent extends StatefulWidget {
  final String sectionId;
  const TeacherEditStudent({super.key, required this.sectionId});

  @override
  State<TeacherEditStudent> createState() => _TeacherEditStudentState();
}

class _TeacherEditStudentState extends State<TeacherEditStudent> {
  final SectionController sectionController = SectionController();
  final RegistrationController registrationController =
      RegistrationController();
  bool? isLoaded = false;
  List<Map<String, dynamic>> data = [];

  String? idsec;
  String? regid;

  List<Registration>? registration;
  Section? section;
  TextEditingController subjectid = TextEditingController();
  TextEditingController subjectName = TextEditingController();
  TextEditingController teacherFName = TextEditingController();
  TextEditingController teacherLName = TextEditingController();
  TextEditingController sectionNumber = TextEditingController();
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
    sectionTime = DateFormat('HH:mm').parse(section?.startTime ?? "").toLocal();
    sectiontype.text = section?.type ?? "";
    room.text = section?.room?.roomName ?? "";
  }

  void secData(String sectionId) async {
    section = await sectionController.get_Section(sectionId);
    setDataToText();
    setState(() {
      idsec = '${section?.id}';
      isLoaded = true;
    });

    userData(sectionId);
  }

  void userData(String sectionId) async {
    List<Registration> reg =
        await registrationController.do_getViewStudent(sectionId);

    setState(() {
      regid = '${reg}';
      registration = reg;
      data = reg
          .map((reg) => {
                'id': reg.id ?? "",
                'userid': reg.user?.userid ?? "",
                'fname': reg.user?.fname ?? "",
                'lname': reg.user?.lname ?? "",
              })
          .toList();
      isLoaded = true;
    });
  }

  void showSureToDeleteStudent(String id, String secid) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการลบข้อมูลหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        onConfirmBtnTap: () async {
          print(id);
          print(secid);
          http.Response response =
              await registrationController.deleteRegistration(id);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpDeleteStudentSuccessAlert(secid);
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

  void showUpDeleteStudentSuccessAlert(String secid) {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => TeacherViewStudent(
                      sectionId: secid,
                    )),
            (route) => false,
          );
        });
  }

  ////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    secData(widget.sectionId);
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
                                                      "แก้ไขรายชื่อนักศึกษา",
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
                        ]),
                      ),
                      Center(
                        child: Column(
                          children: [
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
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                        return TeacherAddStudent(
                                                            sectionId:
                                                                '${section?.id}');
                                                      }),
                                                      (route) => false,
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                    height: 35,
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      color: maincolor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                          "เพิ่มนักศึกษา",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    )),
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
                                                    200, // กำหนดความกว้างของ DataColumn
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'รหัสนักศึกษา',
                                                    style: CustomTextStyle
                                                        .TextHeadBar,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width:
                                                    200, // กำหนดความกว้างของ DataColumn
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'ชื่อ',
                                                    style: CustomTextStyle
                                                        .TextHeadBar,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width:
                                                    200, // กำหนดความกว้างของ DataColumn
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'นามสกุล',
                                                    style: CustomTextStyle
                                                        .TextHeadBar,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width:
                                                    200, // กำหนดความกว้างของ DataColumn
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
                                          rows:
                                              data.asMap().entries.map((entry) {
                                            Map<String, dynamic> row =
                                                entry.value;
                                            return DataRow(
                                              cells: <DataCell>[
                                                DataCell(Container(
                                                  width: 200,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      row['userid'],
                                                      style: CustomTextStyle
                                                          .TextGeneral2,
                                                    ),
                                                  ),
                                                )),
                                                DataCell(
                                                  Container(
                                                    width: 200,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        row['fname'],
                                                        style: CustomTextStyle
                                                            .TextGeneral2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    width: 200,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        row['lname'],
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
                                                    width: 200,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: PopupMenuButton(
                                                        icon: const Icon(
                                                          Icons.settings,
                                                          color: Colors.black,
                                                        ),
                                                        itemBuilder:
                                                            (context) => [
                                                          PopupMenuItem(
                                                            child: Row(
                                                              children: const <
                                                                  Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .black),
                                                                SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Text('ลบ'),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          0),
                                                                  () => showSureToDeleteStudent(
                                                                      row['id']
                                                                          .toString(),
                                                                      '${section?.id}'));
                                                              //String? gg = row['id'].toString() ?? "";
                                                              //print(gg);
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
