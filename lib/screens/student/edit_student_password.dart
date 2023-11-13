import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/login_controller.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/screens/student/view_student_subject.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/strings.dart';

import '../../color.dart';
import '../../controller/student_controller.dart';
import '../../model/user.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import 'detail_student_profile.dart';

class EditPasswordStudent extends StatefulWidget {
  final String id;

  const EditPasswordStudent({super.key, required this.id});

  @override
  State<EditPasswordStudent> createState() => _EditPasswordStudentState();
}

class _EditPasswordStudentState extends State<EditPasswordStudent> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final LoginController loginController = LoginController();
  final UserController userController = UserController();
  final StudentController studentController = StudentController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  bool? isLoaded = false;
  bool passToggle1 = true;
  bool passToggle2 = true;
  bool passToggle3 = true;
  User? user;
  String? username;
  String? password;
  String? originalPassword;

  void userData(String id) async {
    user = await userController.get_Userid(id);
    username = user?.login?.username.toString();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // userData();
    userData(widget.id);
  }

  void showSuccessToChangeUserAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้ไขรหัสผ่านสำเร็จ",
      text: "รหัสผ่านถูกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      barrierDismissible: false,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DetailStudentProfile()),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Color.fromARGB(255, 226, 226, 226),
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
                  const NavbarStudent(),
                  Expanded(
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                            ),
                            Form(
                              key: _formfield,
                              child: Column(children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color: Colors.white,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: SizedBox(
                                              width: 500,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(30.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          "เปลี่ยนรหัสผ่าน",
                                                          style: CustomTextStyle
                                                              .mainFontStyle),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Text(
                                                      "รหัสผ่านเดิม",
                                                      style: CustomTextStyle
                                                          .subFontStyle,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          oldPasswordController,
                                                      obscureText: passToggle1,
                                                      decoration:
                                                          InputDecoration(
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .black, // กำหนดสีของ labelText
                                                                      fontSize:
                                                                          20.0, // กำหนดขนาดตัวอักษรของ labelText
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              errorStyle:
                                                                  const TextStyle(),
                                                              suffixIcon:
                                                                  InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    passToggle1 =
                                                                        !passToggle1;
                                                                  });
                                                                },
                                                                child: Icon(passToggle1
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off),
                                                              )),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "กรุณากรอกรหัสผ่านเดิม*";
                                                        } else if (value !=
                                                            password) {
                                                          return "รหัสผ่านเดิมไม่ถูกต้อง";
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Text(
                                                      "รหัสผ่านใหม่",
                                                      style: CustomTextStyle
                                                          .subFontStyle,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          newPasswordController,
                                                      obscureText: passToggle2,
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .black, // กำหนดสีของ labelText
                                                                      fontSize:
                                                                          20.0, // กำหนดขนาดตัวอักษรของ labelText
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              errorStyle:
                                                                  const TextStyle(),
                                                              suffixIcon:
                                                                  InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    passToggle2 =
                                                                        !passToggle2;
                                                                  });
                                                                },
                                                                child: Icon(passToggle2
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off),
                                                              )),
                                                      validator: (value) {
                                                        bool subjectNameValid =
                                                            RegExp(r'^(?=.*[A-Za-z])(?=.*[!@#\$%^&*])[A-Za-z0-9!@#\$%^&*]{8,16}$')
                                                                .hasMatch(
                                                                    value!);
                                                        if (value.isEmpty) {
                                                          return "กรุณากรอกรหัสผ่านใหม่*";
                                                        } else if (!subjectNameValid) {
                                                          return "กรุณากรอกรหัสผ่านเป็นภาษาอังกฤษอักษรพิเศษ\nและตัวเลขความยาว 8-16 ตัว";
                                                        } else if (newPasswordController
                                                                .text ==
                                                            oldPasswordController
                                                                .text) {
                                                          return "รหัสผ่านใหม่ต้องไม่เหมือนรหัสผ่านเดิม!!";
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Text(
                                                      "ยืนยันรหัสผ่านใหม่",
                                                      style: CustomTextStyle
                                                          .subFontStyle,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      obscureText: passToggle3,
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .black, // กำหนดสีของ labelText
                                                                      fontSize:
                                                                          20.0, // กำหนดขนาดตัวอักษรของ labelText
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              errorStyle:
                                                                  const TextStyle(),
                                                              suffixIcon:
                                                                  InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    passToggle3 =
                                                                        !passToggle3;
                                                                  });
                                                                },
                                                                child: Icon(passToggle3
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off),
                                                              )),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "กรุณากรอกยืนยันรหัสผ่าน*";
                                                        } else if (value !=
                                                            newPasswordController
                                                                .text) {
                                                          return "ยืนยันรหัสผ่านไม่ตรงกัน";
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        40,
                                                                    vertical:
                                                                        10),
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0), // กำหนดมุม
                                                            ),
                                                            primary: Colors.red,
                                                          ),
                                                          onPressed: () async {
                                                            await Future.delayed(
                                                                Duration
                                                                    .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const DetailStudentProfile()),
                                                              (route) => false,
                                                            );
                                                          },
                                                          child: const Text(
                                                              "ยกเลิก",
                                                              style: CustomTextStyle
                                                                  .TextGeneral),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        40,
                                                                    vertical:
                                                                        10),
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0), // กำหนดมุม
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            http.Response
                                                                response =
                                                                await loginController
                                                                    .change_Password(
                                                                        username!,
                                                                        oldPasswordController
                                                                            .text);
                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              password =
                                                                  oldPasswordController
                                                                      .text;
                                                            } else {
                                                              password = "";
                                                            }
                                                            if (_formfield
                                                                .currentState!
                                                                .validate()) {
                                                              http.Response
                                                                  response =
                                                                  await studentController.updatePasswordStudent(
                                                                      '${user?.login?.id.toString()}',
                                                                      newPasswordController
                                                                          .text);

                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                showSuccessToChangeUserAlert();
                                                                print(
                                                                    "บันทึกสำเร็จ");
                                                              }
                                                            }
                                                          },
                                                          child: const Text(
                                                              "ยืนยัน",
                                                              style: CustomTextStyle
                                                                  .TextGeneral),
                                                        ),
                                                      ],
                                                    ),
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
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
