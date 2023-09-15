import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/add_room.dart';
import 'package:flutter_application_1/screens/admin/insert_DataStudent.dart';
import 'package:flutter_application_1/screens/admin/list_room.dart';
import 'package:flutter_application_1/screens/admin/list_subject.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/teacher/teacher_create_subject.dart';
import 'package:flutter_application_1/screens/teacher/view_subject.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_attendance%20.dart';
import 'package:flutter_application_1/screens/teacher/view_teacher_qrcode.dart';

import 'color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: maincolor,
      ),
      home: TeacherCreateSub(),
      //home: LoginScreen(),
    );
  }
}
