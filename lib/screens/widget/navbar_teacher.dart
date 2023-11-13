import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/teacher/detail_teacher_profile.dart';
import 'package:flutter_application_1/screens/teacher/create_class.dart';
import 'package:flutter_application_1/screens/teacher/list_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavbarTeacher extends StatefulWidget {
  const NavbarTeacher({super.key});

  @override
  State<NavbarTeacher> createState() => _NavbarTeacherState();
}

class _NavbarTeacherState extends State<NavbarTeacher> {
  bool pressed1 = true;
  bool pressed2 = true;
  bool pressed3 = true;
  bool pressed4 = true;
  double? screenWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      if (screenWidth < 900) {
        return Container(
          color: maincolor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              // ... rest of the code
            ],
          ),
        );
      } else {
        return Container(
          color: maincolor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListClassScreen()),
                      (route) => false,
                    );
                  });
                },
                child: Icon(
                  Icons.menu_book,
                  color: pressed1 ? Colors.white : Colors.black,
                  size: 30.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 3, right: 30, top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pressed1 = !pressed1;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListClassScreen()),
                        (route) => false,
                      );
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TeacherCreateClass()),
                      (route) => false,
                    );
                  });
                },
                child: Icon(
                  Icons.class_,
                  color: pressed2 ? Colors.white : Colors.black,
                  size: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pressed2 = !pressed2;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TeacherCreateClass()),
                        (route) => false,
                      );
                    });
                  },
                  child: Text(
                    "สร้างคลาสเรียน",
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailTeacherProfile()),
                      (route) => false,
                    );
                  });
                },
                child: Icon(
                  Icons.perm_contact_cal,
                  color: pressed3 ? Colors.white : Colors.black,
                  size: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pressed3 = !pressed3;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailTeacherProfile()),
                        (route) => false,
                      );
                    });
                  },
                  child: Text(
                    "โปรไฟล์",
                    style: pressed3
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  });
                },
                child: Icon(
                  Icons.logout,
                  color: pressed4 ? Colors.white : Colors.black,
                  size: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 3, right: 30, top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('username');
                    setState(() {
                      pressed4 = !pressed4;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    });
                  },
                  child: Text(
                    "ออกจากระบบ",
                    style: pressed4
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
    });
  }
}
