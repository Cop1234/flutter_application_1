import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Map<String, dynamic>> data = [];
  List<Registration>? registration;
  List<Registration>? registrationForCheck;
  int? sectionid;
  Section? section;
  bool? isLoaded = false;
  bool? inputStuNumber = false;

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
    sectionTime = DateFormat('HH:mm').parse(section?.startTime ?? "").toLocal();
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
      registrationForCheck = reg;
      isLoaded = true;
    });
  }

  // ฟังก์ชันเช็ค userId ว่ามีอยู่ใน registration หรือไม่
  bool isUserIdExists(String userId) {
    if (registrationForCheck != null) {
      return registrationForCheck!.any((reg) => reg.user?.userid == userId);
    }
    return false;
  }

  void showSuccessToAddUserAlert(String secid) {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มนักศึกษาสำเร็จ",
      text: "ข้อมูลนักศึกษาถูกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherViewStudent(
              sectionId: secid,
            ),
          ),
          (route) => false,
        );
      },
    );
  }

  void showErrorUserIdExistsAlert(String userId) {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text:
          "นักศึกษารหัส $userId มีอยู่ ${subjectid.text} ${subjectName.text} แล้ว",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  void showErrorUserIdNotInDataBaseAlert(String userId) {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "นักศึกษารหัส $userId ไม่มีอยู่ในระบบ",
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
                      Form(
                        key: _formfield,
                        child: Column(
                          children: [
                            Center(
                              child: Column(children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 30),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: SizedBox(
                                              width: 1200,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(30.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Center(
                                                        child: Text(
                                                            "เพิ่มรายชื่อนักศึกษา",
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: const Color.fromARGB(
                                        255, 226, 226, 226),
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 5),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                      "รหัสนักศึกษา : ",
                                                      style: CustomTextStyle
                                                          .createFontStyle,
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            10), // Adjust the width for spacing
                                                    Container(
                                                      width: 500,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              top: 10.0,
                                                              right: 10.0,
                                                              bottom: 10.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: inputStuNumber!
                                                              ? Border.all(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 2.0)
                                                              : Border.all(
                                                                  color: Colors
                                                                      .green,
                                                                  width: 2.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: TextFormField(
                                                        //ปรับให้กรอกแค่ตัวเลข
                                                        keyboardType:
                                                            const TextInputType
                                                                    .numberWithOptions(
                                                                decimal: true),
                                                        inputFormatters: <
                                                            TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'^[0-9]\d*')),
                                                        ],
                                                        controller:
                                                            useridController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'กรอกรหัสประจำตัวของนักศึกษา',
                                                          hintStyle: TextStyle(
                                                              fontSize: 18,
                                                              color: inputStuNumber!
                                                                  ? Colors.red
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : Colors.black
                                                                      .withOpacity(
                                                                          0.5)),
                                                          border:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                        ),
                                                        validator:
                                                            (String? value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              inputStuNumber =
                                                                  true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              inputStuNumber =
                                                                  false;
                                                            });
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
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
                                                              sectionId:
                                                                  '${section?.id}',
                                                            );
                                                          }),
                                                          (route) => false,
                                                        );
                                                      },
                                                      child: Container(
                                                          height: 35,
                                                          width: 110,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                                "ยกเลิก",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          )),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (_formfield
                                                            .currentState!
                                                            .validate()) {
                                                          String userId =
                                                              useridController
                                                                  .text;
                                                          if (inputStuNumber ==
                                                              false) {
                                                            // เช็คว่า userId มีอยู่ใน registration หรือไม่
                                                            bool isExists =
                                                                isUserIdExists(
                                                                    userId);
                                                            if (isExists) {
                                                              // แสดง Alert หรือข้อความว่า userId มีอยู่ในระบบแล้ว
                                                              showErrorUserIdExistsAlert(
                                                                  userId);
                                                            } else {
                                                              // ทำการ addUser เมื่อ userId ไม่ซ้ำ
                                                              http.Response
                                                                  response =
                                                                  await registrationController
                                                                      .do_update(
                                                                useridController
                                                                    .text,
                                                                '${section?.id}',
                                                              );

                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                showSuccessToAddUserAlert(
                                                                    '${section?.id}');
                                                                print(
                                                                    "บันทึกสำเร็จ");
                                                              } else {
                                                                showErrorUserIdNotInDataBaseAlert(
                                                                    userId);
                                                              }
                                                            }
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                          height: 35,
                                                          width: 110,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: maincolor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                                "ยืนยัน",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
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
                ),
              ],
            ),
    );
  }
}
