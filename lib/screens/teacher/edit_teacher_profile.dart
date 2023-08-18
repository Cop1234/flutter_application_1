import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';

class EditProfileTeacherScreen extends StatefulWidget {
  const EditProfileTeacherScreen({super.key});

  @override
  State<EditProfileTeacherScreen> createState() => _EditProfileTeacherScreenState();
}

class _EditProfileTeacherScreenState extends State<EditProfileTeacherScreen> {
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            NavbarTeacher(),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 0,
                        child: ClipRRect(
                          child: SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage("images/mjuicon.png"),
                                    height: 100,
                                    width: 100,
                                  ),
                                  SizedBox(height: 10,),
                                  ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  ),
                                  onPressed: () {
                                    
                                  },
                                  child: Text("เปลี่ยนรูปโปรไฟล์"),
                                )
                                ],
                              ),
                            ),
                          ),
                        ),
                    ),
                    SizedBox(width: 10,),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Color.fromARGB(255, 226, 226, 226),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 800,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Text("ชื่อ : ",style: CustomTextStyle.mainFontStyle,),
                                Text("นามสกุล : ",style: CustomTextStyle.mainFontStyle,),
                                Text("รหัสอาจารย์ : ",style: CustomTextStyle.mainFontStyle,),
                                Text("อีเมล : ",style: CustomTextStyle.mainFontStyle,),
                                Text("ชื่อผู้ใช้ : ",style: CustomTextStyle.mainFontStyle,),
                                Text("เพศ : ",style: CustomTextStyle.mainFontStyle,),
                                Text("วัน เดือน ปี ที่เกิด : ",style: CustomTextStyle.mainFontStyle,),
                                SizedBox(height: 15,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  ),
                                  onPressed: () {
                                    
                                  },
                                  child: Text("แก้ไขรหัสผ่าน"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}

