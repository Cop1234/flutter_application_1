import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/screens/admin/list_room.dart';
import 'package:flutter_application_1/screens/admin/list_student.dart';
import 'package:flutter_application_1/screens/admin/list_subject.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin/list_Teacher.dart';

class NavbarAdmin extends StatefulWidget {
  const NavbarAdmin({super.key});

  @override
  State<NavbarAdmin> createState() => _NavbarAdminnState();
}

class _NavbarAdminnState extends State<NavbarAdmin> {
  bool pressed1 = true;
  bool pressed2 = true;
  bool pressed3 = true;
  bool pressed4 = true;
  bool pressed5 = true;

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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListRoomScreen()),
                  (route) => false,
                );
              });
            },
            child: Icon(
              Icons.room,
              color: pressed1 ? Colors.white : Colors.black, // หน้าห้อง
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
                  // ตัวอย่างเช็คหน้าห้อง
                  if (!pressed1) {
                    // ถ้าอยู่ในหน้าห้องให้เปลี่ยนสีของ Icon และ Text เป็นสีดำ
                    // และตั้งค่า pressed2, pressed3, pressed4, pressed5 เป็น true เพื่อให้ Icon และ Text ของหน้าอื่น ๆ เป็นสีขาว
                    pressed2 = true;
                    pressed3 = true;
                    pressed4 = true;
                    pressed5 = true;
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListRoomScreen()),
                    (route) => false,
                  );
                });
              },
              child: Text(
                "ห้อง",
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
                      builder: (context) => const ListSubjectScreen()),
                  (route) => false,
                );
              });
            },
            child: Icon(
              Icons.menu_book,
              color: pressed2 ? Colors.white : Colors.black,
              size: 30.0,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 3, right: 30, top: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pressed2 = !pressed2;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListSubjectScreen()),
                    (route) => false,
                  );
                });
              },
              child: Text(
                "รายวิชา",
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
                pressed3 = !pressed3;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ListStudent()),
                  (route) => false,
                );
              });
            },
            child: Icon(
              Icons.school,
              color: pressed3 ? Colors.white : Colors.black,
              size: 30.0,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 3, right: 30, top: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pressed3 = !pressed3;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListStudent()),
                    (route) => false,
                  );
                });
              },
              child: Text(
                "นักศึกษา",
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
                pressed4 = !pressed4;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ListTeacher()),
                  (route) => false,
                );
              });
            },
            child: Icon(
              Icons.person,
              color: pressed4 ? Colors.white : Colors.black,
              size: 30.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30, top: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pressed4 = !pressed4;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListTeacher()),
                    (route) => false,
                  );
                });
              },
              child: Text(
                "อาจารย์",
                style: pressed4
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              });
            },
            child: Icon(
              Icons.logout,
              color: pressed1 ? Colors.white : Colors.black,
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
                  pressed5 = !pressed5;
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
                style: pressed5
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
