import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import '../../controller/student_controller.dart';
import '../../model/user.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import 'detail_editstudentprofile.dart';

class EditTeacherProfile extends StatefulWidget {
  final String id;
  const EditTeacherProfile({super.key, required this.id});

  @override
  State<EditTeacherProfile> createState() => _EditTeacherProfileState();
}

class _EditTeacherProfileState extends State<EditTeacherProfile> {
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

//ฟังชั่นโหลดข้อมูลเว็บ
  void userData(String id) async {
    setState(() {
      isLoaded = false;
    });

    users = await studentController.get_Userid(id);
    setDataToText();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
        body: Center(
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
                                Text(
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
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(),
                                  onPressed: () async {
                                    await Future.delayed(Duration
                                        .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return DetailEditStudentProfile(
                                          id: '${users?.id.toString()}');
                                    }));
                                  },
                                  child: Text("แก้ไขรหัสผ่าน"),
                                )
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
