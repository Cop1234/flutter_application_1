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

  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  List<User>? users;

  // ฟังก์ชันเช็ค username ว่ามีอยู่ใน user หรือไม่
  bool isUserNameExists(String username) {
    if (username != null) {
      return users!.any((user) => user.login?.username == username);
    }
    return false;
  }

  //ฟังชั่นโหลดข้อมูลเว็บ
  void fetchData() async {
    List<User> fetchedUsers = await userController.listAllTeacher();

    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void showSuccessToAddTeacherAlert() {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มอาจารย์",
      text: "ข้อมูลอาจารย์ถูกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ListTeacher(),
          ),
        );
      },
    );
  }

  void showErrorUserNameExistsAlert(String usename) {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "ชื่อผู้ใช่ $usename มีอยู่ในระบบแล้ว",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
      //barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
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
                        color: const Color.fromARGB(255, 226, 226, 226),
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "ชื่อผู้ใช้ : ",
                                          style:
                                              CustomTextStyle.createFontStyle,
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Adjust the width for spacing
                                        Container(
                                          width: 500,
                                          child: Expanded(
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  loginUsernameController,
                                              decoration: const InputDecoration(
                                                errorStyle: TextStyle(),
                                                filled:
                                                    true, // เปิดการใช้งานการเติมพื้นหลัง
                                                fillColor: Colors.white,
                                                border: InputBorder
                                                    .none, // กำหนดให้ไม่มีเส้นขอบ
                                              ),
                                              validator: (value) {
                                                bool loginUsernameValid = RegExp(
                                                        r'^[A-Za-z0-9!@#\$%^&*.]{12,30}$')
                                                    .hasMatch(value!);
                                                if (value.isEmpty) {
                                                  return "กรุณากรอกชื่อผู้ใช้";
                                                } else if (!loginUsernameValid) {
                                                  return "ต้องมีความยาว 12-30 ตัวอักษร";
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "รหัสผ่าน : ",
                                          style:
                                              CustomTextStyle.createFontStyle,
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Adjust the width for spacing
                                        Container(
                                          width: 500,
                                          child: Expanded(
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller:
                                                  loginPasswordController,
                                              obscureText: passToggle,
                                              decoration: InputDecoration(
                                                  errorStyle: const TextStyle(),
                                                  filled:
                                                      true, // เปิดการใช้งานการเติมพื้นหลัง
                                                  fillColor: Colors.white,
                                                  border: InputBorder
                                                      .none, // กำหนดให้ไม่มีเส้นขอบ

                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        passToggle =
                                                            !passToggle;
                                                      });
                                                    },
                                                    child: Icon(passToggle
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
                                                  )),
                                              validator: (value) {
                                                bool loginPasswordValid = RegExp(
                                                        r'^(?=.*[A-Za-z])(?=.*[!@#\$%^&*])[A-Za-z0-9!@#\$%^&*]{8,16}$')
                                                    .hasMatch(value!);
                                                if (value.isEmpty) {
                                                  return "กรุณากรอกรหัสผ่าน*";
                                                } else if (!loginPasswordValid) {
                                                  return "กรุณากรอกรหัสผ่านเป็นภาษาอังกฤษตัวใหญ่หรือตัวเล็กอักษรพิเศษและตัวเลข \n ความยาว 8-16 ให้ถูกต้อง";
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "ยืนยันรหัสผ่าน : ",
                                          style:
                                              CustomTextStyle.createFontStyle,
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Adjust the width for spacing
                                        Container(
                                          width: 500,
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            obscureText: passToggle,

                                            // To hide the confirmation password input
                                            decoration: InputDecoration(
                                                errorStyle: TextStyle(),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                                suffixIcon: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      passToggle = !passToggle;
                                                    });
                                                  },
                                                  child: Icon(passToggle
                                                      ? Icons.visibility
                                                      : Icons.visibility_off),
                                                )),
                                            validator: (value) {
                                              // bool aa.hasMatch(value!);
                                              //bool get isEmpty(value!);
                                              if (value!.isEmpty) {
                                                return "กรุณายืนยันรหัสผ่าน*";
                                              } else if (value !=
                                                  loginPasswordController
                                                      .text) {
                                                return "รหัสผ่านไม่ตรงกัน";
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "อีเมล : ",
                                          style:
                                              CustomTextStyle.createFontStyle,
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Adjust the width for spacing
                                        Container(
                                          width: 500,
                                          child: Expanded(
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: emailController,
                                              decoration: const InputDecoration(
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
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "ชื่อ : ",
                                          style:
                                              CustomTextStyle.createFontStyle,
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Adjust the width for spacing
                                        Container(
                                          width: 500,
                                          child: Expanded(
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: fnameController,
                                              decoration: const InputDecoration(
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
                                                  return "ชื่อต้องเป็นภาษาไทยเท่านั้นเท่านั้น";
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "นามสกุล : ",
                                          style:
                                              CustomTextStyle.createFontStyle,
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Adjust the width for spacing
                                        Container(
                                          width: 500,
                                          child: Expanded(
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: lnameController,
                                              decoration: const InputDecoration(
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
                                                  return "ชื่อนามกุลต้องเป็นภาษาไทยเท่านั้น";
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        const Text("วันเกิด : ",
                                            style: CustomTextStyle
                                                .createFontStyle),
                                        ShowSelectDate(),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
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
                                            if (pickedDate != null) {
                                              setState(() {
                                                showData = true;
                                                selecteData = pickedDate;
                                              });
                                            }
                                          },
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons
                                                    .calendar_today, // ไอคอนของปฏิทิน
                                                color:
                                                    Colors.white, // สีของไอคอน
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  //Longtitude
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "เพศ : ",
                                          style:
                                              CustomTextStyle.createFontStyle,
                                        ),
                                        const SizedBox(
                                            //genderController
                                            width:
                                                10), // Adjust the width for spacing
                                        Container(
                                          width: 100,
                                          height: 40,
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownvalue = newValue!;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            underline: const SizedBox(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
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
                                              .validate()) {
                                            String usernameCheck =
                                                loginUsernameController.text;

                                            // เช็คว่า username มีอยู่ใน user หรือไม่
                                            bool isExists =
                                                isUserNameExists(usernameCheck);

                                            if (isExists) {
                                              // แสดง Alert หรือข้อความว่า username มีอยู่ในระบบแล้ว
                                              showErrorUserNameExistsAlert(
                                                  usernameCheck);
                                            } else {
                                              http.Response response =
                                                  await userController.addTeacher(
                                                      loginUsernameController
                                                          .text,
                                                      loginPasswordController
                                                          .text,
                                                      emailController.text,
                                                      fnameController.text,
                                                      lnameController.text,
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(selecteData)
                                                          .toString(),
                                                      genderController.text =
                                                          dropdownvalue
                                                              .toString());

                                              if (response.statusCode == 200) {
                                                showSuccessToAddTeacherAlert();
                                                print("บันทึกสำเร็จ");
                                              }
                                            }
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
                  )
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
