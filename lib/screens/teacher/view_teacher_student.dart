import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/model/registration.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_editstudent.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';

import '../../color.dart';
import '../../controller/registration_Controller.dart';
import '../../controller/section_controller.dart';
import '../../model/section.dart';
import '../widget/mainTextStyle.dart';

class TeacherViewStudent extends StatefulWidget {
  final String sectionId;
  const TeacherViewStudent({super.key, required this.sectionId});

  @override
  State<TeacherViewStudent> createState() => _TeacherViewStudentState();
}

class _TeacherViewStudentState extends State<TeacherViewStudent> {
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
      registration = reg;
      data = reg
          .map((reg) => {
                'userid': reg.user?.userid ?? "",
                'fname': reg.user?.fname ?? "",
                'lname': reg.user?.lname ?? "",
              })
          .toList();
      isLoaded = true;
    });
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
                                                    "เวลา : ${DateFormat('jm').format(sectionTime)} ประเภท : ${section?.type}",
                                                style: CustomTextStyle
                                                    .mainFontStyle,
                                              ),
                                              Text(
                                                "ห้อง : ${room.text}   " +
                                                    "ตึก : ${building.text}  ",
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
                                        const SizedBox(
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
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                      return TeacherEditStudent(
                                                          sectionId:
                                                              '${section?.id}');
                                                    }));
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
                                                          "แก้ไขนักศึกษา",
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
                                                  (states) => Colors.black),
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
                                                          .TextGeneral,
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
                                                            .TextGeneral,
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
                                                            .TextGeneral,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
