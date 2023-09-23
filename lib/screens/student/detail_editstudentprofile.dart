import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/student/view_student_subject.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../../color.dart';
import '../../controller/student_controller.dart';
import '../../model/user.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';

class DetailEditStudentProfile extends StatefulWidget {
  final String id;

  const DetailEditStudentProfile({super.key, required this.id});

  @override
  State<DetailEditStudentProfile> createState() =>
      _DetailEditStudentProfileState();
}

class _DetailEditStudentProfileState extends State<DetailEditStudentProfile> {
  final StudentController studentController = StudentController();

  //List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  //List<User>? users;

  User? users;

  TextEditingController user_idController = TextEditingController();
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
    user_idController.text = users?.id.toString() ?? "";
    useridController.text = users?.userid ?? "";
    emailController.text = users?.email ?? "";
    fnameController.text = users?.fname ?? "";
    lnameController.text = users?.lname ?? "";
    selecteData = DateFormat('yyyy-MM-dd').parse(users?.birthdate ?? "");
    genderController.text = users?.gender ?? "";
    typeuserController.text = users?.typeuser ?? "";
    loginidController.text = users?.login?.id.toString() ?? "";
    usernameController.text = users?.login?.username ?? "";
    passwordController.text = users?.login?.password.toString() ?? "";
  }

//ฟังชั่นโหลดข้อมูลเว็บ
  dynamic dropdownvalue;
  String? user_id;
//ฟังชั่นโหลดข้อมูลเว็บ
  void userData(String id) async {
    setState(() {
      isLoaded = false;
    });

    users = await studentController.get_Userid(id);
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
    // userData();
    userData(widget.id);
  }

  TimeOfDay time = TimeOfDay(hour: 8, minute: 0);
  TextEditingController timePicker = TextEditingController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  var items = ['ชาย', 'หญิง'];

  void showSuccessToChangeUserAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้สำเร็จ",
      text: "ข้อมูลถูกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ViewStudentSubject(),
          ),
        );
      },
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
        body: ListView(children: [
          Column(children: [
            NavbarStudent(),
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
                        child: Expanded(
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
                                      'ชื่อผู้ใช้ : ${users?.login?.username}',
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

                                    SizedBox(
                                        width:
                                            10), // Adjust the width for spacing
                                    Container(
                                      width: 500,
                                      child: Expanded(
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: passwordController,
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
                                                    r'^(?=.*[A-Za-z0-9])[A-Za-z0-9]{8,16}$')
                                                .hasMatch(value!);
                                            if (value.isEmpty) {
                                              return "กรุณากรอกรหัสผ่าน*";
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
                                      "รหัสประจำตัว : " + "${users?.userid}",
                                      style: CustomTextStyle.createFontStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 5),
                                child: Row(children: [
                                  Text(
                                    "อีเมล : " + "${users?.email}",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                ]),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "ชื่อ : " + "${users?.fname}",
                                      style: CustomTextStyle.createFontStyle,
                                    ),
                                    SizedBox(width: 10)
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "นามกุล : " + "${users?.lname}",
                                      style: CustomTextStyle.createFontStyle,
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Adjust the width for spacing
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
                                        style: CustomTextStyle.createFontStyle),
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
                                      "เพศ : " + "${users?.gender}",
                                      style: CustomTextStyle.createFontStyle,
                                    ),
                                    SizedBox(
                                        //genderController
                                        width:
                                            10), // Adjust the width for spacing
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
                                      await Future.delayed(Duration
                                          .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return ViewStudentSubject();
                                      }));
                                    },
                                    child: Container(
                                        height: 35,
                                        width: 110,
                                        decoration: BoxDecoration(
                                          color: maincolor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text("ยกเลิก",
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
                                      print(user_idController.text);
                                      if (_formfield.currentState!.validate()) {
                                        http.Response response =
                                            await studentController.updateStudent(
                                                user_idController.text,
                                                emailController.text,
                                                fnameController.text,
                                                lnameController.text,
                                                birthdateController.text =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(selecteData)
                                                        .toString(),
                                                genderController.text =
                                                    dropdownvalue,
                                                '${users?.login?.id.toString()}',
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
              ),
            )
          ]),
        ]));
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
        body: Form(
          key: _formfield,
          child: Column(children: [
            NavbarStudent(),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 0,
                      child: ClipRRect(
                        child: SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("images/mjuicon.png"),
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(),
                                  onPressed: () {},
                                  child: Text("เปลี่ยนรูปโปรไฟล์"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Color.fromARGB(255, 226, 226, 226),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 800,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                /*Text(
                                  "ชื่อ : ${users?.fname}",
                                  style: CustomTextStyle.mainFontStyle,
                                ),
                                Text(
                                  "นามสกุล : ${users?.lname}",
                                  style: CustomTextStyle.mainFontStyle,
                                ),
                                Text(
                                  "รหัสนักศึกษา : ${users?.userid}",
                                  style: CustomTextStyle.mainFontStyle,
                                ),
                                Text(
                                  "อีเมล : ${users?.email}",
                                  style: CustomTextStyle.mainFontStyle,
                                ),
                                Text(
                                  "ชื่อผู้ใช้ : ${users?.login?.username}",
                                  style: CustomTextStyle.mainFontStyle,
                                ),
                                Text(
                                  "เพศ : ${users?.gender}",
                                  style: CustomTextStyle.mainFontStyle,
                                ),
                                Text(
                                  "วัน เดือน ปี ที่เกิด : ${DateFormat('dd-MM-yyyy').format(selecteData)}",
                                  style: CustomTextStyle.mainFontStyle,
                                ),
                                SizedBox(
                                  height: 15,
                                ),*/
                                Row(
                                  children: [
                                    Text(
                                      "รหัสผ่าน : ",
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
                                          controller: passwordController,
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
                                                    r'^(?=.*[A-Za-z0-9])[A-Za-z0-9]{8,16}$')
                                                .hasMatch(value!);
                                            if (value.isEmpty) {
                                              return "กรุณากรอกรหัสผ่าน*";
                                            } else if (!subjectNameValid) {
                                              return "กรุณากรอกอีเมลให้ถูกต้อง";
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "ยืนยันรหัสผ่าน : ",
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
                                          controller: passwordController,
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
                                                    r'^(?=.*[A-Za-z0-9])[A-Za-z0-9]{8,16}$')
                                                .hasMatch(value!);
                                            if (value.isEmpty) {
                                              return "กรุณากรอกรหัสผ่าน*";
                                            } else if (!subjectNameValid) {
                                              return "กรุณากรอกอีเมลให้ถูกต้อง";
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await Future.delayed(Duration
                                            .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return ViewStudentSubject();
                                        }));
                                      },
                                      child: Container(
                                          height: 35,
                                          width: 110,
                                          decoration: BoxDecoration(
                                            color: maincolor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text("ยกเลิก",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        print(user_idController.text);
                                        if (_formfield.currentState!
                                            .validate()) {
                                          http.Response response =
                                              await studentController.updateStudent(
                                                  user_idController.text,
                                                  emailController.text,
                                                  fnameController.text,
                                                  lnameController.text,
                                                  birthdateController.text =
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(selecteData)
                                                          .toString(),
                                                  genderController.text =
                                                      dropdownvalue,
                                                  '${users?.login?.id.toString()}',
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
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
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
