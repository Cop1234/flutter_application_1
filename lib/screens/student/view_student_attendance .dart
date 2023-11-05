import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/Registration_Controller.dart';
import 'package:flutter_application_1/controller/attendanceschedule_controller.dart';
import 'package:flutter_application_1/model/registration.dart';

import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/section_controller.dart';
import '../../controller/user_controller.dart';
import '../../model/attendanceSchedule.dart';
import '../../model/section.dart';
import '../../model/user.dart';

class StudentAtten extends StatefulWidget {
  final String sectionId;
  final String regid;
  const StudentAtten({super.key, required this.sectionId, required this.regid});

  @override
  State<StudentAtten> createState() => _StudentAttenState();
}

class _StudentAttenState extends State<StudentAtten> {
  final UserController userController = UserController();
  final RegistrationController registrationController =
      RegistrationController();
  final SectionController sectionController = SectionController();
  final AttendanceScheduleController attendanceScheduleController =
      AttendanceScheduleController();
  bool? isLoaded = false;
  int? sectionid;
  String? iduser;
  late Widget statusIconWidget;

  Section? section;
  User? user;
  Registration? registration;
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
    sectionTime = DateFormat('HH:mm').parse(section?.startTime ?? "");
    sectiontype.text = section?.type ?? "";
    room.text = section?.room?.roomName ?? "";
  }

  void userData(String sectionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String? username = prefs.getString('username');
    String? username = "MJU6304106304";
    if (username != null) {
      user = await userController.get_UserByUsername(username);
      iduser = user?.id.toString();
      regData(sectionId, iduser!);
    }
    section = await sectionController.get_Section(sectionId);
    setDataToText();
    setState(() {
      isLoaded = true;
    });
  }

  TextEditingController reguserid = TextEditingController();
  TextEditingController regfname = TextEditingController();
  TextEditingController reglname = TextEditingController();
  TextEditingController regsubjecttype = TextEditingController();

  void setregData() {
    reguserid.text = registration?.user?.userid ?? "";
    regfname.text = registration?.user?.fname ?? "";
    reglname.text = registration?.user?.lname ?? "";
    regsubjecttype.text = registration?.section?.type ?? "";
  }

  void regData(String secid, String iduser) async {
    registration = await registrationController
        .get_RegistrationIdBySectionIdandIdUser(secid, iduser);
    setregData();
  }

/////////////////////////////////////////////////////////////
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> data = [];
  List<AttendanceSchedule>? attendance;
  String? Iduser;
  String? attenuserid;
  String? attenfname;
  String? attenlname;
  bool checkuseridandname = false;
  String? checkInTime;

  void showAtten(String regId) async {
    List<AttendanceSchedule> atten =
        await attendanceScheduleController.get_listAttendancebyReg(regId);

    setState(() {
      attendance = atten;
      data = atten
          .map((attenData) => {
                'userid': attenData.registration?.user?.userid ?? "",
                'fname': attenData.registration?.user?.fname ?? "",
                'lname': attenData.registration?.user?.lname ?? "",
                'week': attenData.weekNo
                    .toString(), // แก้ตรงนี้เพื่อให้แต่ละแถวมีค่า week ต่างกัน
                'time': attenData.checkInTime ?? "",
                'status': attenData.status ?? "",
              })
          .toList();
      checkInTime = data.isNotEmpty ? data[0]['time'] : null;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    userData(widget.sectionId);
    showAtten(widget.regid);
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
                  child: ListView(children: [
                    Column(
                      children: [
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
                                  color:
                                      const Color.fromARGB(255, 226, 226, 226),
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
                                              "กลุ่ม : ${sectionNumber.text}  เวลา : ${DateFormat('HH:mm').format(sectionTime)} น.  ประเภท : ${regsubjecttype.text}",
                                              style:
                                                  CustomTextStyle.mainFontStyle,
                                            ),
                                            Text(
                                              "ห้อง : ${room.text}  " +
                                                  "ตึก : ${building.text}   ",
                                              style:
                                                  CustomTextStyle.mainFontStyle,
                                            ),
                                            Text(
                                              "รหัสนักศึกษา : ${reguserid.text}  ชื่อ : ${regfname.text} ${reglname.text}",
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
                                                      150, // กำหนดความกว้างของ DataColumn
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'สัปดาห์',
                                                      style: CustomTextStyle
                                                          .TextHeadBar,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(
                                                  width:
                                                      300, // กำหนดความกว้างของ DataColumn
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'เวลา',
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
                                                      'สถานะ',
                                                      style: CustomTextStyle
                                                          .TextHeadBar,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Add more DataColumn as needed
                                            ],
                                            rows: data
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              Map<String, dynamic> row =
                                                  entry.value;

                                              return DataRow(
                                                cells: <DataCell>[
                                                  DataCell(
                                                    Container(
                                                      width: 150,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          row['week'] ?? "",
                                                          style: CustomTextStyle
                                                              .TextGeneral,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                      width: 300,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          row['time'] != null
                                                              ? DateFormat(
                                                                      'dd/MM/yyyy HH:mm:ss')
                                                                  .format(DateTime
                                                                          .parse(
                                                                              row['time'])
                                                                      .toLocal())
                                                              : "",
                                                          style: CustomTextStyle
                                                              .TextGeneral,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                      width: 150,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              row['status'],
                                                              style: CustomTextStyle
                                                                  .TextGeneral,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            statusIconWidget =
                                                                getStatusIcon(row[
                                                                    'status']),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ],
            ),
    );
  }

  Widget getStatusIcon(String statusCheck) {
    IconData iconData;
    Color iconColor;

    if (statusCheck == 'เข้าเรียนปกติ') {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
    } else if (statusCheck == 'เข้าเรียนสาย') {
      iconData = Icons.access_time;
      iconColor = Colors.orange;
    } else if (statusCheck == 'ขาดเรียน') {
      iconData = Icons.cancel;
      iconColor = Colors.red;
    } else {
      iconData = Icons.info;
      iconColor = Colors.black;
    }

    return Icon(
      iconData,
      color: iconColor,
    );
  }
}
