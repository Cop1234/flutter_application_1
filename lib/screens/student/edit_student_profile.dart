import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/screens/widget/navbar_student.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/student_controller.dart';
import '../../model/user.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import 'detail_editstudentprofile.dart';

class EditStudentProfile extends StatefulWidget {
  const EditStudentProfile({super.key});

  @override
  State<EditStudentProfile> createState() => _EditStudentProfileState();
}

class _EditStudentProfileState extends State<EditStudentProfile> {
  final StudentController studentController = StudentController();
  final UserController userController = UserController();
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

  String? IdUser;
/*
  void fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      if (user != null) {
        IdUser = user.id.toString();
        //print(IdUser);
        // เมื่อค้นพบ id ของผู้ใช้ ให้ดึงรายการคอร์สและเซคชันต่อไป
        fetchUserCourses(IdUser);
      }
    }
  }*/

//ฟังชั่นโหลดข้อมูลเว็บ
  void userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      if (user != null) {
        //IdUser = user.id.toString();
        //print(IdUser);
        // เมื่อค้นพบ id ของผู้ใช้ ให้ดึงรายการคอร์สและเซคชันต่อไป
        //fetchUserCourses(IdUser);

        users = await studentController.get_Userid(user.id.toString());
      }
    }

    //users = await studentController.get_Userid(id);
    setDataToText();

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // userData();
    userData();
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
