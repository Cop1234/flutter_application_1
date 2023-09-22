import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/student_controller.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../../color.dart';
import '../../model/user.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import '../widget/navbar_admin.dart';
import 'detail_student.dart';
import 'insert_DataStudent.dart';

class ListStudent extends StatefulWidget {
  const ListStudent({super.key});

  @override
  State<ListStudent> createState() => _ListStudentState();
}

class _ListStudentState extends State<ListStudent> {
  final StudentController studentController = StudentController();

  final UserController userController = UserController();
  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  List<User>? users;
  void fetchData() async {
    List<User> userteacher = await studentController.listAllStudent();
    setState(() {
      users = userteacher;
      data = userteacher
          .map((user) => {
                'id': user.id,
                'userid': user.userid ?? "",
                'fname': user.fname ?? "",
                'lname': user.lname ?? "",
                'login': user.login ?? "",
              })
          .toList();
      //print(data);
      isLoaded = true;
    });
  }

  void showSureToDeleteStudent(String id) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการลบข้อมูลหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        onConfirmBtnTap: () async {
          http.Response response = await userController.deleteTeacher(id);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpDeleteStudentSuccessAlert();
          } else {
            showFailToDeleteStudentAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToDeleteStudentAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถลบข้อมูลได้",
        type: QuickAlertType.error);
  }

  void showUpDeleteStudentSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ListStudent()));
        });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromARGB(255, 226, 226, 226),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 1100,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return InsertDataStudent();
                                      }));
                                    });
                                  },
                                  child: Container(
                                      height: 35,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: maincolor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text("เพิ่มนักศึกษา",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => maincolor),
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black),
                            columns: const <DataColumn>[
                              DataColumn(
                                label: SizedBox(
                                  width: 200, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'รหัสนักศึกษา',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 200, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'ชื่อ',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 200, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'นามสกุล',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 200, // กำหนดความกว้างของ DataColumn
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'จัดการ',
                                      style: CustomTextStyle.TextHeadBar,
                                    ),
                                  ),
                                ),
                              ),
                              // Add more DataColumn as needed
                            ],
                            rows: data.asMap().entries.map((entry) {
                              Map<String, dynamic> row = entry.value;
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Container(
                                    width: 200,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        row['userid'],
                                        style: CustomTextStyle.TextGeneral,
                                      ),
                                    ),
                                  )),
                                  DataCell(
                                    Container(
                                      width: 200,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          row['fname'],
                                          style: CustomTextStyle.TextGeneral,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 200,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          row['lname'],
                                          style: CustomTextStyle.TextGeneral,
                                        ),
                                      ),
                                    ),
                                  ),

                                  DataCell(Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      width: 200,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: PopupMenuButton(
                                          icon: Icon(
                                            Icons.settings,
                                            color: Colors.white,
                                          ),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.change_circle,
                                                        color: Colors.black),
                                                    SizedBox(width: 10.0),
                                                    Text('แก้ไข'),
                                                  ],
                                                ),
                                                onTap: () async {
                                                  await Future.delayed(Duration
                                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                    return DetailStudent(
                                                        id: row['id']
                                                            .toString());
                                                  }));
                                                }),
                                            PopupMenuItem(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.delete,
                                                      color: Colors.black),
                                                  SizedBox(width: 10.0),
                                                  Text('ลบ'),
                                                ],
                                              ),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(seconds: 0),
                                                    () =>
                                                        showSureToDeleteStudent(
                                                            row['id']
                                                                .toString()));
                                                //String? gg = row['id'].toString() ?? "";
                                                //print(gg);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                  // Add more DataCell as needed
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
