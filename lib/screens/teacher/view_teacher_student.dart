import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';

class TeacherViewStudent extends StatefulWidget {
  const TeacherViewStudent({super.key});

  @override
  State<TeacherViewStudent> createState() => _TeacherViewStudentState();
}

class _TeacherViewStudentState extends State<TeacherViewStudent> {
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