import 'dart:async';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widget/my_abb_bar.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class TeacherQR extends StatefulWidget {
  const TeacherQR({super.key});

  @override
  State<TeacherQR> createState() => _TeacherQRState();
  
}

class _TeacherQRState extends State<TeacherQR> {
  TextEditingController controller = TextEditingController();

  int _start = 100;
  int _current = 100;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 0),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() { _current = _start - duration.elapsed.inSeconds; });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

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
                                children: [
                                  QrImage(
                                    data: controller.text,
                                    size: 280,
                                    // You can include embeddedImageStyle Property if you 
                                    //wanna embed an image from your Asset folder
                                    embeddedImageStyle: QrEmbeddedImageStyle(
                                      size: const Size(
                                        100,
                                        100,
                                      ),
                                    )
                                  ),
                                  Text("$_current"),
                                  
                                ],
                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ]
          ),
        ]
      )
    );
  }
}

