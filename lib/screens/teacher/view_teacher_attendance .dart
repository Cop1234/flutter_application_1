import 'dart:async';

import 'package:download/download.dart';
import 'package:essential_xlsx/essential_xlsx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/Registration_Controller.dart';
import 'package:flutter_application_1/controller/attendanceschedule_controller.dart';
import 'package:flutter_application_1/model/registration.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_editstatus.dart';

import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';

import '../../controller/section_controller.dart';
import '../../model/attendanceSchedule.dart';
import '../../model/section.dart';
import 'package:quickalert/quickalert.dart';

class TeacherAtten extends StatefulWidget {
  final String sectionId;
  const TeacherAtten({super.key, required this.sectionId});

  @override
  State<TeacherAtten> createState() => _TeacherAttenState();
}

class _TeacherAttenState extends State<TeacherAtten> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SectionController sectionController = SectionController();
  final AttendanceScheduleController attendanceScheduleController =
      AttendanceScheduleController();
  final RegistrationController registrationController =
      RegistrationController();
  bool? isLoaded = false;
  bool? dataAttenEmpty = false;
  String qrData = 'Initial Data'; // ข้อมูล QR code ตั้งต้น
  String? namefile;
  String? selectedDropdownValue;
  int? sectionid;
  late Widget statusIconWidget;

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

  void userData(String sectionId) async {
    section = await sectionController.get_Section(sectionId);
    setDataToText();
  }

/////////////////////////////////////////////////////////////
  String weekNum = '1';
  var weekNumItems = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
  ];
  String? type;
  List<AttendanceSchedule>? attendance;
  bool checkInTimeandType = false;

  String? checkInTime;
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> dataRegStu = [];
  List<Registration> datareg = [];
  List<AttendanceSchedule> dataatt = [];
  void showAtten(String week, String secid) async {
    List<AttendanceSchedule> atten =
        await attendanceScheduleController.ReportAttenByWeek(week, secid);
    showAttenExport(week, secid);

    List<Registration> reg =
        await registrationController.do_getViewStudent(secid);
    dataAttenEmpty = false;
    if (atten.isNotEmpty) {
      setState(() {
        reg.forEach((regs) {
          var check = 1;
          var found =
              false; // เพิ่มตัวแปรเพื่อตรวจสอบว่าพบการผสมพันธุ์ของ registration และ attendance หรือไม่
          for (var att in atten) {
            if (regs.user?.userid == att.registration?.user?.userid) {
              dataatt.add(att);
              found = true;
              if (check == 1) {
                check++;
                checkInTime = DateFormat('dd-MM-yyyy')
                    .format(DateTime.parse(att.checkInTime ?? "").toLocal());
                type = regs.section?.type;
                if (checkInTime != null) {
                  checkInTimeandType = true;
                } else {
                  checkInTimeandType = false;
                }
              }
              break; // หยุดการวนลูปเมื่อพบ
            }
          }
          if (!found) {
            // ถ้าไม่พบการผสมพันธุ์ให้สร้างข้อมูลใหม่
            AttendanceSchedule newAtt = AttendanceSchedule();
            newAtt.id = 0;
            newAtt.registration = regs;
            newAtt.weekNo = int.parse(week);
            newAtt.checkInTime = "0";
            newAtt.status = "ขาดเรียน";
            dataatt.add(newAtt);
          }
        });
        dataatt.forEach((element) {
          print(
              "userid : ${element.registration?.user?.userid} week ${element.weekNo.toString()} time : ${element.checkInTime}");
        });
        attendance = atten;
        data = dataatt
            .map((atten) => {
                  'userid': atten.registration?.user?.userid ?? "",
                  'fname': atten.registration?.user?.fname ?? "",
                  'lname': atten.registration?.user?.lname ?? "",
                  'time': atten.checkInTime ?? "",
                  'type': atten.registration?.section?.type ?? "",
                  'status': atten.status ?? "",
                })
            .toList();
        namefile =
            '${subjectName.text}_Section${sectionNumber.text}_${sectiontype.text}_Week${week.toString()}';
      });
    } else {
      setState(() {
        dataAttenEmpty = true;
      });
    }
  }

//////////////////////////////////////////////////
  List<Map<String, dynamic>> dataExport = [];
  List<AttendanceSchedule>? attendanceExport;
  List<AttendanceSchedule> dataattExport = [];
  void showAttenExport(String week, String secid) async {
    List<AttendanceSchedule> atten =
        await attendanceScheduleController.ReportAttenByWeek(week, secid);
    List<Registration> reg =
        await registrationController.do_getViewStudent(secid);
    setState(() {
      reg.forEach((regs) {
        var found =
            false; // เพิ่มตัวแปรเพื่อตรวจสอบว่าพบการผสมพันธุ์ของ registration และ attendance หรือไม่
        for (var att in atten) {
          if (regs.user?.userid == att.registration?.user?.userid) {
            dataattExport.add(att);
            found = true;
            break; // หยุดการวนลูปเมื่อพบ
          }
        }
        if (!found) {
          // ถ้าไม่พบการผสมพันธุ์ให้สร้างข้อมูลใหม่
          AttendanceSchedule newAtt = AttendanceSchedule();
          newAtt.id = 0;
          newAtt.registration = regs;
          newAtt.weekNo = int.parse(week);
          newAtt.checkInTime = "0";
          newAtt.status = "ขาดเรียน";
          dataattExport.add(newAtt);
        }
      });
      dataExport = dataattExport
          .map((atten) => {
                'รหัสนักศึกษา': atten.registration?.user?.userid ?? "",
                'ชื่อ': atten.registration?.user?.fname ?? "",
                'นามสกุล': atten.registration?.user?.lname ?? "",
                'เวลาเข้าเรียน': atten.checkInTime == "0"
                    ? "-"
                    : DateFormat('dd-MM-yyyy HH:mm:ss').format(
                        DateTime.parse(atten.checkInTime ?? "").toLocal()),
                'สถานะ': atten.status ?? "",
              })
          .toList();
    });
  }

  void _download(Stream<int> bytes) {
    download(bytes, '${namefile.toString()}.xlsx');
  }

  // ignore: non_constant_identifier_names
  void ListattenExport() {
    if (dataExport.isNotEmpty) {
      final simplexlsx = SimpleXLSX();
      simplexlsx.sheetName = 'sheet';
      // เพิ่มข้อมูล
      var idx = 0;
      dataExport.forEach((item) {
        if (idx == 0) {
          // เพิ่มหัวข้อ
          simplexlsx.addRow(item.keys.toList());
        }
        // เพิ่มข้อมูล
        simplexlsx.addRow(item.values.map((i) => i.toString()).toList());
        idx++;
      });

      final bytes = simplexlsx.build();
      StreamController<int> streamController = StreamController<int>();
      bytes.forEach((int value) {
        streamController.add(value);
      });
      streamController.close();
      Stream<int> integerStream = streamController.stream;
      _download(integerStream);
    } else {
      showErrorExportExistsAlert(weekNum);
    }
  }

//////////////////////////////////////////////////

  void showErrorExportExistsAlert(String week) {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text:
          "วิชา ${subjectName.text} Section${sectionNumber.text} ${sectiontype.text} Week${week.toString()} ไม่มีข้อมูลการเข้าห้องเรียน",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  void showErrorEdit() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "ไม่สามารถแก้ไขสถานะได้เนื่องจากไม่มีข้อมูลการเข้าเรียน",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  void showErrorExport() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "ไม่สามารถดาวน์โหลดได้เนื่องจากไม่มีข้อมูลการเข้าเรียน",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  @override
  void initState() {
    super.initState();
    userData(widget.sectionId);
    showAtten(weekNum, widget.sectionId);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: isLoaded == false
          // ignore: prefer_const_constructors
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
                                            const Center(
                                                child: Text("รายการเข้าเรียน",
                                                    style: CustomTextStyle
                                                        .Textheader)),
                                            const SizedBox(
                                              height: 20,
                                            ),
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
                                              "กลุ่ม : ${sectionNumber.text}  " +
                                                  "เวลา : ${DateFormat('HH:mm').format(sectionTime)} น. ",
                                              style:
                                                  CustomTextStyle.mainFontStyle,
                                            ),
                                            Text(
                                              "ห้อง : ${room.text}   " +
                                                  "ตึก : ${building.text}   ",
                                              style:
                                                  CustomTextStyle.mainFontStyle,
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
                                  color:
                                      const Color.fromARGB(255, 226, 226, 226),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text("สัปดาห์ที่ : ",
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Container(
                                                      width: 100,
                                                      height: 40,
                                                      alignment:
                                                          AlignmentDirectional
                                                              .centerStart,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              top: 10.0,
                                                              right: 10.0,
                                                              bottom: 10.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      // dropdown below..
                                                      child: DropdownButton<
                                                          String>(
                                                        isExpanded: true,
                                                        value: weekNum,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                        items: weekNumItems.map(
                                                          (String typesub) {
                                                            return DropdownMenuItem(
                                                              value: typesub,
                                                              child:
                                                                  Text(typesub),
                                                            );
                                                          },
                                                        ).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            dataatt = [];
                                                            weekNum = newValue!;
                                                            showAtten(newValue,
                                                                '${section?.id}');
                                                          });
                                                        },
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        underline:
                                                            const SizedBox(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    dataAttenEmpty == true
                                                        ? ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      40,
                                                                  vertical: 17),
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              showErrorEdit();
                                                            },
                                                            child: const Text(
                                                                'แก้ไขสถานะ'),
                                                          )
                                                        : ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      40,
                                                                  vertical: 17),
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await Future.delayed(
                                                                  Duration
                                                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                      MaterialPageRoute(builder:
                                                                          (BuildContext
                                                                              context) {
                                                                return TeacherEditstatus(
                                                                  sectionId: widget
                                                                      .sectionId,
                                                                  weeknum:
                                                                      weekNum,
                                                                );
                                                              }));
                                                            },
                                                            child: const Text(
                                                                'แก้ไขสถานะ'),
                                                          ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    dataAttenEmpty == true
                                                        ? ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      40,
                                                                  vertical: 17),
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              showErrorExport();
                                                            },
                                                            child: const Text(
                                                                'ดาวน์โหลดการเข้าเรียน'),
                                                          )
                                                        : ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      40,
                                                                  vertical: 17),
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              ListattenExport();
                                                            },
                                                            child: const Text(
                                                                'ดาวน์โหลดการเข้าเรียน'),
                                                          ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            dataAttenEmpty == true
                                                ? AttenEmpty()
                                                : DataTable(
                                                    headingRowColor:
                                                        MaterialStateColor
                                                            .resolveWith(
                                                                (states) =>
                                                                    maincolor),
                                                    dataRowColor:
                                                        MaterialStateColor
                                                            .resolveWith(
                                                                (states) =>
                                                                    Colors
                                                                        .white),
                                                    columns: const <DataColumn>[
                                                      DataColumn(
                                                        label: SizedBox(
                                                          width:
                                                              200, // กำหนดความกว้างของ DataColumn
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
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
                                                            alignment: Alignment
                                                                .center,
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
                                                            alignment: Alignment
                                                                .center,
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
                                                            alignment: Alignment
                                                                .center,
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
                                                            alignment: Alignment
                                                                .center,
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
                                                          DataCell(Container(
                                                            width: 200,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                row['userid'],
                                                                style: CustomTextStyle
                                                                    .TextGeneral2,
                                                              ),
                                                            ),
                                                          )),
                                                          DataCell(
                                                            Container(
                                                              width: 150,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
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
                                                              width: 150,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  row['lname'],
                                                                  style: CustomTextStyle
                                                                      .TextGeneral2,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Container(
                                                              width: 150,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: row['time'] ==
                                                                        "0"
                                                                    ? const Text(
                                                                        "-",
                                                                        style: CustomTextStyle
                                                                            .TextGeneral2,
                                                                      )
                                                                    : Text(
                                                                        DateFormat('HH:mm:ss')
                                                                            .format(DateTime.parse(row['time']).toLocal()),
                                                                        style: CustomTextStyle
                                                                            .TextGeneral2,
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                          // DataCell(
                                                          //   Container(
                                                          //     width: 150,
                                                          //     child: Align(
                                                          //       alignment:
                                                          //           Alignment
                                                          //               .center,
                                                          //       child: row['time'] !=
                                                          //               null
                                                          //           ? Text(
                                                          //               DateFormat('HH:mm:ss')
                                                          //                   .format(DateTime.parse(row['time']).toLocal()),
                                                          //               style: CustomTextStyle
                                                          //                   .TextGeneral2,
                                                          //             )
                                                          //           : const Text(
                                                          //               'ข้อมูลไม่มีอยู่',
                                                          //               style: TextStyle(
                                                          //                   color:
                                                          //                       Colors.red),
                                                          //             ),
                                                          //     ),
                                                          //   ),
                                                          // ),

                                                          DataCell(
                                                            Container(
                                                              width: 150,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      row['status'],
                                                                      style: CustomTextStyle
                                                                          .TextGeneral2,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    statusIconWidget =
                                                                        getStatusIcon(
                                                                            row['status']),
                                                                  ],
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
        "วันที่เข้าเรียน : $checkInTime  ประเภท : $type",
        // "$checkInTime",
        style: CustomTextStyle.mainFontStyle,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget AttenEmpty() {
    if (dataAttenEmpty == true) {
      return const Text(
        "ไม่มีข้อมูลการเข้าห้องเรียน",
        style: TextStyle(color: Colors.red, fontSize: 20),
      );
    } else {
      return const SizedBox.shrink();
    }
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
