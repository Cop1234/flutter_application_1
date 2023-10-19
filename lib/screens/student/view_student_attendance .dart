import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/attendanceschedule_controller.dart';

import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';

import '../../controller/section_controller.dart';
import '../../model/attendanceSchedule.dart';
import '../../model/section.dart';

class StudentAtten extends StatefulWidget {
  final String sectionId;
  final String idUser;
  const StudentAtten(
      {super.key, required this.sectionId, required this.idUser});

  @override
  State<StudentAtten> createState() => _StudentAttenState();
}

class _StudentAttenState extends State<StudentAtten> {
  final SectionController sectionController = SectionController();
  final AttendanceScheduleController attendanceScheduleController =
      AttendanceScheduleController();
  bool? isLoaded = false;
  String qrData = 'Initial Data'; // ข้อมูล QR code ตั้งต้น

  String? selectedDropdownValue;

  int? sectionid;

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
    sectionTime = DateFormat('HH:mm').parse(section?.startTime ?? "");
    sectiontype.text = section?.type ?? "";
    room.text = section?.room?.roomName ?? "";
  }

  void userData(String sectionId) async {
    section = await sectionController.get_Section(sectionId);
    setDataToText();
    setState(() {
      isLoaded = true;
    });
  }

/////////////////////////////////////////////////////////////
  String weekNum = '1';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  void showAtten(String week, String secid, String idUser) async {
    print(week + " : " + secid + " : " + idUser);
    List<AttendanceSchedule> atten = await attendanceScheduleController
        .get_ListAttendanceStudent(week, secid, idUser);

    print(atten);
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

      if (checkInTime != null && type != null) {
        checkInTimeandType = true;
      } else {
        checkInTimeandType = false;
      }
    });
  }

  String? Iduser;
  @override
  void initState() {
    super.initState();

    userData(widget.sectionId);
    showAtten(weekNum, widget.sectionId, widget.idUser);
    setState(() {
      Iduser = widget.idUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: ListView(children: [
        const NavbarStudent(),
        Column(
          children: [
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("สัปดาห์ที่ : ",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    width: 150,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: weekNum,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      items: weekNumItems.map(
                                        (String typesub) {
                                          return DropdownMenuItem(
                                            value: typesub,
                                            child: Text(typesub),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        //print('USERID : ' + Iduser!);
                                        setState(() {
                                          weekNum = newValue!;
                                          showAtten(newValue, '${section?.id}',
                                              Iduser!);
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DataTable(
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => maincolor),
                                dataRowColor: MaterialStateColor.resolveWith(
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
                                          style: CustomTextStyle.TextHeadBar,
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
                                          style: CustomTextStyle.TextHeadBar,
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
                                          style: CustomTextStyle.TextHeadBar,
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
                                          style: CustomTextStyle.TextHeadBar,
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
                                          style: CustomTextStyle.TextHeadBar,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Add more DataColumn as needed
                                ],
                                rows: data.asMap().entries.map((entry) {
                                  Map<String, dynamic> row = entry.value;
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Container(
                                        width: 200,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            row['userid'],
                                            style: CustomTextStyle.TextGeneral,
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
                                              style:
                                                  CustomTextStyle.TextGeneral,
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
                                              style:
                                                  CustomTextStyle.TextGeneral,
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
                                              DateFormat('HH:mm:ss').format(
                                                  DateTime.parse(row['time'])
                                                      .toLocal()),
                                              style:
                                                  CustomTextStyle.TextGeneral,
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
                                              row['status'],
                                              style:
                                                  CustomTextStyle.TextGeneral,
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
        )
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget TimeAndType() {
    if (checkInTimeandType) {
      return Text(
        "วันที่เข้าเรียน : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(checkInTime!).toLocal())}  ประเภm : ${type ?? ""}   ",
        style: CustomTextStyle.mainFontStyle,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
