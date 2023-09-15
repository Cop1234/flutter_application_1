import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/room_controller.dart';
import 'package:flutter_application_1/controller/subject_controller.dart';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class TeacherCreateSub extends StatefulWidget {
  const TeacherCreateSub({super.key});

  @override
  State<TeacherCreateSub> createState() => _TeacherCreateSubState();
}

class _TeacherCreateSubState extends State<TeacherCreateSub> {
  final RoomController roomController = RoomController();
  final SubjectController subjectController = SubjectController();

  List<Map<String, dynamic>> dataSubject = [];
  List<Map<String, dynamic>> dataRoom = [];

  bool? isLoaded = false;
  List<Room>? rooms;
  List<Subject>? subjects;

  void fetchData() async {
    List<Room> fetchedRooms = await roomController.listAllRooms();
    List<Subject> fetchedSubjects = await subjectController.listAllSubjects();

    setState(() {
      rooms = fetchedRooms;
      subjects = fetchedSubjects;
      //
      dataRoom = fetchedRooms
          .map((room) => {
                'roomName': room.roomName,
              })
          .toList();
      dataSubject = fetchedSubjects
          .map((subject) => {
                'subjectId': subject.subjectId,
              })
          .toList();
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String selectedTerm = '1';
  String selectedGroupStu = '1';
  dynamic selectedSubjectId;
  String selectedDuration = '1';
  String selectedTypeSubject = 'LAB';
  dynamic selectedRoom;

  TimeOfDay time = TimeOfDay(hour: 8, minute: 0);
  TextEditingController timePicker = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // List of items in our dropdown menu
  var Terms = ['1', '2'];
  var GStu = ['1', '2'];
  var typesub = ['LAB', 'Lecture'];
  var durationTime = ['1', '2', '3'];

  @override
  Widget build(BuildContext context) {
    //final format = DateFormat("yyyy-MM-dd HH:mm");
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
        body: ListView(children: [
          Column(children: [
            NavbarTeacher(),
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color.fromARGB(255, 226, 226, 226),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 700,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //p1
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Text("ปีการศึกษา : ",
                                      style: CustomTextStyle.createFontStyle),
                                  Text(
                                      DateFormat(' yyyy ')
                                          .format(DateTime.now()),
                                      style: CustomTextStyle.createFontStyle)
                                ],
                              ),
                            ),
                            //p2
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "เทอม : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  //ปุ่มเลือกเทอม
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedTerm,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      items: Terms.map(
                                        (String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedTerm = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p3
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "รหัสวิชา : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  //ปุ่มเลือกรหัสวิชา
                                  Container(
                                    width: 150,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedSubjectId,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      items: dataSubject
                                          .map((Map<String, dynamic> subject) {
                                        return DropdownMenuItem<String>(
                                          value: subject['subjectId'],
                                          child: Text(subject['subjectId']),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedSubjectId = newValue;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p4
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "กลุ่มเรียน : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  //ปุ่มเลือกกลุ่มเรียน
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedGroupStu,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      items: GStu.map(
                                        (String GStu) {
                                          return DropdownMenuItem(
                                            value: GStu,
                                            child: Text(GStu),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedGroupStu = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p5
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "เวลาเริ่มเรียน : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  //เลือกเวลาเรียน
                                  Container(
                                    width: 300,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 5),
                                        child: TextField(
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                          onTap: () async {
                                            TimeOfDay? newTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime: time);
                                            if (newTime == null) {
                                              return;
                                            }
                                            setState(() {
                                              time = newTime;
                                              timePicker.text =
                                                  time.hour.toString() +
                                                      ":" +
                                                      time.minute.toString();
                                              print(time.hour);
                                            });
                                          },
                                          controller: timePicker,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p6
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "ระยะเวลาเรียน : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  //ปุ่มเลือกระยะเวลาเรียน
                                  Container(
                                    width: 300,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedDuration,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      items: durationTime.map(
                                        (String durationTime) {
                                          return DropdownMenuItem(
                                            value: durationTime,
                                            child: Text(durationTime),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedDuration = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                  Text(
                                    " ชั่วโมง",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                ],
                              ),
                            ),
                            //p7
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "ประเภท : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  //ปุ่มเลือกประเภท
                                  Container(
                                    width: 150,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedTypeSubject,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      items: typesub.map(
                                        (String typesub) {
                                          return DropdownMenuItem(
                                            value: typesub,
                                            child: Text(typesub),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedTypeSubject = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p8
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "ห้องเรียน : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  //ปุ่มเลือกห้องเรียน
                                  Container(
                                    width: 300,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedRoom,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      items: dataRoom
                                          .map((Map<String, dynamic> room) {
                                        return DropdownMenuItem<String>(
                                          value: room['roomName'],
                                          child: Text(room['roomName']),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedRoom = newValue;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    setState(() {
                                      selectedTerm = "1";
                                      selectedSubjectId = null;
                                      selectedGroupStu = "1";
                                      selectedDuration = "1";
                                      timePicker.text = "";
                                      selectedTypeSubject = "LAB";
                                      selectedRoom = null;
                                    });
                                  },
                                  child: Text("รีเซ็ต"),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {},
                                  child: Text("ยืนยัน"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ]));
    ;
  }
}
