import 'dart:async';

import 'package:download/download.dart';
import 'package:essential_xlsx/essential_xlsx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/attendanceschedule_controller.dart';
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
  bool? isLoaded = false;
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
  List<Map<String, dynamic>> data = [];
  List<AttendanceSchedule>? attendance;
  String? checkInTime;
  String? type;
  bool checkInTimeandType = false;

  void showAtten(String week, String secid) async {
    List<AttendanceSchedule> atten =
        await attendanceScheduleController.ReportAttenByWeek(week, secid);
    showAttenExport(week, secid);
    setState(() {
      attendance = atten;
      data = atten
          .map((atten) => {
                'userid': atten.registration?.user?.userid ?? "",
                'fname': atten.registration?.user?.fname ?? "",
                'lname': atten.registration?.user?.lname ?? "",
                'time': atten.checkInTime ?? "",
                'type': atten.registration?.section?.type ?? "",
                'status': atten.status ?? "",
              })
          .toList();
      checkInTime = data.isNotEmpty ? data[0]['time'] : null;
      type = data.isNotEmpty ? data[0]['type'] : null;
      namefile =
          '${subjectName.text}_Section${sectionNumber.text}_${sectiontype.text}_Week${week.toString()}';

      if (checkInTime != null && type != null) {
        checkInTimeandType = true;
      } else {
        checkInTimeandType = false;
      }
    });
  }

//////////////////////////////////////////////////
  List<Map<String, dynamic>> dataExport = [];
  List<AttendanceSchedule>? attendanceExport;

  void showAttenExport(String week, String secid) async {
    List<AttendanceSchedule> atten =
        await attendanceScheduleController.ReportAttenByWeek(week, secid);
    setState(() {
      attendanceExport = atten;
      dataExport = atten
          .map((atten) => {
                'รหัสนักศึกษา': atten.registration?.user?.userid ?? "",
                'ชื่อ': atten.registration?.user?.fname ?? "",
                'นามสกุล': atten.registration?.user?.lname ?? "",
                'เวลาเข้าเรียน': DateFormat('dd-MM-yyyy HH:mm:ss')
                    .format(DateTime.parse(atten.checkInTime ?? "").toLocal()),
                'สถานะ': atten.status ?? "",
              })
          .toList();
      isLoaded = true;
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

  @override
  void initState() {
    super.initState();
    userData(widget.sectionId);
    showAtten(weekNum, widget.sectionId);
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
                                                child: Text("ดูรายการเข้าเรียน",
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
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
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
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 40,
                                                                vertical: 15),
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20.0), // กำหนดมุม
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        await Future.delayed(
                                                            Duration
                                                                .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(builder:
                                                                    (BuildContext
                                                                        context) {
                                                          return TeacherEditstatus(
                                                            sectionId: widget
                                                                .sectionId,
                                                            weeknum: weekNum,
                                                          );
                                                        }));
                                                      },
                                                      child: const Text(
                                                          'แก้ไขสถานะ'),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 40,
                                                                vertical: 17),
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20.0), // กำหนดมุม
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        ListattenExport();
                                                      },
                                                      child: const Text(
                                                          'ExportReport'),
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
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          maincolor),
                                              dataRowColor: MaterialStateColor
                                                  .resolveWith(
                                                      (states) => Colors.white),
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: SizedBox(
                                                    width:
                                                        200, // กำหนดความกว้างของ DataColumn
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
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
                                                      alignment:
                                                          Alignment.center,
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
                                                      alignment:
                                                          Alignment.center,
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
                                                      alignment:
                                                          Alignment.center,
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
                                                      alignment:
                                                          Alignment.center,
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
                                                            Alignment.center,
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
                                                        width: 150,
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
                                                    DataCell(
                                                      Container(
                                                        width: 150,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            DateFormat(
                                                                    'HH:mm:ss')
                                                                .format(DateTime
                                                                        .parse(row[
                                                                            'time'])
                                                                    .toLocal()),
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
                                                              Alignment.center,
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
        "วันที่เข้าเรียน : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(checkInTime!).toLocal())}  ประเภท : ${type ?? ""}   ",
        style: CustomTextStyle.mainFontStyle,
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
