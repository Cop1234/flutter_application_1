import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:intl/intl.dart';

class TeacherCreateSub extends StatefulWidget {
  const TeacherCreateSub({super.key});

  @override
  State<TeacherCreateSub> createState() => _TeacherCreateSubState();
}

class _TeacherCreateSubState extends State<TeacherCreateSub> {
  String dropdownvalue = '1';   
  String GroupStu = '1';  
  String NumberSubject = '1163';
  String TypeSubject = 'LAB';
  String NameRoom = 'ห้อง 1';
  String Duration = '1';
  
  TimeOfDay time = TimeOfDay(hour: 8, minute: 0);
  TextEditingController timePicker = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  

  // List of items in our dropdown menu
  var items = [    
    '1',
    '2'
  ];

  var GStu = [    
    '1',
    '2'
  ];

  var subjectnum = [
    '1163',
    '1164',
    '1165'
  ];

  var typesub = [    
    'LAB',
    'Lecture'
  ];

  var NameR = [    
    'ห้อง 1',
    'ห้อว 2'
  ];

  var durationTime = [    
    '1',
    '2',
    '3'
  ];

  @override
  Widget build(BuildContext context) {
    //final format = DateFormat("yyyy-MM-dd HH:mm");
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: ListView(
        children: [ 
        Column(
          children: [
            NavbarTeacher(),
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color.fromARGB(255, 226, 226, 226),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 700,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //p1
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("ปีการศึกษา : ",style: CustomTextStyle.createFontStyle),
                                  Text(DateFormat(' yyyy ').format(DateTime.now())
                                  ,style: CustomTextStyle.createFontStyle)
                                ],
                              ),
                            ),
                            //p2
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("เทอม : ",style: CustomTextStyle.createFontStyle,),
                                  //ปุ่มเลือกเทอม
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical:5 ),
                                    decoration: BoxDecoration(
                                        color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: dropdownvalue,
                                      style: TextStyle(fontSize: 18,),
                                      items: items.map((String items){
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      },).toList(),
                                      onChanged: (String? newValue) { 
                                        setState(() {
                                          dropdownvalue = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p3
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("รหัสวิชา : ",style: CustomTextStyle.createFontStyle,),
                                  //ปุ่มเลือกรหัสวิชา
                                  Container(
                                    width: 150,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical:5 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: NumberSubject,
                                      style: TextStyle(fontSize: 18,),
                                      items: subjectnum.map((String subjectnum){
                                        return DropdownMenuItem(
                                          value: subjectnum,
                                          child: Text(subjectnum),
                                        );
                                      },).toList(),
                                      onChanged: (String? newValue) { 
                                        setState(() {
                                          NumberSubject = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p4
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("กลุ่มเรียน : ",style: CustomTextStyle.createFontStyle,),
                                  //ปุ่มเลือกกลุ่มเรียน
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical:5 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: GroupStu,
                                      style: TextStyle(fontSize: 18,),
                                      items: GStu.map((String GStu){
                                        return DropdownMenuItem(
                                          value: GStu,
                                          child: Text(GStu),
                                        );
                                      },).toList(),
                                      onChanged: (String? newValue) { 
                                        setState(() {
                                          GroupStu = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p5
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("เวลาเริ่มเรียน : ",style: CustomTextStyle.createFontStyle,),
                                  //เลือกเวลาเรียน
                                  Container(
                                    width: 300,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical:5 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 8,left: 5),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none
                                          ),
                                          onTap: () async {
                                            TimeOfDay? newTime = await showTimePicker(
                                              context: context,
                                              initialTime: time
                                            );
                                            if (newTime == null) {
                                              return;
                                            }
                                            setState(() {
                                              time = newTime;
                                              timePicker.text = time.hour.toString() + ":" + time.minute.toString();
                                              print(time.hour);
                                            });
                                          },
                                          controller: timePicker,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p6
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("ระยะเวลาเรียน : ",style: CustomTextStyle.createFontStyle,),
                                  //ปุ่มเลือกระยะเวลาเรียน
                                  Container(
                                    width: 300,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical:5 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: Duration,
                                      style: TextStyle(fontSize: 18,),
                                      items: durationTime.map((String durationTime){
                                        return DropdownMenuItem(
                                          value: durationTime,
                                          child: Text(durationTime),
                                        );
                                      },).toList(),
                                      onChanged: (String? newValue) { 
                                        setState(() {
                                          Duration = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                  Text(" ชั่วโมง",style: CustomTextStyle.createFontStyle,),
                                ],
                              ),
                            ),
                            //p7
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("ประเภท : ",style: CustomTextStyle.createFontStyle,),
                                  //ปุ่มเลือกประเภท
                                  Container(
                                    width: 150,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical:5 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: TypeSubject,
                                      style: TextStyle(fontSize: 18,),
                                      items: typesub.map((String typesub){
                                        return DropdownMenuItem(
                                          value: typesub,
                                          child: Text(typesub),
                                        );
                                      },).toList(),
                                      onChanged: (String? newValue) { 
                                        setState(() {
                                          TypeSubject = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //p8
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("ห้องเรียน : ",style: CustomTextStyle.createFontStyle,),
                                  //ปุ่มเลือกห้องเรียน
                                  Container(
                                    width: 300,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical:5 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: NameRoom,
                                      style: TextStyle(fontSize: 18,),
                                      items: NameR.map((String NameR){
                                        return DropdownMenuItem(
                                          value: NameR,
                                          child: Text(NameR),
                                        );
                                      },).toList(),
                                      onChanged: (String? newValue) { 
                                        setState(() {
                                          NameRoom = newValue!;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  onPressed: () {
                                    
                                  },
                                  child: Text("รีเซ็ต"),
                                ),
                                SizedBox(width: 10,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  onPressed: () {
                                    
                                  },
                                  child: Text("ยืนยัน"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]
        ),
        ]
      )
    );;
  }
}

class CustomTextStyle {
  static const TextStyle createFontStyle = TextStyle(
    fontSize: 25,
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );
}