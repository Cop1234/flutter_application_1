import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/subject_controller.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/screens/admin/list_subject.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_admin.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  final SubjectController subjectController = SubjectController();

  TextEditingController subjectIdController = TextEditingController();
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController creditController = TextEditingController();

  bool passToggle = true;
  bool? isLoaded = false;
  List<Subject>? subjects;

  // ฟังก์ชันเช็ค subjectId ว่ามีอยู่ใน subjects หรือไม่
  bool isSubjectIdExists(String subjectId) {
    if (subjects != null) {
      return subjects!.any((subject) => subject.subjectId == subjectId);
    }
    return false;
  }

  //ฟังชั่นโหลดข้อมูลเว็บ
  void fetchData() async {
    List<Subject> fetchedSubjects = await subjectController.listAllSubjects();

    setState(() {
      subjects = fetchedSubjects;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void showSuccessToAddSubjectAlert() {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มวิชาสำเร็จ",
      text: "ข้อมูลวิชาถูกเพิ่มเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ListSubjectScreen(),
          ),
        );
      },
    );
  }

  void showErrorSubjectIdExistsAlert(String subjectId) {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "รายวิชา $subjectId มีอยู่ในระบบแล้ว",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: kMyAppBar,
        backgroundColor: Colors.white,
        body: ListView(children: [
          Column(children: [
            const NavbarAdmin(),
            Form(
              key: _formfield,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                            //RoomName
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  const Text(
                                    "รหัสวิชา : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 500,
                                    child: Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: subjectIdController,
                                        decoration: const InputDecoration(
                                          errorStyle: TextStyle(),
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                        ),
                                        validator: (value) {
                                          bool subjectIdValid =
                                              RegExp(r'^[0-9ก-๙\s\-/]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกรหัสวิชา*";
                                          } else if (!subjectIdValid) {
                                            return "รหัสวิชาต้องเป็นภาษาไทยและมีตัวเลข";
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
                                  const Text(
                                    "ชื่อวิชา : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 500,
                                    child: Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: subjectNameController,
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
                                              RegExp(r'^[a-zA-Z0-9ก-๙\s\-/]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกชื่อวิชา*";
                                          } else if (!subjectNameValid) {
                                            return "ชื่อวิชาต้องเป็นภาษาไทย หรือ อังกฤษ หรือ ตัวเลข";
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Latitude
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  const Text(
                                    "รายละเอียด : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 500,
                                    child: Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: detailController,
                                        decoration: const InputDecoration(
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                          enabledBorder: OutlineInputBorder(
                                            //borderRadius: BorderRadius.circular(10.0), // กำหนดมุมโค้ง
                                            borderSide: BorderSide
                                                .none, // กำหนดให้ไม่มีเส้นขอบ
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //Longtitude
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  const Text(
                                    "หน่วยกิต : ",
                                    style: CustomTextStyle.createFontStyle,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Adjust the width for spacing
                                  Container(
                                    width: 500,
                                    child: Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: creditController,
                                        decoration: const InputDecoration(
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide
                                                .none, // กำหนดให้ไม่มีเส้นขอบ
                                          ),
                                        ),
                                        validator: (value) {
                                          bool creditValid = RegExp(r'^[\d]+$')
                                              .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกหน่วยกิต*";
                                          } else if (!creditValid) {
                                            return "หน่วยกิตต้องเป็นตัวเลขจำนวนเต็มเท่านั้น";
                                          }
                                        },
                                      ),
                                    ),
                                  )
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
                                    subjectIdController.text = "";
                                    subjectNameController.text = "";
                                    detailController.text = "";
                                    creditController.text = "";
                                  },
                                  child: Container(
                                      height: 35,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: Text("รีเซ็ต",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (_formfield.currentState!.validate()) {
                                      String subjectId =
                                          subjectIdController.text;

                                      // เช็คว่า subjectId มีอยู่ใน subjects หรือไม่
                                      bool isExists =
                                          isSubjectIdExists(subjectId);

                                      if (isExists) {
                                        // แสดง Alert หรือข้อความว่า subjectId มีอยู่ในระบบแล้ว
                                        showErrorSubjectIdExistsAlert(
                                            subjectId);
                                      } else {
                                        // ทำการ addSubject เมื่อ subjectId ไม่ซ้ำ
                                        http.Response response =
                                            await subjectController.addSubject(
                                          subjectId,
                                          subjectNameController.text,
                                          detailController.text,
                                          creditController.text,
                                        );

                                        if (response.statusCode == 200) {
                                          showSuccessToAddSubjectAlert();
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
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
            )
          ]),
        ]));
  }
}
