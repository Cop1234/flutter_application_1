import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/screens/admin/list_room.dart';
import 'package:flutter_application_1/screens/login.dart';

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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return ListRoomScreen();}
                    ));
                });
            },
            child: Icon(
              Icons.room,
                    color: Colors.white,
                    size: 30.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3,right: 30,top: 10,bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pressed1 = !pressed1;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return ListRoomScreen();}
                      ));
                });
              },
              child: Text("ห้อง",
                    style: pressed1
                    ? TextStyle(color: Colors.white,fontSize: 20,)
                    : TextStyle(color:Colors.black,fontSize: 20),
              ),
            ),
          ),
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
            child: Icon(
              Icons.menu_book,
                    color: Colors.white,
                    size: 30.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3,right: 30,top: 10,bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pressed2 = !pressed2;
                  /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return subjectScreen();}
                      ));*/
                });
              },
              child: Text("รายวิชา",
                    style: pressed2
                    ? TextStyle(color: Colors.white,fontSize: 20,)
                    : TextStyle(color:Colors.black,fontSize: 20),
              ),
            ),
          ),
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
            child: Icon(
              Icons.school,
                    color: Colors.white,
                    size: 30.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3,right: 30,top: 10,bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pressed3 = !pressed3;
                  /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return subjectScreen();}
                      ));*/
                });
              },
              child: Text("นักศึกษา",
                    style: pressed3
                    ? TextStyle(color: Colors.white,fontSize: 20,)
                    : TextStyle(color:Colors.black,fontSize: 20),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
                setState(() {
                  /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return EditProfileTeacherScreen();}
                      ));*/
                });
              },
            child: Icon(
              Icons.person,
                    color: Colors.white,
                    size: 30.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30,top: 10,bottom: 10),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  pressed4 = !pressed4;
                  /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return EditProfileTeacherScreen();}
                      ));*/
                });
              },
              child: Text("อาจารย์",
              style: pressed4
                      ? TextStyle(color: Colors.white,fontSize: 20,)
                      : TextStyle(color:Colors.black,fontSize: 20),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return LoginScreen();}
                  ));
              });
            },
            child: Icon(
              Icons.logout,
                    color: Colors.white,
                    size: 24.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3,right: 30,top: 10,bottom: 10),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  pressed5 = !pressed5;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return LoginScreen();}
                      ));
                });
              },
              child: Text("ออกจากระบบ",
              style: pressed5
                      ? TextStyle(color: Colors.white,fontSize: 20,)
                      : TextStyle(color:Colors.black,fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}