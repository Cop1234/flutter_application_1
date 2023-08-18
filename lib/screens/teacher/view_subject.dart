import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/teacher/teacher_import_student.dart';
import 'package:flutter_application_1/screens/teacher/teacher_setting_subject.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_attendance%20.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_qrcode.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_student.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';

import '../../color.dart';

class subjectScreen extends StatelessWidget {
  const subjectScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    bool standardSelected = false;
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: ListView(
          children: [
            NavbarTeacher(),
            Column(
              children: [
                Form(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                      color: Color.fromARGB(255, 226, 226, 226),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 1200,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: <Widget>[
                                Table(
                                  //border: TableBorder.all(), // Allows to add a border decoration around your table
                                  children: [ 
                                    TableRow(
                                      decoration: const BoxDecoration(
                                        color: maincolor,
                                      ),
                                      children :[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('รหัสวิชา',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('ชื่อวิชา',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('ประเภท',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('จัดการ',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center),
                                      ),
                                    ]),
                                    //เพิ่ม Table
                                    TableRow(
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                      children :[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('IT001',style: CustomTextStyle.TextGeneral,textAlign: TextAlign.center,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('xxxxxxxx',style: CustomTextStyle.TextGeneral,textAlign: TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('LAB',style: CustomTextStyle.TextGeneral,textAlign: TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: PopupMenuButton(
                                          icon: Icon(Icons.settings, color: Colors.white,),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.inventory_outlined, color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('การเข้าเรียน'),
                                                ],
                                              ),
                                              onTap: () async {
                                                final navigator = Navigator.of(context);
                                                await Future.delayed(Duration.zero);
                                                navigator.push(
                                                  MaterialPageRoute(builder: (_) => TeacherAtten()),
                                                );
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.qr_code_scanner, color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('QR CODE'),
                                                ],
                                              ),
                                              onTap: () async {
                                                final navigator = Navigator.of(context);
                                                await Future.delayed(Duration.zero);
                                                navigator.push(
                                                  MaterialPageRoute(builder: (_) => TeacherQR()),
                                                );
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.people_alt, color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('แก้ไขนักศึกษา'),
                                                ],
                                              ),
                                              onTap: () async {
                                                final navigator = Navigator.of(context);
                                                await Future.delayed(Duration.zero);
                                                navigator.push(
                                                  MaterialPageRoute(builder: (_) => TeacherViewStudent()),
                                                );
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.subject_outlined, color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('แก้ไขวิชา'),
                                                ],
                                              ),
                                              onTap: () async {
                                                final navigator = Navigator.of(context);
                                                await Future.delayed(Duration.zero);
                                                navigator.push(
                                                  MaterialPageRoute(builder: (_) => TeacherSettingSubject()),
                                                );
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.group_add, color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('เพิ่มนักศึกษา'),
                                                ],
                                              ),
                                              onTap: () async {
                                                final navigator = Navigator.of(context);
                                                await Future.delayed(Duration.zero);
                                                navigator.push(
                                                  MaterialPageRoute(builder: (_) => TeacherImportStu()),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ]
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
      ),
    );
  }
  
  void setState(Null Function() param0) {}
}

class Constants {
  static const String FirstItem = 'การเข้าห้องเรียน';
  static const String SecondItem = 'เปิด QR Code';
  static const String ThirdItem = 'จัดการนักเรียน';
  static const String FourItem = 'จัดการวิชา';
  static const String FiveItem = 'เพิ่มนักเรียน';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
    FourItem,
    FiveItem
  ];
}