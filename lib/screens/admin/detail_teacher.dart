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
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  TimeOfDay time = TimeOfDay(hour: 8, minute: 0);
  TextEditingController timePicker = TextEditingController();
  var items = ['ชาย', 'หญิง'];
  bool? isLoaded;
  User? users;

  TextEditingController useridController = TextEditingController();
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
    useridController.text = users?.userid ?? "";
    emailController.text = users?.email ?? "";
    fnameController.text = users?.fname ?? "";
    lnameController.text = users?.lname ?? "";
    selecteData = DateFormat('yyyy-MM-dd').parse(users?.birthdate ?? "");
    genderController.text = users?.gender ?? "";
    typeuserController.text = users?.typeuser ?? "";
    loginidController.text = users?.login?.id.toString() ?? "";
    usernameController.text = users?.login?.username ?? "";
    passwordController.text = users?.login?.password ?? "";
  }

  dynamic dropdownvalue;
  String? user_id;
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

  void showSuccessToChangeUserAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้ไขอาจารย์",
      text: "ข้อมูลอาจารย์ถูกแก้ไขเรียบร้อยแล้ว",
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
      body: ListView(
        children: [
          Column(
            children: [
              NavbarAdmin(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "ชื่อผู้ใช้ : " +
                                        '${users?.login?.username}',
                                    style: CustomTextStyle.createFontStyle,
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
                                    "รหัสผ่าน : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 500,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        bool subjectNameValid = RegExp(
                                                r'^(?=.*[A-Za-z0-9])[A-Za-z0-9]{8,16}$')
                                            .hasMatch(value!);
                                        if (value.isEmpty) {
                                          return "กรุณากรอกรหัสผ่าน*";
                                        } else if (!subjectNameValid) {
                                          return "กรุณากรอกรหัสผ่านให้ถูกต้อง";
                                        }
                                        return null;
                                      },
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
                                    "รหัสประจำตัว : " + "${users?.userid}",
                                    style: CustomTextStyle.createFontStyle,
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
                                  SizedBox(width: 10),
                                  Container(
                                    width: 500,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        bool emailValid = RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                            .hasMatch(value!);
                                        if (value.isEmpty) {
                                          return "กรุณากรอกอีเมล*";
                                        } else if (!emailValid) {
                                          return "กรุณากรอกอีเมลให้ถูกต้อง";
                                        }
                                        return null;
                                      },
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
                                  SizedBox(width: 10),
                                  Container(
                                    width: 500,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: fnameController,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        bool nameValid = RegExp(r'^[ก-์]+$')
                                            .hasMatch(value!);
                                        if (value.isEmpty) {
                                          return "กรุณากรอกชื่อ*";
                                        } else if (!nameValid) {
                                          return "ชื่อต้องเป็นภาษาไทยเท่านั้น";
                                        }
                                        return null;
                                      },
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
                                  SizedBox(width: 10),
                                  Container(
                                    width: 500,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: lnameController,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        bool nameValid = RegExp(r'^[ก-์]+$')
                                            .hasMatch(value!);
                                        if (value.isEmpty) {
                                          return "กรุณากรอกนามกุล*";
                                        } else if (!nameValid) {
                                          return "ชื่อนามกุลต้องเป็นภาษาไทย";
                                        }
                                        return null;
                                      },
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
                                    '  ${DateFormat('dd-MM-yyyy').format(selecteData)}  ',
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  ElevatedButton(
                                    child: const Text("Date"),
                                    onPressed: () async {
                                      final DateTime? dateTime =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: selecteData,
                                        firstDate: DateTime(1000),
                                        lastDate: DateTime(3000),
                                      );
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
                            SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "เพศ : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 100,
                                    height: 40,
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: users?.gender ??
                                          items[0], // กำหนดค่าเริ่มต้น
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
                                          dropdownvalue = newValue;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await Future.delayed(Duration.zero);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return ListTeacher();
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: maincolor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "ยกเลิก",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () async {
                                    if (_formfield.currentState!.validate()) {
                                      http.Response response =
                                          await userController.updateTeacher(
                                              '${users?.id}',
                                              emailController.text,
                                              fnameController.text,
                                              lnameController.text,
                                              DateFormat('dd/MM/yyyy')
                                                  .format(selecteData)
                                                  .toString(),
                                              genderController.text,
                                              loginidController.text,
                                              passwordController.text);

                                      if (response.statusCode == 200) {
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

                                /*
                                  onTap: () async {
                                    print(dropdownvalue);
                                    print(DateFormat('dd/MM/yyyy')
                                        .format(selecteData)
                                        .toString());
                                    print(users?.id);
                                    print(users?.login);
                                    print(emailController.text);
                                    print(fnameController.text);
                                    print(genderController.text);
                                    print(lnameController.text);
                                    print(typeuserController.text);
                                    print(useridController.text);

                                    print(users?.login?.id);
                                    print(users?.login?.username);
                                    print(users?.login?.password);
                                    /////////////////////////////////////////////////////
                                    User updateTeacher = User(
                                      birthdate: DateFormat('dd/MM/yyyy')
                                          .format(selecteData)
                                          .toString(),
                                      id: users?.id,
                                      login: users?.login,
                                      email: emailController.text,
                                      fname: fnameController.text,
                                      gender: genderController
                                          .text, // ใช้ dropdownvalue
                                      lname: lnameController.text,
                                      typeuser: typeuserController.text,
                                      userid: useridController.text,
                                    );

                                    print(updateTeacher);

                                    if (_formfield.currentState!.validate()) {
                                      http.Response response =
                                          await userController
                                              .updateTeacher(updateTeacher);

                                      if (response.statusCode == 200) {
                                        showSuccessToChangeUserAlert();
                                        print("แก้ไขสำเร็จ");
                                      }
                                    }
                                    ////////////////////////////////////////////////////////////////////
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: maincolor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "แก้ไข",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
