import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';

class TeacherImportStu extends StatefulWidget {
  const TeacherImportStu({super.key});

  @override
  State<TeacherImportStu> createState() => _TeacherImportStuState();
}

class _TeacherImportStuState extends State<TeacherImportStu> {
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