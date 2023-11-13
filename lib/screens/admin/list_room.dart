import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/section_controller.dart';
import 'package:flutter_application_1/model/section.dart';
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
  final SectionController sectionController = SectionController();

  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> dataForCheck = [];
  List<Room>? rooms;
  List<Section>? sections;
  bool? isLoaded = false;
  bool isRoomInUse = true;

  //ฟังชั่นโหลดข้อมูลเว็บ
  void fetchData() async {
    List<Room> fetchedRooms = await roomController.listAllRooms();
    List<Section> fetchedSections = await sectionController.listAllSection();

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
      dataForCheck = fetchedSections
          .map((section) => {
                'id': section.id,
                'roomId': section.room?.id,
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

  //เช็คว่าห้องมีการใช้งานอยู่ไหม
  void isRoomIdInDataForCheck(int roomId) {
    // ใช้ any() เพื่อตรวจสอบว่ามีข้อมูลใด ๆ ใน dataForCheck ที่มี 'roomId' เท่ากับ roomId
    bool isRoomInUseCheck =
        dataForCheck.any((data) => data['roomId'] == roomId);

    if (isRoomInUseCheck) {
      // หากมี roomId ใน dataForCheck
      isRoomInUse = false;
      print('Room ID $roomId is in dataForCheck.');
    } else {
      // หากไม่มี roomId ใน dataForCheck
      isRoomInUse = true;
      print('Room ID $roomId is not in dataForCheck.');
    }
  }

  void showSureToDeleteRoomAlert(String id) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการลบข้อมูลห้องเรียนหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        onConfirmBtnTap: () async {
          http.Response response = await roomController.deleteRoom(id);

          if (response.statusCode == 200) {
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ListRoomScreen()),
            (route) => false,
          );
        });
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
                const NavbarAdmin(),
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: const Color.fromARGB(255, 226, 226, 226),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 1100,
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                    return const AddRoomScreen();
                                                  }));
                                                });
                                              },
                                              child: Container(
                                                  height: 35,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                    color: maincolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                        "เพิ่มห้องเรียน",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      DataTable(
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => maincolor),
                                        dataRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.white),
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  100, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'ลำดับ',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  300, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'ห้องเรียน',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  300, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'ตึกเรียน',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: SizedBox(
                                              width:
                                                  100, // กำหนดความกว้างของ DataColumn
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'จัดการ',
                                                  style: CustomTextStyle
                                                      .TextHeadBar,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Add more DataColumn as needed
                                        ],
                                        rows: data.asMap().entries.map((entry) {
                                          int index = entry.key +
                                              1; // นับลำดับเริ่มจาก 1
                                          Map<String, dynamic> row =
                                              entry.value;
                                          isRoomIdInDataForCheck(row['id']);
                                          bool isRoomEnabled =
                                              isRoomInUse; // ตั้งค่าตัวแปร isRoomEnabled เป็นค่า isRoomInUse
                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(Container(
                                                width: 100,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(index.toString(),
                                                      style: CustomTextStyle
                                                          .TextGeneral2),
                                                ),
                                              )),
                                              DataCell(
                                                Container(
                                                  width: 300,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      row['roomName'],
                                                      style: CustomTextStyle
                                                          .TextGeneral2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Container(
                                                  width: 300,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      row['building'],
                                                      style: CustomTextStyle
                                                          .TextGeneral2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Container(
                                                  width: 100,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: PopupMenuButton(
                                                      icon: const Icon(
                                                        Icons.settings,
                                                        color: Colors.black,
                                                      ),
                                                      itemBuilder: (context) =>
                                                          [
                                                        PopupMenuItem(
                                                            child: Row(
                                                              children: const <
                                                                  Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .change_circle,
                                                                    color: Colors
                                                                        .black),
                                                                SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Text('แก้ไข'),
                                                              ],
                                                            ),
                                                            onTap: () async {
                                                              await Future
                                                                  .delayed(
                                                                      Duration
                                                                          .zero);
                                                              Navigator
                                                                  .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return DetailRoomScreen(
                                                                      id: row['id']
                                                                          .toString());
                                                                }),
                                                                (route) =>
                                                                    false,
                                                              );
                                                            }),
                                                        PopupMenuItem(
                                                          child: Row(
                                                            children: const <
                                                                Widget>[
                                                              Icon(Icons.delete,
                                                                  color: Colors
                                                                      .black),
                                                              SizedBox(
                                                                  width: 10.0),
                                                              Text('ลบ'),
                                                            ],
                                                          ),
                                                          enabled:
                                                              isRoomEnabled,
                                                          onTap: () {
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 0),
                                                                () => showSureToDeleteRoomAlert(
                                                                    row['id']
                                                                            .toString() ??
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
                ),
              ],
            ),
    );
  }
}
