import 'package:flutter/material.dart';
import '../../color.dart';
import '../../controller/user_controller.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../../model/user.dart';
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
  bool showData = false;
  //TimeOfDay time = TimeOfDay(hour: 8, minute: 0);
  TextEditingController timePicker = TextEditingController();
  final UserController userController = UserController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  var items = ['ชาย', 'หญิง'];
  String dropdownvalue = 'ชาย';
  bool passToggle = true;
  TextEditingController useridController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  List<User>? users;

  @override
  void initState() {
    super.initState();
  }

  void showSuccessToAddTeacherAlert() {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มอาจารย์สำเร็จ",
      text: "ข้อมูลอาจารย์ถูกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ListTeacher()),
          (route) => false,
        );
      },
    );
  }

  void showErrorUserNameExistsAlert(String email) {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "อีเมล $email ถูกใช้งานแล้ว",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  void showErrorDatetime() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "กรุณากรอกข้อมูลให้ครบถ้วน",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
        body: Column(
          children: [
            const NavbarAdmin(),
            Expanded(
              child: ListView(children: [
                Column(children: [
                  Form(
                      key: _formfield,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // สีพื้นหลังของ Card
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 226, 226, 226)), // สีขอบ
                              borderRadius:
                                  BorderRadius.circular(10), // กำหนดขอบให้มน
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 5)
                              ], // เพิ่มเงา
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 600,
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Center(
                                          child: Text("เพิ่มอาจารย์",
                                              style:
                                                  CustomTextStyle.Textheader)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 5),
                                        child: Container(
                                          width: 500,
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.green),
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              hintText: "อีเมล",
                                              hintStyle: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.green),
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
                                              return null; // รีเทิร์น null เมื่อไม่มีข้อผิดพลาด
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 5),
                                        child:
                                            // Adjust the width for spacing
                                            Container(
                                          width: 500,
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.green),
                                            controller: fnameController,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              hintText: "ชื่อ",
                                              hintStyle: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.green),
                                            ),
                                            validator: (value) {
                                              bool subjectNameValid =
                                                  RegExp(r'^[ก-์A-Za-z]+$')
                                                      .hasMatch(value ?? "");
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "กรุณากรอกชื่อ*";
                                              } else if (!subjectNameValid) {
                                                return "ชื่อต้องเป็นภาษาไทยหรืออังกฤษเท่านั้น";
                                              }
                                              return null; // รีเทิร์น null เมื่อไม่มีข้อผิดพลาด
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 5),
                                        child: Container(
                                          width: 500,
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.green),
                                            controller: lnameController,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              hintText: "นามสกุล",
                                              hintStyle: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.green),
                                            ),
                                            validator: (value) {
                                              bool subjectNameValid =
                                                  RegExp(r'^[ก-์A-Za-z]+$')
                                                      .hasMatch(value!);
                                              if (value.isEmpty) {
                                                return "กรุณากรอกนามกุลหรือถ้าไม่มีให้ใส่คำว่า ไม่มีนามสกุล*";
                                              } else if (!subjectNameValid) {
                                                return "นามกุลต้องเป็นภาษาไทยหรืออังกฤษเท่านั้น";
                                              }
                                              return null; // รีเทิร์น null เมื่อไม่มีข้อผิดพลาด
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 5),
                                        child: Row(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                const Text("วันเกิด : ",
                                                    style: CustomTextStyle
                                                        .createFontStyle),
                                                const SizedBox(width: 10),
                                                ShowSelectDate(),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors
                                                        .green, // สีพื้นหลังของปุ่ม
                                                  ),
                                                  onPressed: () async {
                                                    final DateTime? pickedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate: selecteData,
                                                      firstDate: DateTime(1000),
                                                      lastDate: DateTime.now(),
                                                    );
                                                    String time = DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(DateTime.now());

                                                    if (pickedDate != null) {
                                                      if (pickedDate.isBefore(
                                                          DateTime.parse(
                                                              time))) {
                                                        // ตรวจสอบว่าวันที่ถูกเลือกไม่ใช่วันปัจจุบัน
                                                        setState(() {
                                                          showData = true;
                                                          selecteData =
                                                              pickedDate;
                                                        });
                                                      } else {
                                                        // ignore: use_build_context_synchronously
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'วันที่ไม่ถูกต้อง'),
                                                              content: const Text(
                                                                  'โปรดเลือกวันที่ให้ถูกต้อง'),
                                                              actions: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {
                                                                      showData =
                                                                          false;
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'ตกลง'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons
                                                            .calendar_today, // ไอคอนของปฏิทิน
                                                        color: Colors
                                                            .white, // สีของไอคอน
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  " เพศ : ",
                                                  style: CustomTextStyle
                                                      .createFontStyle,
                                                ),
                                                const SizedBox(
                                                    //genderController
                                                    width:
                                                        10), // Adjust the width for spacing
                                                Container(
                                                  width: 100,
                                                  height: 40,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerStart,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.green,
                                                        width: 2.0),
                                                  ),
                                                  // dropdown below..
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    value: dropdownvalue,
                                                    style: const TextStyle(
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
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownvalue =
                                                            newValue!;
                                                      });
                                                    },
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    underline: const SizedBox(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Center(
                                                  child: Text("รีเซ็ต",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (_formfield.currentState!
                                                      .validate() &&
                                                  showData == true) {
                                                http.Response response =
                                                    await userController
                                                        .addTeacher(
                                                            emailController
                                                                .text,
                                                            fnameController
                                                                .text,
                                                            lnameController
                                                                .text,
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(
                                                                    selecteData)
                                                                .toString(),
                                                            genderController
                                                                    .text =
                                                                dropdownvalue
                                                                    .toString());
                                                print(emailController.text);
                                                if (response.statusCode ==
                                                    200) {
                                                  showSuccessToAddTeacherAlert();

                                                  print("บันทึกสำเร็จ");
                                                } else {
                                                  showErrorUserNameExistsAlert(
                                                      emailController.text);
                                                }
                                              } else {
                                                showErrorDatetime();
                                              }
                                            },
                                            child: Container(
                                                height: 35,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  color: maincolor,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Center(
                                                  child: Text("ยืนยัน",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
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
                      ))
                ]),
              ]),
            ),
          ],
        ));
  }

  Widget ShowSelectDate() {
    if (showData) {
      return Text(
        ' ${DateFormat('dd-MM-yyyy').format(selecteData)} ',
        style: CustomTextStyle.createFontStyle,
      );
    } else {
      return const SizedBox
          .shrink(); // ถ้าไม่ควรแสดง QRCODE ให้ใช้ SizedBox.shrink() เพื่อซ่อน
    }
  }
}
