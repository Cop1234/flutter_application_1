import 'package:flutter/material.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/room_controller.dart';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/screens/admin/list_room.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_admin.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class DetailRoomScreen extends StatefulWidget {
  final String id;
  const DetailRoomScreen({super.key, required this.id});

  @override
  State<DetailRoomScreen> createState() => _DetailRoomScreenState();
}

class _DetailRoomScreenState extends State<DetailRoomScreen> {
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  final RoomController roomController = RoomController();

  TextEditingController roomNameController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  Room? room;
  bool passToggle = true;
  bool? isLoaded = false;
  List<Room>? rooms;

  bool isRoomNameExists(String roomName, int roomId) {
    if (rooms != null) {
      return rooms!
          .any((room) => room.roomName == roomName && room.id != roomId);
    }
    return false;
  }

  void setDataToText() {
    roomNameController.text = room?.roomName ?? "";
    buildingController.text = room?.building ?? "";
    latitudeController.text = room?.latitude.toString() ?? "";
    longitudeController.text = room?.longitude.toString() ?? "";
  }

  void fetchData(String id) async {
    List<Room> fetchedRooms = await roomController.listAllRooms();
    room = await roomController.get_Room(id);
    setDataToText();
    setState(() {
      rooms = fetchedRooms;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.id);
  }

  void showSuccessToChangeRoomAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้ไขห้องเรียนสำเร็จ",
      text: "ข้อมูลห้องเรียนถูกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      barrierDismissible: false, // ปิดการคลิกพื้นหลังเพื่อป้องกันการปิด Alert
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ListRoomScreen(),
          ),
        );
      },
    );
  }

  void showErrorRoomNameExistsAlert(String roomName) {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "ชื่อห้อง $roomName มีอยู่ในระบบแล้ว",
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
                                    "ชื่อห้อง : ",
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
                                        controller: roomNameController,
                                        decoration: const InputDecoration(
                                          errorStyle: TextStyle(),
                                          filled:
                                              true, // เปิดการใช้งานการเติมพื้นหลัง
                                          fillColor: Colors.white,
                                          border: InputBorder
                                              .none, // กำหนดให้ไม่มีเส้นขอบ
                                        ),
                                        validator: (value) {
                                          bool roomNameValid =
                                              RegExp(r'^[a-zA-Z0-9ก-๙\s\-/]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกชื่อห้องเรียน*";
                                          } else if (!roomNameValid) {
                                            return "ชื่อห้องเรียนต้องเป็นภาษาไทย หรือ อังกฤษ หรือ ตัวเลข";
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Building
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  const Text(
                                    "ตึกเรียน : ",
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
                                        controller: buildingController,
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
                                          bool buildingValid =
                                              RegExp(r'^[a-zA-Z0-9ก-๙\s\-/]+$')
                                                  .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกตึกเรียน*";
                                          } else if (!buildingValid) {
                                            return "ตึกเรียนต้องเป็นภาษาไทย หรือ อังกฤษ";
                                          }
                                        },
                                      ),
                                    ),
                                  )
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
                                    "ละติจูด : ",
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
                                        controller: latitudeController,
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
                                        validator: (value) {
                                          bool latitudeValid = RegExp(
                                                  r'^(?=.*\d)(?=.*\.)[\d.]+$')
                                              .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกละติจูด*";
                                          } else if (!latitudeValid) {
                                            return "ละติจูดต้องเป็นตัวเลขทศนิยมเท่านั้น";
                                          }
                                        },
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
                                    "ลองติจูด : ",
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
                                        controller: longitudeController,
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
                                          bool longitudeValid = RegExp(
                                                  r'^(?=.*\d)(?=.*\.)[\d.]+$')
                                              .hasMatch(value!);
                                          if (value.isEmpty) {
                                            return "กรุณากรอกลองติจูด*";
                                          } else if (!longitudeValid) {
                                            return "ลองติจูดต้องเป็นตัวเลขทศนิยมเท่านั้น";
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
                                    await Future.delayed(Duration
                                        .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return const ListRoomScreen();
                                    }));
                                  },
                                  child: Container(
                                      height: 35,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: maincolor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: Text("ยกเลิก",
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
                                      String roomName = roomNameController.text;
                                      //String building = buildingController.text;
                                      int? roomId = room?.id;
                                      bool isExists =
                                          isRoomNameExists(roomName, roomId!);
                                      if (isExists) {
                                        showErrorRoomNameExistsAlert(roomName);
                                      } else {
                                        double? latitude = double.tryParse(
                                            latitudeController.text);
                                        double? longitude = double.tryParse(
                                            longitudeController.text);
                                        Room updateRoom = Room(
                                          id: room?.id,
                                          roomName: roomNameController.text,
                                          building: buildingController.text,
                                          latitude: latitude,
                                          longitude: longitude,
                                        );
                                        http.Response response =
                                            (await roomController
                                                .update_Room(updateRoom));

                                        if (response.statusCode == 200) {
                                          showSuccessToChangeRoomAlert();
                                          print("แก้ไขสำเร็จ");
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
                                        child: Text("แก้ไข",
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
