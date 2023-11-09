import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/course_controller.dart';
import 'package:flutter_application_1/controller/room_controller.dart';
import 'package:flutter_application_1/controller/section_controller.dart';
import 'package:flutter_application_1/controller/subject_controller.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/model/course.dart';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/screens/teacher/list_class.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

class TeacherUpdateClass extends StatefulWidget {
  final String courseId, sectionId;
  const TeacherUpdateClass(
      {super.key, required this.courseId, required this.sectionId});

  @override
  State<TeacherUpdateClass> createState() => _TeacherUpdateClassState();
}

class _TeacherUpdateClassState extends State<TeacherUpdateClass> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RoomController roomController = RoomController();
  final SubjectController subjectController = SubjectController();
  final CourseController courseController = CourseController();
  final SectionController sectionController = SectionController();
  final UserController userController = UserController();

  List<Map<String, dynamic>> dataSubject = [];
  List<Map<String, dynamic>> dataRoom = [];
  List<Section> allSections = [];

  bool? isLoaded = false;
  bool? checkSelectSubjectId = false;
  bool? checkSelectStartTime = false;
  bool? checkSelectRoomName = false;
  bool? inputGroupNumber = false;
  bool? isConflicting = false;
  List<Room>? rooms;
  List<Subject>? subjects;
  Course? course;
  Section? section;
  User? userNow;
  String? selectedTerm;
  String? selectedGroupStu;
  dynamic selectedSubjectId;
  String? selectedStartTime;
  String? selectedDuration;
  String? selectedTypeSubject;
  dynamic selectedRoom;
  String? selectedSemesterNow;
  dynamic formattedTime;
  dynamic courseIdNow;
  dynamic sectionIdNow;
  Alignment textHeaderbar = Alignment.centerLeft;

  void fetchData(String courseId, String sectionId) async {
    List<Room> fetchedRooms = await roomController.listAllRooms();
    List<Subject> fetchedSubjects = await subjectController.listAllSubjects();
    allSections = await sectionController.listAllSection();

    course = await courseController.get_Course(courseId);
    section = await sectionController.get_Section(sectionId);

    courseIdNow = courseId;
    sectionIdNow = sectionId;
    selectedTerm = course?.term.toString();
    selectedGroupStu = section?.sectionNumber.toString();
    selectedSubjectId = course?.subject?.subjectId;
    selectedDuration = section?.duration.toString();
    selectedTypeSubject = section?.type;
    selectedRoom = section?.room?.roomName;
    selectedSemesterNow = course?.semester.toString();
    String formattedTime = section?.startTime ?? "";
    if (formattedTime.isNotEmpty) {
      try {
        final DateTime parsedTime = DateTime.parse("1970-01-01 $formattedTime");
        selectedStartTime = DateFormat('HH:mm').format(parsedTime);
      } catch (e) {
        selectedStartTime = "Invalid Time";
      }
    }
    print("CheckTime - ${selectedStartTime}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "Tanakorn63@gmail.com";
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
                'building': room.building,
                'latitude': room.latitude,
                'longitude': room.longitude,
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
    fetchData(widget.courseId, widget.sectionId);
  }

  // List of items in our dropdown menu
  var terms = ['1', '2'];
  var typesub = ['ปฏิบัติการ', 'บรรยาย'];
  var startTime = [
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
  ];
  var durationTime = ['1', '2', '3', '4'];

  void checkForConflicts(String sectionId, List<Section> allSections,
      String sectionIdToCreate, String typeToCreate, String groupStuToCreate) {
    isConflicting = allSections.any((section) {
      return section.id.toString() != sectionId &&
          section.course?.subject?.subjectId == sectionIdToCreate &&
          section.type == typeToCreate &&
          section.sectionNumber == groupStuToCreate;
    });
  }

  void showSuccessToUpdateClassAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้ไขคลาสเรียนสำเร็จ",
      text: "ข้อมูลคลาสเรียนถุกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      barrierDismissible: false,
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ListClassScreen(),
          ),
        );
      },
    );
  }

  void showClassAlreadyHaveAlert() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน!",
      text:
          "คลาสเรียนรหัส $selectedSubjectId และประเภท $selectedTypeSubject ของกลุ่ม $selectedGroupStu มีอยู่แล้ว",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  void showSureToDeleteClass(String idsection, String idcourse) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการลบข้อมูลคลาสเรียนหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        onConfirmBtnTap: () async {
          http.Response response =
              await sectionController.deleteSection(idsection);

          if (response.statusCode == 200) {
            http.Response response2 =
                await courseController.deleteCourse(idcourse);
            if (response2.statusCode == 200) {
              Navigator.pop(context);
              showUpDeleteClassSuccessAlert();
            } else {
              showFailToDeleteClassAlert();
            }
          } else {
            showFailToDeleteClassAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToDeleteClassAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถลบข้อมูลได้",
        type: QuickAlertType.error);
  }

  void showUpDeleteClassSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        barrierDismissible: false,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ListClassScreen()));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
        // ฟังชั้น โหลดข้อมูล
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
                    Column(children: [
                      Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 1000,
                                  child: Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Column(children: [
                                        const Text(
                                          "การแก้ไขข้อมูลคลาสเรียน",
                                          style: TextStyle(
                                              fontSize: 50,
                                              color: maincolor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20),
                                        //Tableหลัก
                                        Table(
                                          //border: TableBorder.all(),
                                          columnWidths: const {
                                            0: FractionColumnWidth(0.25),
                                            1: FractionColumnWidth(0.5),
                                          },
                                          defaultColumnWidth:
                                              const FixedColumnWidth(300.0),
                                          children: [
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      alignment: textHeaderbar,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: const Text(
                                                          "ปีการศึกษา",
                                                          style: CustomTextStyle
                                                              .createFontStyle),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12.0,
                                                              top: 17.0,
                                                              right: 12.0,
                                                              bottom: 12.0),
                                                      alignment: Alignment
                                                          .centerLeft, // ชิดซ้าย
                                                      child: Text(
                                                          selectedSemesterNow!,
                                                          style: CustomTextStyle
                                                              .createFontStyle),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      alignment: textHeaderbar,
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: const Text(
                                                        "เทอม",
                                                        style: CustomTextStyle
                                                            .createFontStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: Container(
                                                        //width: 50,
                                                        height: 50,
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerStart,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0,
                                                                top: 5.0,
                                                                right: 10.0,
                                                                bottom: 5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 2.0),
                                                        ),
                                                        // dropdown below..
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          value: selectedTerm,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                          items: terms.map(
                                                            (String items) {
                                                              return DropdownMenuItem(
                                                                value: items,
                                                                child:
                                                                    Text(items),
                                                              );
                                                            },
                                                          ).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedTerm =
                                                                  newValue!;
                                                            });
                                                          },
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_down),
                                                          underline:
                                                              const SizedBox(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      alignment: textHeaderbar,
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: const Text(
                                                        "รหัสวิชา",
                                                        style: CustomTextStyle
                                                            .createFontStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: Container(
                                                          width: 150,
                                                          height: 50,
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
                                                              color:
                                                                  Colors.white,
                                                              border: checkSelectSubjectId!
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          2.0)
                                                                  : Border.all(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          // dropdown below..
                                                          child: DropdownButtonFormField<
                                                              String>(
                                                            isExpanded: true,
                                                            value:
                                                                selectedSubjectId,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                            items: dataSubject
                                                                .map((Map<
                                                                        String,
                                                                        dynamic>
                                                                    subject) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: subject[
                                                                    'subjectId'],
                                                                child: Text(subject[
                                                                    'subjectId']),
                                                              );
                                                            }).toList(),
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                selectedSubjectId =
                                                                    newValue;
                                                              });
                                                            },
                                                            validator: (String?
                                                                value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                setState(() {
                                                                  checkSelectSubjectId =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  checkSelectSubjectId =
                                                                      false;
                                                                });
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration
                                                                    .collapsed(
                                                              hintText:
                                                                  'เลือกรหัสวิชา',
                                                              hintStyle: TextStyle(
                                                                  fontSize: 18,
                                                                  color: checkSelectSubjectId!
                                                                      ? Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.5)
                                                                      : Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5)), // กำหนดสีข้อความเป็นสีแดงเมื่อมีข้อผิดพลาด
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      alignment: textHeaderbar,
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: const Text(
                                                        "กลุ่มเรียน",
                                                        style: CustomTextStyle
                                                            .createFontStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                top: 8.0,
                                                                right: 8.0,
                                                                bottom: 8.0),
                                                        child: Container(
                                                          width: 120,
                                                          height: 50,
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .centerStart,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20.0,
                                                                  top: 12.5,
                                                                  right: 10.0,
                                                                  bottom: 10.0),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: inputGroupNumber!
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          2.0)
                                                                  : Border.all(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          // dropdown below..
                                                          child: TextFormField(
                                                            //ปรับให้กรอกแค่ตัวเลข
                                                            keyboardType:
                                                                const TextInputType
                                                                        .numberWithOptions(
                                                                    decimal:
                                                                        true),
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'^[1-9]\d*')),
                                                            ],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                            initialValue:
                                                                selectedGroupStu, // กำหนดค่าเริ่มต้น
                                                            onChanged:
                                                                (String value) {
                                                              setState(() {
                                                                selectedGroupStu =
                                                                    value;
                                                              });
                                                            },
                                                            validator: (String?
                                                                value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                setState(() {
                                                                  inputGroupNumber =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  inputGroupNumber =
                                                                      false;
                                                                });
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              errorBorder:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  'ระบุกลุ่มเรียนเป็นตัวเลข เช่น 1 2',
                                                              hintStyle: TextStyle(
                                                                  fontSize: 18,
                                                                  color: inputGroupNumber!
                                                                      ? Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.5)
                                                                      : Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5)),
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      alignment: textHeaderbar,
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: const Text(
                                                        "เวลาเริ่มเรียน",
                                                        style: CustomTextStyle
                                                            .createFontStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: //ปุ่มเลือกระยะเวลาเรียน
                                                          Container(
                                                        width: 300,
                                                        height: 50,
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerStart,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0,
                                                                top: 10.0,
                                                                right: 10.0,
                                                                bottom: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 2.0),
                                                        ),
                                                        // dropdown below..
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          value:
                                                              selectedStartTime,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                          items: startTime.map(
                                                            (String startTime) {
                                                              return DropdownMenuItem(
                                                                value:
                                                                    startTime,
                                                                child: Text(
                                                                    startTime),
                                                              );
                                                            },
                                                          ).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedStartTime =
                                                                  newValue!;
                                                            });
                                                          },
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_down),
                                                          underline:
                                                              const SizedBox(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      alignment: textHeaderbar,
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: const Text(
                                                        "ระยะเวลาเรียน",
                                                        style: CustomTextStyle
                                                            .createFontStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: //ปุ่มเลือกระยะเวลาเรียน
                                                          Container(
                                                        width: 300,
                                                        height: 50,
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerStart,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0,
                                                                top: 10.0,
                                                                right: 10.0,
                                                                bottom: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 2.0),
                                                        ),
                                                        // dropdown below..
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          value:
                                                              selectedDuration,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                          items:
                                                              durationTime.map(
                                                            (String
                                                                durationTime) {
                                                              return DropdownMenuItem(
                                                                value:
                                                                    durationTime,
                                                                child: Text(
                                                                    durationTime),
                                                              );
                                                            },
                                                          ).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedDuration =
                                                                  newValue!;
                                                            });
                                                          },
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_down),
                                                          underline:
                                                              const SizedBox(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      alignment: textHeaderbar,
                                                      child: const Text(
                                                        "ประเภท",
                                                        style: CustomTextStyle
                                                            .createFontStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: //ปุ่มเลือกประเภท
                                                          Container(
                                                        width: 150,
                                                        height: 50,
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerStart,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0,
                                                                top: 10.0,
                                                                right: 10.0,
                                                                bottom: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 2.0),
                                                        ),
                                                        // drdown below..
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          value:
                                                              selectedTypeSubject,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                          items: typesub.map(
                                                            (String typesub) {
                                                              return DropdownMenuItem(
                                                                value: typesub,
                                                                child: Text(
                                                                    typesub),
                                                              );
                                                            },
                                                          ).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedTypeSubject =
                                                                  newValue!;
                                                            });
                                                          },
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_down),
                                                          underline:
                                                              const SizedBox(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      alignment: textHeaderbar,
                                                      child: const Text(
                                                        "ห้องเรียน",
                                                        style: CustomTextStyle
                                                            .createFontStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: //ปุ่มเลือกห้องเรียน
                                                          Container(
                                                              width: 300,
                                                              height: 50,
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .centerStart,
                                                              padding: const EdgeInsets
                                                                      .only(
                                                                  left: 20.0,
                                                                  top: 10.0,
                                                                  right: 10.0,
                                                                  bottom: 10.0),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  border: checkSelectRoomName!
                                                                      ? Border.all(
                                                                          color: Colors
                                                                              .red,
                                                                          width:
                                                                              2.0)
                                                                      : Border.all(
                                                                          color: Colors
                                                                              .green,
                                                                          width:
                                                                              2.0),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10)),
                                                              // dropdown below..
                                                              child:
                                                                  DropdownButtonFormField<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                value:
                                                                    selectedRoom,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                                items: dataRoom
                                                                    .map((Map<
                                                                            String,
                                                                            dynamic>
                                                                        room) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value: room[
                                                                        'roomName'],
                                                                    child: Text(
                                                                        '${room['building']} - ${room['roomName']}'),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
                                                                    selectedRoom =
                                                                        newValue;
                                                                  });
                                                                },
                                                                validator:
                                                                    (String?
                                                                        value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    checkSelectRoomName =
                                                                        true;
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      checkSelectRoomName =
                                                                          false;
                                                                    });
                                                                  }
                                                                  // สามารถเพิ่มเงื่อนไขเพิ่มเติมตามความต้องการได้
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration.collapsed(
                                                                    hintText:
                                                                        'เลือกห้องเรียน',
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: checkSelectRoomName!
                                                                            ? Colors.red.withOpacity(
                                                                                0.5)
                                                                            : Colors.black.withOpacity(
                                                                                0.5)),
                                                                    border:
                                                                        InputBorder
                                                                            .none),
                                                                icon: const Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down),
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: const Text(
                                                        "",
                                                        style: CustomTextStyle
                                                            .createFontStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 30.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: //ปุ่มเลือกห้องเรียน
                                                          Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0), // กำหนดมุม
                                                                    ),
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            80,
                                                                        vertical:
                                                                            15),
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                            onPressed:
                                                                () async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                print("ผ่าน");
                                                                String IdUser =
                                                                    userNow?.id
                                                                            ?.toString() ??
                                                                        "";
                                                                // ค้นหา id ที่เกี่ยวข้องจาก dataSubject
                                                                var selectedSubject =
                                                                    dataSubject
                                                                        .firstWhere(
                                                                  (subject) =>
                                                                      subject[
                                                                          'subjectId'] ==
                                                                      selectedSubjectId,
                                                                );
                                                                // ค้นหา id ที่เกี่ยวข้องจาก dataRoom
                                                                var selectedRoomName =
                                                                    dataRoom
                                                                        .firstWhere(
                                                                  (room) =>
                                                                      room[
                                                                          'roomName'] ==
                                                                      selectedRoom,
                                                                );
                                                                // ตรวจสอบว่าพบ subjectId ที่เลือกหรือไม่
                                                                if (checkSelectSubjectId == false &&
                                                                    checkSelectStartTime ==
                                                                        false &&
                                                                    checkSelectRoomName ==
                                                                        false &&
                                                                    inputGroupNumber ==
                                                                        false) {
                                                                  checkForConflicts(
                                                                      sectionIdNow,
                                                                      allSections,
                                                                      selectedSubjectId,
                                                                      selectedTypeSubject!,
                                                                      selectedGroupStu!);
                                                                  if (isConflicting ==
                                                                      false) {
                                                                    var IdSubject =
                                                                        selectedSubject[
                                                                            'id'];
                                                                    print(
                                                                        'คุณเลือก subjectId: $selectedSubjectId โดยมี id: $IdSubject');

                                                                    http.Response
                                                                        response =
                                                                        await courseController
                                                                            .updateCourse(
                                                                      courseIdNow
                                                                          .toString(),
                                                                      IdSubject
                                                                          .toString(),
                                                                      IdUser,
                                                                      selectedTerm
                                                                          .toString(),
                                                                      selectedSemesterNow
                                                                          .toString(),
                                                                    );

                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      // เรียก addCourse สำเร็จ
                                                                      print(
                                                                          "addCourse สำเร็จ");
                                                                      // แปลง response.body ให้อยู่ในรูปแบบ JSON (หาก response เป็น JSON)
                                                                      Map<String,
                                                                              dynamic>
                                                                          responseBody =
                                                                          json.decode(
                                                                              response.body);

                                                                      if (selectedRoomName !=
                                                                          null) {
                                                                        var IdRoom =
                                                                            selectedRoomName['id'];

                                                                        http.Response
                                                                            sectionResponse =
                                                                            await sectionController.updateSection(
                                                                          sectionIdNow
                                                                              .toString(),
                                                                          selectedStartTime
                                                                              .toString(),
                                                                          selectedDuration
                                                                              .toString(),
                                                                          selectedGroupStu
                                                                              .toString(),
                                                                          selectedTypeSubject
                                                                              .toString(),
                                                                          IdUser,
                                                                          courseIdNow
                                                                              .toString(),
                                                                          IdRoom
                                                                              .toString(),
                                                                        );

                                                                        if (sectionResponse.statusCode ==
                                                                            200) {
                                                                          // เรียก addSection สำเร็จ
                                                                          showSuccessToUpdateClassAlert();
                                                                          print(
                                                                              "แก้ไขสำเร็จ");
                                                                        }
                                                                      }
                                                                    }
                                                                  } else {
                                                                    showClassAlreadyHaveAlert();
                                                                  }
                                                                } else {
                                                                  print(
                                                                      'ไม่พบ subjectId: $selectedSubjectId ในรายการ');
                                                                }
                                                              }
                                                            },
                                                            child: const Text(
                                                                "แก้ไข"),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0), // กำหนดมุม
                                                              ),
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      40,
                                                                  vertical: 15),
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              primary:
                                                                  Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            0),
                                                                    () => showSureToDeleteClass(
                                                                        sectionIdNow
                                                                            .toString(),
                                                                        courseIdNow
                                                                            .toString()));
                                                              });
                                                            },
                                                            child: const Text(
                                                                "ลบ"),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0), // กำหนดมุม
                                                              ),
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      40,
                                                                  vertical: 15),
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              primary:
                                                                  Colors.blue,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(MaterialPageRoute(builder:
                                                                        (BuildContext
                                                                            context) {
                                                                  return const ListClassScreen();
                                                                }));
                                                              });
                                                            },
                                                            child: const Text(
                                                                "ยกเลิก"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      ])),
                                ),
                              ),
                            ),
                          )),
                    ]),
                  ])),
                ],
              ));
  }
}
