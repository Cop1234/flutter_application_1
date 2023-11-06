import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../student/detail_student_profile.dart';
import '../student/view_student_subject.dart';

class NavbarStudent extends StatefulWidget {
  const NavbarStudent({super.key});

  @override
  State<NavbarStudent> createState() => _NavbarStudentState();
}

class _NavbarStudentState extends State<NavbarStudent> {
  bool pressed1 = true;
  bool pressed2 = true;
  bool pressed3 = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: maincolor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                /*Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return subjectScreen();}
                    ));*/
              });
            },
            child: const Icon(
              Icons.menu_book,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 3, right: 30, top: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pressed1 = !pressed1;
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const ViewStudentSubject();
                  }));
                });
              },
              child: Text(
                "คลาสเรียน",
                style: pressed1
                    ? const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )
                    : const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const ViewStudentSubject();
                }));
              });
            },
            child: const Icon(
              Icons.perm_contact_cal,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pressed2 = !pressed2;
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const DetailStudentProfile();
                  }));
                });
              },
              child: Text(
                "โปรไฟล์",
                style: pressed2
                    ? const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )
                    : const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                /*Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return LoginScreen();}
                  ));*/
              });
            },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 3, right: 30, top: 10, bottom: 10),
            child: GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('username');
                setState(() {
                  pressed3 = !pressed3;
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginScreen();
                  }));
                });
              },
              child: Text(
                "ออกจากระบบ",
                style: pressed3
                    ? const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )
                    : const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
