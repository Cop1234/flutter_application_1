import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/login.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';

import '../../color.dart';
import '../../controller/user_controller.dart';
import '../../model/user.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import '../widget/navbar_admin.dart';
import 'add_teacher.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import 'list_Teacher.dart';

class DetailTeacher extends StatefulWidget {
  //const DetailTeacher({super.key});
  final String id;
  const DetailTeacher({super.key, required this.id});
  @override
  State<DetailTeacher> createState() => _DetailTeacherState();
}

class _DetailTeacherState extends State<DetailTeacher> {
  final UserController userController = UserController();
  bool? isLoaded = false;
  bool showData = true;
  bool passToggle = true;
  User? users;
  Login? logins;
  dynamic dropdownvalue;
  String? user_id;

  TextEditingController user_idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  DateTime selecteData = DateTime.now();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController typeuserController = TextEditingController();
  TextEditingController loginidController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void setDataToText() {
    user_idController.text = users?.id.toString() ?? "";

    emailController.text = users?.email ?? "";
    fnameController.text = users?.fname ?? "";
    lnameController.text = users?.lname ?? "";
    selecteData =
        DateFormat('yyyy-MM-dd').parse(users?.birthdate ?? "").toLocal();
    genderController.text = users?.gender ?? "";
    typeuserController.text = users?.typeuser ?? "";
    loginidController.text = users?.login?.id.toString() ?? "";
    usernameController.text = users?.login?.username ?? "";
    passwordController.text = users?.login?.password.toString() ?? "";
  }

//ฟังชั่นโหลดข้อมูลเว็บ
  void userData(String id) async {
    setState(() {
      isLoaded = false;
    });

    users = await userController.get_Userid(id);
    setDataToText();
    setState(() {
      user_id = id.toString();
      dropdownvalue = users?.gender;
      print("gender : " + dropdownvalue);
    });
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    userData(widget.id);
  }

  TimeOfDay time = TimeOfDay(hour: 8, minute: 0);
  TextEditingController timePicker = TextEditingController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  var items = ['ชาย', 'หญิง'];

  void showSuccessToChangeUserAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้ไขวิชาสำเร็จ",
      text: "ข้อมูลวิชาถูกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
        body: isLoaded == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(maincolor),
                    ),
                  ),
                ],
              )
            : Column(
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
                                    child: Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, bottom: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'ชื่อผู้ใช้ : ${users?.login?.username}',
                                                  style: CustomTextStyle
                                                      .createFontStyle,
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
                                                  style: CustomTextStyle
                                                      .createFontStyle,
                                                ),
                                                const SizedBox(
                                                    width:
                                                        10), // Adjust the width for spacing
                                                Container(
                                                  width: 500,
                                                  child: Expanded(
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          emailController,
                                                      decoration:
                                                          const InputDecoration(
                                                        errorStyle: TextStyle(),
                                                        filled:
                                                            true, // เปิดการใช้งานการเติมพื้นหลัง
                                                        fillColor: Colors.white,
                                                        border: InputBorder
                                                            .none, // กำหนดให้ไม่มีเส้นขอบ
                                                      ),
                                                      validator: (value) {
                                                        bool subjectNameValid =
                                                            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                                                .hasMatch(
                                                                    value!);
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
                                                  style: CustomTextStyle
                                                      .createFontStyle,
                                                ),
                                                const SizedBox(
                                                    width:
                                                        10), // Adjust the width for spacing
                                                Container(
                                                  width: 500,
                                                  child: Expanded(
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          fnameController,
                                                      decoration:
                                                          const InputDecoration(
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
                                                                .hasMatch(
                                                                    value!);
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
                                            padding: const EdgeInsets.only(
                                                top: 20, bottom: 5),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "นามกุล : ",
                                                  style: CustomTextStyle
                                                      .createFontStyle,
                                                ),
                                                const SizedBox(
                                                    width:
                                                        10), // Adjust the width for spacing
                                                Container(
                                                  width: 500,
                                                  child: Expanded(
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          lnameController,
                                                      decoration:
                                                          const InputDecoration(
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
                                                                .hasMatch(
                                                                    value!);
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
                                            padding: const EdgeInsets.only(
                                                top: 20, bottom: 5),
                                            child: Row(
                                              children: <Widget>[
                                                const Text("วันเกิด : ",
                                                    style: CustomTextStyle
                                                        .createFontStyle),
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
                                                    if (pickedDate != null) {
                                                      setState(() {
                                                        showData = true;
                                                        selecteData =
                                                            pickedDate;
                                                      });
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
                                                              10)),
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
                                                  await Future.delayed(Duration
                                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                    return const ListTeacher();
                                                  }));
                                                },
                                                child: Container(
                                                    height: 35,
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: const Center(
                                                      child: Text("ยกเลิก",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  print(user_idController.text);
                                                  if (_formfield.currentState!
                                                      .validate()) {
                                                    http.Response response =
                                                        await userController.updateTeacher(
                                                            user_idController
                                                                .text,
                                                            emailController
                                                                .text,
                                                            fnameController
                                                                .text,
                                                            lnameController
                                                                .text,
                                                            birthdateController
                                                                .text = DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(
                                                                    selecteData)
                                                                .toString(),
                                                            genderController
                                                                    .text =
                                                                dropdownvalue);

                                                    if (response.statusCode ==
                                                        200) {
                                                      showSuccessToChangeUserAlert();
                                                      print("บันทึกสำเร็จ");
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    height: 35,
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      color: maincolor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: const Center(
                                                      child: Text("ยืนยัน",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
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
