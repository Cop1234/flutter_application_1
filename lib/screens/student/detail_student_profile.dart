import 'package:flutter/material.dart';
import 'package:flutter_application_1/color.dart';
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
import 'edit_student_password.dart';

class DetailStudentProfile extends StatefulWidget {
  const DetailStudentProfile({super.key});

  @override
  State<DetailStudentProfile> createState() => _DetailStudentProfileState();
}

class _DetailStudentProfileState extends State<DetailStudentProfile> {
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
    selecteData =
        DateFormat('yyyy-MM-dd').parse(users?.birthdate ?? "").toLocal();
    genderController.text = users?.gender ?? "";
    typeuserController.text = users?.typeuser ?? "";
    loginidController.text = users?.login?.id.toString() ?? "";
    usernameController.text = users?.login?.username ?? "";
    passwordController.text = users?.login?.password.toString() ?? "";
  }

  String? IdUser;
//ฟังชั่นโหลดข้อมูลเว็บ
  void userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String? username = prefs.getString('username');
    String? username = "MJU6304106304";
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      if (user != null) {
        users = await studentController.get_Userid(user.id.toString());
      }
    }
    setDataToText();

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    userData();
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
                  const NavbarStudent(),
                  Expanded(
                    child: ListView(
                      children: [
                        Center(
                          child: Column(children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: const Color.fromARGB(
                                          255, 226, 226, 226),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "ชื่อ : ${users?.fname}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "นามสกุล : ${users?.lname}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "รหัสนักศึกษา : ${users?.userid}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "อีเมล : ${users?.email}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "ชื่อผู้ใช้ : ${users?.login?.username}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "เพศ : ${users?.gender}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                Text(
                                                  "วัน เดือน ปี ที่เกิด : ${DateFormat('dd-MM-yyyy').format(selecteData)}",
                                                  style: CustomTextStyle
                                                      .mainFontStyle,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Center(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40,
                                                          vertical: 15),
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20.0), // กำหนดมุม
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      await Future.delayed(Duration
                                                          .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                        return EditPasswordStudent(
                                                            id: '${users?.id.toString()}');
                                                      }));
                                                    },
                                                    child: const Text(
                                                        "แก้ไขรหัสผ่าน"),
                                                  ),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
