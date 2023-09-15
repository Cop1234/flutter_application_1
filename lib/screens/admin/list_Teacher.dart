import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../../color.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import '../widget/navbar_admin.dart';
import 'add_teacher.dart';
import 'detail_teacher.dart';

class ListTeacher extends StatefulWidget {
  const ListTeacher({super.key});

  @override
  State<ListTeacher> createState() => _ListTeacherState();
}

class _ListTeacherState extends State<ListTeacher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final UserController userController = UserController();

  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  List<User>? users;

//ฟังชั่นโหลดข้อมูลเว็บ
  void fetchData() async {
    List<User> userteacher = await userController.listAllTeacher();
    setState(() {
      users = userteacher;
      data = userteacher
          .map((user) => {
                'id': user.id,
                'userid': user.userid,
                'fname': user.fname,
                'lname': user.lname,
              })
          .toList();
      isLoaded = true;
    });
  }

  void showSureToDeleteTeacher(String id) {
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
            showUpDeleteTeacherSuccessAlert();
          } else {
            showFailToDeleteTeacherAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToDeleteTeacherAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถลบข้อมูลได้",
        type: QuickAlertType.error);
  }

  void showUpDeleteTeacherSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ListTeacher()));
        });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                                        return AddTeacher();
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
                                        child: Text("เพิ่มอาจารย์",
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
                                      'รหัสอาจารย์',
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
                                                  /*Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                    return DetailTeacher(
                                                        id: row['id']
                                                            .toString());
                                                  }))*/
                                                  ;
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
                                                    () => showSureToDeleteTeacher(
                                                        row['id'].toString() ??
                                                            ""));
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
