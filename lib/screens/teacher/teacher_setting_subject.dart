import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';

class TeacherSettingSubject extends StatefulWidget {
  const TeacherSettingSubject({super.key});

  @override
  State<TeacherSettingSubject> createState() => _TeacherSettingSubjectState();
}

class _TeacherSettingSubjectState extends State<TeacherSettingSubject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            NavbarTeacher(),
          ]
        ),
      )
    );
  }
}