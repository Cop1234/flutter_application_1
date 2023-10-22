import 'dart:async';

import 'package:download/download.dart';
import 'package:essential_xlsx/essential_xlsx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/attendanceschedule_controller.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_attendance%20.dart';

import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';

import '../../controller/section_controller.dart';
import '../../model/attendanceSchedule.dart';
import '../../model/section.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class TeacherEditstatus extends StatefulWidget {
  final String weeknum;
  final String sectionId;

  const TeacherEditstatus(
      {super.key, required this.weeknum, required this.sectionId});

  @override
  State<TeacherEditstatus> createState() => _TeacherEditstatusState();
}

class _TeacherEditstatusState extends State<TeacherEditstatus> {
  final SectionController sectionController = SectionController();
  final AttendanceScheduleController attendanceScheduleController =
      AttendanceScheduleController();
  bool? isLoaded = false;

  String? selectedDropdownValue;
  int? sectionid;
  // ignore: non_constant_identifier_names
  String? WeekNo;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> data = [];
  List<AttendanceSchedule>? attendance;
  String? checkInTime;
  String? type;
  bool checkInTimeandType = false;

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

  void userData(String week, String sectionId) async {
    section = await sectionController.get_Section(sectionId);
    setDataToText();

    List<AttendanceSchedule> atten = await attendanceScheduleController
        .listAttendanceScheduleByWeek(week, sectionId);

    print('week : ' + week + 'secid' + sectionId);
    setState(() {
      attendance = atten;
      data = atten
          .map((atten) => {
                'attenid': atten.id.toString(),
                'userid': atten.registration?.user?.userid ?? "",
                'fname': atten.registration?.user?.fname ?? "",
                'lname': atten.registration?.user?.lname ?? "",
                'time': atten.checkInTime ?? "",
                'type': atten.registration?.section?.type ?? "",
                'status': atten.status ?? "",
                'week': atten.weekNo.toString(),
                'regid': atten.registration ?? "",
              })
          .toList();
      checkInTime = data.isNotEmpty ? data[0]['time'] : null;
      type = data.isNotEmpty ? data[0]['type'] : null;
      WeekNo = data.isNotEmpty ? data[0]['week'] : null;
      if (checkInTime != null && type != null) {
        checkInTimeandType = true;
      } else {
        checkInTimeandType = false;
      }
      isLoaded = true;
    });
  }

  List<String> statusOptions = ['เข้าเรียนปกติ', 'เข้าเรียนสาย', 'ขาดเรียน'];

///////////////////////////////////////////////////////////////////

  void showSuccessToChangeUserAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้ไขสถานะสำเร็จ",
      text: "ข้อมูลสถานะถูกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return TeacherAtten(sectionId: widget.sectionId);
        }));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print("weekNum sectionId :" + widget.weeknum + widget.sectionId);
    userData(widget.weeknum, widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const NavbarTeacher(),
          Expanded(
            child: ListView(children: [
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
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
                            color: const Color.fromARGB(255, 226, 226, 226),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 1200,
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "รหัสวิชา : ${subjectid.text}",
                                        style: CustomTextStyle.mainFontStyle,
                                      ),
                                      Text(
                                        "ชื่อวิชา : ${subjectName.text}",
                                        style: CustomTextStyle.mainFontStyle,
                                      ),
                                      Text(
                                        "อาจารย์ : ${teacherFName.text} ${teacherLName.text}",
                                        style: CustomTextStyle.mainFontStyle,
                                      ),
                                      Text(
                                        "กลุ่ม : ${sectionNumber.text}   " +
                                            "เวลา : ${DateFormat('jm').format(sectionTime)}   ",
                                        style: CustomTextStyle.mainFontStyle,
                                      ),
                                      Text(
                                        "ห้อง : ${room.text}   " +
                                            "ตึก : ${building.text}   ",
                                        style: CustomTextStyle.mainFontStyle,
                                      ),
                                      TimeAndType(),
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
                          horizontal: 20, vertical: 20),
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
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 40,
                                                      vertical: 15),
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0), // กำหนดมุม
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  List<Map<String, dynamic>>
                                                      updatedData =
                                                      data.map((row) {
                                                    return {
                                                      'id': row['attenid'],
                                                      'status': row['status'],
                                                    };
                                                  }).toList();

                                                  // เรียกใช้ updateAttendanceSchedules ด้วยรายการที่ถูกแก้ไข
                                                  // await attendanceScheduleController
                                                  //     .updateAttendanceStatus(
                                                  //         updatedData);
                                                  await Future.delayed(Duration
                                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                  await attendanceScheduleController
                                                      .updateAttendanceStatus(
                                                          updatedData)
                                                      .then((result) {
                                                    if (result.statusCode ==
                                                        200) {
                                                      showSuccessToChangeUserAlert();
                                                      print("บันทึกสำเร็จ");
                                                    }
                                                  });
                                                },
                                                child: const Text('ตกลง'),
                                              ),
                                            ],
                                          )
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
                                                  150, // กำหนดความกว้างของ DataColumn
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
                                                  150, // กำหนดความกว้างของ DataColumn
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
                                                  150, // กำหนดความกว้างของ DataColumn
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
                                        rows: data.asMap().entries.map((entry) {
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
                                                  width: 150,
                                                  child: Align(
                                                    alignment: Alignment.center,
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
                                                  width: 150,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      row['lname'],
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
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      DateFormat('HH:mm:ss')
                                                          .format(DateTime
                                                                  .parse(row[
                                                                      'time'])
                                                              .toLocal()),
                                                      style: CustomTextStyle
                                                          .TextGeneral,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                DropdownButton<String>(
                                                  value: row[
                                                      'status'], // ใช้ค่า status จาก data เป็นค่าเริ่มต้น
                                                  items: statusOptions
                                                      .map((String status) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: status,
                                                      child: Text(
                                                        status,
                                                        style: CustomTextStyle
                                                            .TextGeneral,
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? selectedStatus) {
                                                    setState(() {
                                                      row['status'] =
                                                          selectedStatus;
                                                    });
                                                  },
                                                  style: CustomTextStyle
                                                          .TextGeneral
                                                      .copyWith(
                                                          color: Colors
                                                              .white), // กำหนดสีข้อความของ Dropdown เมื่อไม่เปิดออกมา
                                                  dropdownColor: Colors.grey,
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
                        ],
                      ),
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

  // ignore: non_constant_identifier_names
  Widget TimeAndType() {
    if (checkInTimeandType) {
      return Text(
        "วันที่เข้าเรียน : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(checkInTime!).toLocal())}  ประเภท : ${type ?? ""}  Week:${WeekNo} ",
        style: CustomTextStyle.mainFontStyle,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
