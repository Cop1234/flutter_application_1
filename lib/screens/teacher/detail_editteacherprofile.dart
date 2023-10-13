import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/screens/widget/navbar_teacher.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import 'package:quickalert/quickalert.dart';

import '../../color.dart';
import '../../model/user.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import 'edit_teacher_profile.dart';

class DetailEditTeacherProfile extends StatefulWidget {
  final String id;
  const DetailEditTeacherProfile({super.key, required this.id});

  @override
  State<DetailEditTeacherProfile> createState() =>
      _DetailEditTeacherProfileState();
}

class _DetailEditTeacherProfileState extends State<DetailEditTeacherProfile> {
  final UserController userController = UserController();

  //List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  //List<User>? users;
  bool passToggle = true;
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
            builder: (context) => EditProfileTeacherScreen(),
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
        body: Form(
          key: _formfield,
          child: Column(children: [
            NavbarTeacher(),
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
                                          obscureText: passToggle,
                                          decoration: InputDecoration(
                                              errorStyle: TextStyle(),
                                              filled:
                                                  true, // เปิดการใช้งานการเติมพื้นหลัง
                                              fillColor: Colors.white,
                                              border: InputBorder
                                                  .none, // กำหนดให้ไม่มีเส้นขอบ
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
                                            bool subjectNameValid = RegExp(
                                                    r'^(?=.*[A-Za-z0-9])[A-Za-z0-9]{8,16}$')
                                                .hasMatch(value!);
                                            if (value.isEmpty) {
                                              return "กรุณากรอกรหัสผ่าน*";
                                            } else if (!subjectNameValid) {
                                              return "กรุณากรอกรหัสผ่านให้ถูกต้อง";
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
                                      width: 10,
                                    ),
                                    Container(
                                      width: 500,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        obscureText:
                                            true, // To hide the confirmation password input
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          // bool aa.hasMatch(value!);
                                          //bool get isEmpty(value!);
                                          if (value!.isEmpty) {
                                            return "กรุณายืนยันรหัสผ่าน*";
                                          } else if (value !=
                                              passwordController.text) {
                                            return "รหัสผ่านไม่ตรงกัน";
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
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
                                          return EditProfileTeacherScreen();
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
                                              await userController.updateTeacher(
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
