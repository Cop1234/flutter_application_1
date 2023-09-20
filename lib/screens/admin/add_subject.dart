import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/subject_controller.dart';
import 'package:flutter_application_1/screens/admin/list_subject.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_admin.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  bool passToggle = true;

  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  final SubjectController subjectController = SubjectController();

  TextEditingController subjectIdController = TextEditingController();
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController creditController = TextEditingController();

  void showSuccessToAddSubjectAlert() {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มวิชาสำเร็จ",
      text: "ข้อมูลวิชาถูกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ListSubjectScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
        body: ListView(children: [
          Column(children: [
            NavbarAdmin(),
            Form(
              key: _formfield,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color.fromARGB(255, 226, 226, 226),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 1000,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //RoomName
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "รหัสวิชา : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 500,
                                    child: Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: subjectIdController,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(),
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                        ),
                                        validator: (value) {
                                          bool subjectIdValid =
                                              RegExp(r'^[0-9ก-๙\s\-/]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกรหัสวิชา*";
                                          } else if (!subjectIdValid) {
                                            return "รหัสวิชาต้องเป็นภาษาไทยและมีตัวเลข";
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "ชื่อวิชา : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 500,
                                    child: Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: subjectNameController,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(),
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                        ),
                                        validator: (value) {
                                          bool subjectNameValid =
                                              RegExp(r'^[a-zA-Z0-9ก-๙\s\-/]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกชื่อวิชา*";
                                          } else if (!subjectNameValid) {
                                            return "ชื่อวิชาต้องเป็นภาษาไทย หรือ อังกฤษ หรือ ตัวเลข";
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Latitude
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "รายละเอียด : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 500,
                                    child: Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: detailController,
                                        decoration: InputDecoration(
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                          enabledBorder: OutlineInputBorder(
                                            //borderRadius: BorderRadius.circular(10.0), // กำหนดมุมโค้ง
                                            borderSide: BorderSide
                                                .none, // กำหนดให้ไม่มีเส้นขอบ
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //Longtitude
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "หน่วยกิต : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 500,
                                    child: Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: creditController,
                                        decoration: InputDecoration(
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide
                                                .none, // กำหนดให้ไม่มีเส้นขอบ
                                          ),
                                        ),
                                        validator: (value) {
                                          bool creditValid = RegExp(r'^[\d]+$')
                                              .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกหน่วยกิต*";
                                          } else if (!creditValid) {
                                            return "หน่วยกิตต้องเป็นตัวเลขจำนวนเต็มเท่านั้น";
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    subjectIdController.text = "";
                                    subjectNameController.text = "";
                                    detailController.text = "";
                                    creditController.text = "";
                                  },
                                  child: Container(
                                      height: 35,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: maincolor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text("รีเซ็ต",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (_formfield.currentState!.validate()) {
                                      http.Response response =
                                          await subjectController.addSubject(
                                              subjectIdController.text,
                                              subjectNameController.text,
                                              detailController.text,
                                              creditController.text);

                                      if (response.statusCode == 200) {
                                        showSuccessToAddSubjectAlert();
                                        print("บันทึกสำเร็จ");
                                      }
                                    }
                                  },
                                  child: Container(
                                      height: 35,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: maincolor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text("ยืนยัน",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      )),
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
            )
          ]),
        ]));
  }
}