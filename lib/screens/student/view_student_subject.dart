import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';

class ViewStudentSubject extends StatefulWidget {
  const ViewStudentSubject({super.key});

  @override
  State<ViewStudentSubject> createState() => _ViewStudentSubjectState();
}

class _ViewStudentSubjectState extends State<ViewStudentSubject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            NavbarStudent(),
            
          ]
        ),
      )
    );
  }
}