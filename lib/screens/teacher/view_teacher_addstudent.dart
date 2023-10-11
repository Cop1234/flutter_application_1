import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/model/registration.dart';
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

class TeacherAddStudent extends StatefulWidget {
  final String sectionId;
  const TeacherAddStudent({super.key, required this.sectionId});

  @override
  State<TeacherAddStudent> createState() => _TeacherAddStudentState();
}

class _TeacherAddStudentState extends State<TeacherAddStudent> {
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  final SectionController sectionController = SectionController();
  final RegistrationController registrationController =
      RegistrationController();
  bool? isLoaded = false;
  List<Map<String, dynamic>> data = [];

  int? sectionid;

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

  TextEditingController useridController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();

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

  void secData(String sectionId) async {
    section = await sectionController.get_Section(sectionId);
    setDataToText();
    setState(() {
      isLoaded = true;
    });

    userData(sectionId);
  }

  void userData(String sectionId) async {
    List<Registration> reg =
        await registrationController.do_getViewStudent(sectionId);

    setState(() {
      registration = reg;
      data = reg
          .map((reg) => {
                'userid': reg.user?.userid ?? "",
              })
          .toList();
      isLoaded = true;
    });
  }

  void showSuccessToAddUserAlert(String secid) {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มวิชาสำเร็จ",
      text: "ข้อมูลวิชาถูกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TeacherViewStudent(
              sectionId: secid,
            ),
          ),
        );
      },
    );
  }

  void showErrorUserExistsAlert(String subjectId) {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "รายชื่อ " + subjectId + " มีอยู่ในระบบแล้ว",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

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
      body: ListView(
        children: [
          Form(
            key: _formfield,
            child: Column(
              children: [
                Center(
                  child: Column(children: [
                    NavbarTeacher(),
                    Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Card(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "รหัสวิชา : ${subjectid.text}",
                                          style: CustomTextStyle.mainFontStyle,
                                        ),
                                        Text(
                                          "อาจารย์ : ${teacherFName.text} ${teacherLName.text}",
                                          style: CustomTextStyle.mainFontStyle,
                                        ),
                                        Text(
                                          "ชื่อวิชา : ${subjectName.text}   " +
                                              "กลุ่ม : ${sectionNumber.text}   " +
                                              "เวลา : ${DateFormat('jm').format(sectionTime)}   " +
                                              "ห้อง : ${room.text}   " +
                                              "ตึก : ${building.text}   ",
                                          style: CustomTextStyle.mainFontStyle,
                                        ),
                                        SizedBox(
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "รหัสนักศึกษา : ",
                                          style:
                                              CustomTextStyle.createFontStyle,
                                        ),
                                        SizedBox(
                                            width:
                                                10), // Adjust the width for spacing
                                        Container(
                                          width: 500,
                                          child: Expanded(
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: useridController,
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(),
                                                filled:
                                                    true, // เปิดการใช้งานการเติมพื้นหลัง
                                                fillColor: Colors.white,
                                                border: InputBorder
                                                    .none, // กำหนดให้ไม่มีเส้นขอบ
                                              ),
                                              validator: (value) {
                                                bool subjectIdValid =
                                                    RegExp(r'^[\d]+$')
                                                        .hasMatch(value!);
                                                if (value.isEmpty) {
                                                  return "กรุณากรอกรหัสประจำตัวอาจารย์*";
                                                } else if (!subjectIdValid) {
                                                  return "รหัสอาจารย์ต้องเป็นมีตัวเลขเท่านั้น";
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await Future.delayed(Duration
                                                .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                              return TeacherViewStudent(
                                                sectionId: '${section?.id}',
                                              );
                                            }));
                                          },
                                          child: Container(
                                              height: 35,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                color: maincolor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text("ยกเลิก",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (_formfield.currentState!
                                                .validate()) {
                                              http.Response response =
                                                  await registrationController
                                                      .do_update(
                                                useridController.text,
                                                '${section?.id}',
                                              );

                                              if (response.statusCode == 200) {
                                                showSuccessToAddUserAlert(
                                                    '${section?.id}');
                                                print("บันทึกสำเร็จ");
                                              }
                                            }
                                          },
                                          child: Container(
                                              height: 35,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                color: maincolor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text("ยืนยัน",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )),
                                        ),
                                      ])
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
