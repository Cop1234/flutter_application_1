import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/controller/course_controller.dart';
import 'package:flutter_application_1/controller/room_controller.dart';
import 'package:flutter_application_1/controller/section_controller.dart';
import 'package:flutter_application_1/controller/subject_controller.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/screens/teacher/list_class.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherUpdateClass extends StatefulWidget {
  final String courseId, sectionId;
  const TeacherUpdateClass(
      {super.key, required this.courseId, required this.sectionId});

  @override
  State<TeacherUpdateClass> createState() => _TeacherUpdateClassState();
}

class _TeacherUpdateClassState extends State<TeacherUpdateClass> {
  final RoomController roomController = RoomController();
  final SubjectController subjectController = SubjectController();
  final CourseController courseController = CourseController();
  final SectionController sectionController = SectionController();
  final UserController userController = UserController();

  List<Map<String, dynamic>> dataSubject = [];
  List<Map<String, dynamic>> dataRoom = [];

  bool? isLoaded = false;
  List<Room>? rooms;
  List<Subject>? subjects;
  User? userNow;

  void fetchData() async {
    List<Room> fetchedRooms = await roomController.listAllRooms();
    List<Subject> fetchedSubjects = await subjectController.listAllSubjects();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      userNow = await userController.get_UserByUsername(username);
      print("ชื่อผู้ใช้ขณะนี้ " + username);
    } else {
      print("ไม่พบข้อมูลผู้ใช้");
    }

    setState(() {
      rooms = fetchedRooms;
      subjects = fetchedSubjects;
      //
      dataRoom = fetchedRooms
          .map((room) => {
                'id': room.id,
                'roomName': room.roomName,
              })
          .toList();
      dataSubject = fetchedSubjects
          .map((subject) => {
                'id': subject.id,
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
  String selectedSemesterNow = DateFormat(' yyyy ').format(DateTime.now());
  dynamic formattedTime;

  TimeOfDay time = TimeOfDay(hour: 8, minute: 0);
  TextEditingController timePicker = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // List of items in our dropdown menu
  var Terms = ['1', '2'];
  var GStu = ['1', '2'];
  var typesub = ['LAB', 'Lecture'];
  var durationTime = ['1', '2', '3'];

  void showSuccessToCreateSubjectAlert() {
    QuickAlert.show(
      context: context,
      title: "การสร้างคลาสเรียนสำเร็จ",
      text: "ข้อมูลคลาสเรียนถุกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ListClassScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                  Text(selectedSemesterNow,
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
                                      height: 50,
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      // dropdown below..
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        value: selectedSubjectId,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        items: dataSubject.map(
                                            (Map<String, dynamic> subject) {
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
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'กรุณาเลือกวิชา';
                                          }
                                          // สามารถเพิ่มเงื่อนไขเพิ่มเติมตามความต้องการได้
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'กรุณาเลือกวิชา',
                                          border: InputBorder.none,
                                        ),
                                        icon: Icon(Icons.keyboard_arrow_down),
                                      )),
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
                                        child: TextFormField(
                                          controller: timePicker,
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
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'กรุณากรอกเวลาเริ่มเรียน';
                                            }
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly, // บังคับให้กรอกแค่ตัวเลขเท่านั้น
                                          ],
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
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
                                      height: 50,
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      // dropdown below..
                                      child: DropdownButtonFormField<String>(
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
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'กรุณาเลือกห้องเรียน';
                                          }
                                          // สามารถเพิ่มเงื่อนไขเพิ่มเติมตามความต้องการได้
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'กรุณาเลือกห้องเรียน',
                                          border: InputBorder.none,
                                        ),
                                        icon: Icon(Icons.keyboard_arrow_down),
                                      )),
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
                                        fontWeight: FontWeight.bold),
                                    primary: Colors.blue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return ListClassScreen();
                                      }));
                                    });
                                  },
                                  child: Text("ยกเลิก"),
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
                                        fontWeight: FontWeight.bold),
                                    primary: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: Text("ลบ"),
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
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      print("ผ่าน");
                                      String IdUser =
                                          userNow?.id?.toString() ?? "";
                                      // ค้นหา id ที่เกี่ยวข้องจาก dataSubject
                                      var selectedSubject =
                                          dataSubject.firstWhere(
                                        (subject) =>
                                            subject['subjectId'] ==
                                            selectedSubjectId,
                                      );
                                      // ค้นหา id ที่เกี่ยวข้องจาก dataRoom
                                      var selectedRoomName =
                                          dataRoom.firstWhere(
                                        (room) =>
                                            room['roomName'] == selectedRoom,
                                      );
                                      // ตรวจสอบว่าพบ subjectId ที่เลือกหรือไม่
                                      if (selectedSubject != null) {
                                        var IdSubject = selectedSubject['id'];
                                        print(
                                            'คุณเลือก subjectId: $selectedSubjectId โดยมี id: $IdSubject');

                                        // เรียก addCourse และรอการตอบกลับ
                                        http.Response response =
                                            await courseController.addCourse(
                                          IdSubject.toString(),
                                          IdUser,
                                          selectedTerm.toString(),
                                          selectedSemesterNow.toString(),
                                        );

                                        if (response.statusCode == 200) {
                                          // เรียก addCourse สำเร็จ

                                          // แปลง response.body ให้อยู่ในรูปแบบ JSON (หาก response เป็น JSON)
                                          Map<String, dynamic> responseBody =
                                              json.decode(response.body);

                                          // ดึง IdCourse ที่ได้รับจาก response ออกมา
                                          var IdCourse = responseBody['id'];

                                          if (selectedRoomName != null) {
                                            var IdRoom = selectedRoomName['id'];
                                            print(
                                                'คุณเลือก roomName: $selectedRoom โดยมี id: $IdRoom');
                                            List<String> parts =
                                                timePicker.text.split(':');

                                            if (parts.length == 2) {
                                              String hour = parts[0];
                                              String minute = parts[1];

                                              // เพิ่มเลข 0 ข้างหน้าของชั่วโมงและนาทีที่น้อยกว่า 10
                                              if (int.parse(hour) < 10) {
                                                hour = "0$hour";
                                              }
                                              if (int.parse(minute) < 10) {
                                                minute = "0$minute";
                                              }

                                              // สร้างเวลาในรูปแบบ "HH:mm:ss" หรือ "HH:mm"
                                              formattedTime = "$hour:$minute";
                                              print(formattedTime);
                                            } else {
                                              print(
                                                  "รูปแบบของข้อความไม่ถูกต้อง");
                                            }

                                            // เรียก addSection และรอการตอบกลับ
                                            http.Response sectionResponse =
                                                await sectionController
                                                    .addSection(
                                              formattedTime.toString(),
                                              selectedDuration.toString(),
                                              selectedGroupStu.toString(),
                                              selectedTypeSubject.toString(),
                                              IdUser.toString(),
                                              IdCourse
                                                  .toString(), // ใช้ IdCourse ที่ได้จาก response จาก addCourse
                                              IdRoom.toString(),
                                            );

                                            if (sectionResponse.statusCode ==
                                                200) {
                                              // เรียก addSection สำเร็จ
                                              showSuccessToCreateSubjectAlert();
                                              print("บันทึกสำเร็จ");
                                            }
                                          }
                                        }
                                      } else {
                                        print(
                                            'ไม่พบ subjectId: $selectedSubjectId ในรายการ');
                                      }
                                    }
                                  },
                                  child: Text("แก้ไข"),
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
  }
}
