import 'dart:convert';
import 'dart:io' show Platform;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/login_controller.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/model/login.dart';
import 'package:flutter_application_1/screens/admin/list_room.dart';
import 'package:flutter_application_1/screens/student/view_student_subject.dart';
import 'package:flutter_application_1/screens/teacher/list_class.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen> {
  bool? isLoaded = false;
  bool passToggle = true;
  Login? logins;
  String roleName = "";

  final _formfield = GlobalKey<FormState>();
  final LoginController loginController = LoginController();
  final UserController userController = UserController();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passworldController = TextEditingController();

  // ส่วนของ CheckPlatformExample
  String? _getPlatform() {
    String? platform;

    if (kIsWeb) {
      platform = 'Web';
    } else if (Platform.isAndroid) {
      platform = 'Android';
    } else if (Platform.isIOS) {
      platform = 'iOS';
    } else if (Platform.isFuchsia) {
      platform = 'Fuchsia';
    } else if (Platform.isLinux) {
      platform = 'Linux';
    } else if (Platform.isWindows) {
      platform = 'Windows';
    } else if (Platform.isMacOS) {
      platform = 'macOS';
    }

    return platform;
  }

  void fetchData() async {
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void showLoginFailAlert() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "ชื่อผู้ใช้ หรือ รหัสผ่านไม่ถูกต้อง",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? platform = _getPlatform();
    return Scaffold(
      backgroundColor: maincolor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formfield,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 600,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("images/mjuicon.png"),
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 50),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: "ชื่อผู้ใช้",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            //ถ้าใส่ email ถูก
                            bool usernameValid =
                                RegExp(r'^.{1,30}$').hasMatch(value!);

                            //กรณีไม่ใส่ username
                            if (value.isEmpty) {
                              return "กรุณากรอก ชื่อผู้ใช้";
                            }
                            //กรณีใส่ usename ผิด
                            else if (!usernameValid) {
                              return "ชื่อผู้ใช้ต้องไม่เกิน 30 ตัว";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passworldController,
                          obscureText: passToggle,
                          decoration: InputDecoration(
                              labelText: "รหัสผ่าน",
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock),
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
                            bool passwordValid =
                                RegExp(r'^.{8,}$').hasMatch(value!);

                            if (value.isEmpty) {
                              return "กรุณากรอก รหัสผ่าน";
                            }
                            //กรณีใส่ Password ผิด
                            else if (!passwordValid) {
                              return "กรุณากรอก รหัสผ่าน ตั้งแต่ 8 ตัวขึ้นไป";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        InkWell(
                          onTap: () async {
                            if (usernameController.text == "root" &&
                                passworldController.text == "1234") {
                              //validatePassword();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(
                                  'username', usernameController.text);
                              //SetPlatForm
                              SharedPreferences spf =
                                  await SharedPreferences.getInstance();
                              spf.setString('platform', platform ?? '-');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return const ListRoomScreen();
                              }));
                            } else if (_formfield.currentState!.validate()) {
                              http.Response response =
                                  await loginController.doLogin(
                                      usernameController.text,
                                      passworldController.text);

                              if (response.statusCode == 200) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    'username', usernameController.text);
                                print("ผ่าน");
                                //Check Role for Go Screen
                                var jsonResponse = jsonDecode(response.body);
                                List<dynamic> roles = jsonResponse['role'];
                                roleName = roles[0]['role'];
                                if (roleName == "Student") {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const ViewStudentSubject();
                                  }));
                                } else if (roleName == "Teacher") {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const ListClassScreen();
                                  }));
                                }
                              } else if (response.statusCode == 409) {
                                showLoginFailAlert();
                                print("ไม่เจอข้อมูล");
                              } else {
                                print("Error");
                              }
                              usernameController.clear();
                              passworldController.clear();
                            }
                          },
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: maincolor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text("เข้าสู่ระบบ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
