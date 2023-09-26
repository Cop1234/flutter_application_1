import 'package:flutter/material.dart';

import '../../color.dart';
import '../../controller/user_controller.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import '../widget/navbar_admin.dart';
import 'list_Teacher.dart';

//calendar
/*
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
*/
import 'package:intl/intl.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({super.key});

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  DateTime selecteData = DateTime.now();

  //TimeOfDay time = TimeOfDay(hour: 8, minute: 0);
  TextEditingController timePicker = TextEditingController();
  final UserController userController = UserController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  var items = ['ชาย', 'หญิง'];
  String dropdownvalue = 'ชาย';

  TextEditingController useridController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  void showSuccessToAddTeacherAlert() {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มอาจารย์",
      text: "ข้อมูลอาจารย์ถูกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ListTeacher(),
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
                                    "รหัสอาจารย์ : ",
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
                                        controller: useridController,
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
                                              RegExp(r'^[\d]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกรหัสประจำตัวอาจารย์*";
                                          } else if (!subjectIdValid) {
                                            return "รหัสอาจารย์ต้องเป็นมีตัวเลขเท่านั้น";
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
                                    "อีเมล : ",
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
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(),
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                        ),
                                        validator: (value) {
                                          bool subjectNameValid = RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                              .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกอีเมล*";
                                          } else if (!subjectNameValid) {
                                            return "กรุณากรอกอีเมลให้ถูกต้อง";
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
                                    "ชื่อ : ",
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
                                        controller: fnameController,
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
                                              RegExp(r'^[ก-์]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกชื่อ*";
                                          } else if (!subjectNameValid) {
                                            return "ชื่อต้องเป็นภาษาไทยเท่านั้น";
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
                                    "นามกุล : ",
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
                                        controller: lnameController,
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
                                              RegExp(r'^[ก-์]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกนามกุล*";
                                          } else if (!subjectNameValid) {
                                            return "ชื่อนามกุลต้องเป็นภาษาไทย";
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
                                children: <Widget>[
                                  Text("วันเกิด : ",
                                      style: CustomTextStyle.createFontStyle),
                                  Text(
                                      '${DateFormat('dd-MM-yyyy').format(selecteData)}',
                                      style: CustomTextStyle.createFontStyle),
                                  ElevatedButton(
                                    child: const Text("Date"),
                                    onPressed: () async {
                                      final DateTime? dateTime =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: selecteData,
                                              firstDate: DateTime(1000),
                                              lastDate: DateTime(3000));
                                      if (dateTime != null) {
                                        setState(() {
                                          selecteData = dateTime;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //Longtitude
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "เพศ : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  SizedBox(
                                      //genderController
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // dropdown below..
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: dropdownvalue,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                      items: items.map(
                                        (String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        },
                                      ).toList(),
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
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    useridController.text = "";
                                    emailController.text = "";
                                    fnameController.text = "";
                                    lnameController.text = "";
                                    genderController.text = "";
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
                                          await userController.addTeacher(
                                              useridController.text,
                                              emailController.text,
                                              fnameController.text,
                                              lnameController.text,
                                              DateFormat('dd/MM/yyyy')
                                                  .format(selecteData)
                                                  .toString(),
                                              genderController.text =
                                                  dropdownvalue.toString());

                                      if (response.statusCode == 200) {
                                        showSuccessToAddTeacherAlert();
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
