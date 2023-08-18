import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';

class TeacherAtten extends StatefulWidget {
  const TeacherAtten({super.key});

  @override
  State<TeacherAtten> createState() => _TeacherAttenState();
}

class _TeacherAttenState extends State<TeacherAtten> {
  String weekNum = 'สัปดาห์ 1'; 

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var weekNumItems = [    
    'สัปดาห์ 1',
    'สัปดาห์ 2',
    'สัปดาห์ 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: ListView(
          children: [
            NavbarTeacher(),
            Column(
              children: [
                Form(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20,right: 20,top: 30),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Color.fromARGB(255, 226, 226, 226),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 1200,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("รหัสวิชา : ",style: CustomTextStyle.mainFontStyle),
                                      //เอาข้อมูลรหัสวิชามาแสดงผลตรงนี้
                                      Text("IT001",style: CustomTextStyle.mainFontStyle)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("ชื่อวิชา : ",style: CustomTextStyle.mainFontStyle),
                                      //เอาข้อมูลรหัสวิชามาแสดงผลตรงนี้
                                      Text("xxxxxx",style: CustomTextStyle.mainFontStyle)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("อาจารย์ : ",style: CustomTextStyle.mainFontStyle),
                                      //เอาข้อมูลรหัสวิชามาแสดงผลตรงนี้
                                      Text("xxxxx xxxxxx",style: CustomTextStyle.mainFontStyle)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("กลุ่ม : ",style: CustomTextStyle.mainFontStyle),
                                      //เอาข้อมูลรหัสวิชามาแสดงผลตรงนี้
                                      Text("xx",style: CustomTextStyle.mainFontStyle),
                                      SizedBox(width: 20,),
                                      Text("เวลา : ",style: CustomTextStyle.mainFontStyle),
                                      //เอาข้อมูลรหัสวิชามาแสดงผลตรงนี้
                                      Text("xxx",style: CustomTextStyle.mainFontStyle),
                                      SizedBox(width: 20,),
                                      Text("ห้อง : ",style: CustomTextStyle.mainFontStyle),
                                      //เอาข้อมูลรหัสวิชามาแสดงผลตรงนี้
                                      Text("xxxxx",style: CustomTextStyle.mainFontStyle)
                                    ],
                                  ),
                                ],
                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Form(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Color.fromARGB(255, 226, 226, 226),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 1200,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 40,
                                        alignment: AlignmentDirectional.centerStart,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical:5 ),
                                        decoration: BoxDecoration(
                                          color: Colors.white, borderRadius: BorderRadius.circular(30)),
                                        // dropdown below..
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: weekNum,
                                          style: TextStyle(fontSize: 18,),
                                          items: weekNumItems.map((String typesub){
                                            return DropdownMenuItem(
                                              value: typesub,
                                              child: Text(typesub),
                                            );
                                          },).toList(),
                                          onChanged: (String? newValue) { 
                                            setState(() {
                                              weekNum = newValue!;
                                            });
                                          },
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          underline: SizedBox(),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30)
                                          ),
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                          )
                                        ),
                                        onPressed: () {
                                          
                                        },
                                        child: Text("ExportReport"),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 30,),
                                  Table(
                                    children: [
                                      TableRow(
                                        decoration: const BoxDecoration(
                                        color: maincolor,
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text('รหัสนักศึกษา',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text('ชื่อ',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text('นามสกุล',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text('เวลา',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text('ประเภท',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text('สถานะ',style: CustomTextStyle.TextHeadBar,textAlign: TextAlign.center),
                                          ),
                                        ]
                                      ),
                                      
                                    ],
                                  ),
                                ],
                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]
        ),
      );
  }
}