import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/add_room.dart';
import 'package:flutter_application_1/screens/admin/detail_room.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/room_controller.dart';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_admin.dart';
import 'package:http/http.dart' as http;

class ListRoomScreen extends StatefulWidget {
  const ListRoomScreen({super.key});

  @override
  State<ListRoomScreen> createState() => _ListRoomScreenState();
}

class _ListRoomScreenState extends State<ListRoomScreen> {
  final RoomController roomController = RoomController();

  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  List<Room>? rooms;

  //ฟังชั่นโหลดข้อมูลเว็บ
  void fetchData() async {
    List<Room> fetchedRooms = await roomController.listAllRooms();

    setState(() {
      rooms = fetchedRooms;
      data = fetchedRooms
          .map((room) => {
                'id': room.id,
                'roomName': room.roomName,
                'building': room.building,
                'latitude': room.latitude,
                'longitude': room.longitude,
              })
          .toList();
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void showSureToDeleteRoomAlert(String id) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการลบข้อมูลห้องเรียนหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
        onConfirmBtnTap: () async {
          http.Response response = await roomController.deleteRoom(id);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpDeleteRoomSuccessAlert();
          } else {
            showFailToDeleteRoomAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToDeleteRoomAlert() {
    QuickAlert.show(
      context: context,
      title: "เกิดข้อผิดพลาด",
      text: "ไม่สามารถลบข้อมูลห้องเรียนได้",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  void showUpDeleteRoomSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ListRoomScreen()));
        });
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
              const NavbarAdmin(),
              const Padding(
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
                                padding: const EdgeInsets.only(right: 15),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return AddRoomScreen();
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
                                        child: const Text("เพิ่มห้องเรียน",
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
                                      'ลำดับ',
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
                                      'ห้องเรียน',
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
                                      'ตึกเรียน',
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
                              int index = entry.key + 1; // นับลำดับเริ่มจาก 1
                              Map<String, dynamic> row = entry.value;
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Container(
                                    width: 200,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(index.toString(),
                                          style: CustomTextStyle.TextGeneral),
                                    ),
                                  )),
                                  DataCell(
                                    Container(
                                      width: 200,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          row['roomName'],
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
                                          row['building'],
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
                                                    return DetailRoomScreen(
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
                                                    () => showSureToDeleteRoomAlert(
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
