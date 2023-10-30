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

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  final RoomController roomController = RoomController();

  TextEditingController roomNameController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  bool passToggle = true;
  bool? isLoaded = false;
  List<Room>? rooms;

  // ฟังก์ชันเช็ค roomName ว่ามีอยู่ใน rooms หรือไม่
  bool isRoomNameExists(String roomName, String building) {
    if (rooms != null) {
      return rooms!.any(
          (room) => room.roomName == roomName && room.building == building);
    }
    return false;
  }

  //ฟังชั่นโหลดข้อมูลเว็บ
  void fetchData() async {
    List<Room> fetchedRooms = await roomController.listAllRooms();

    setState(() {
      rooms = fetchedRooms;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void showSuccessToAddRoomAlert() {
    QuickAlert.show(
      context: context,
      title: "การเพิ่มห้องเรียนสำเร็จ",
      text: "ข้อมูลห้องเรียนถูกเพิ่มเรียบร้อยแล้ว",
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
                    child: ListView(children: [
                      Column(children: [
                        Form(
                          key: _formfield,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //RoomName
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 5),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "ชื่อห้อง : ",
                                                style: CustomTextStyle
                                                    .createFontStyle,
                                              ),
                                              const SizedBox(
                                                  width:
                                                      10), // Adjust the width for spacing
                                              Container(
                                                width: 500,
                                                child: Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        roomNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      errorStyle: TextStyle(),
                                                      filled:
                                                          true, // เปิดการใช้งานการเติมพื้นหลัง
                                                      fillColor: Colors.white,
                                                      border: InputBorder
                                                          .none, // กำหนดให้ไม่มีเส้นขอบ
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide
                                                            .none, // กำหนดให้ไม่มีเส้นขอบ
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      bool roomNameValid = RegExp(
                                                              r'^[a-zA-Z0-9ก-๙\s\-/]+$')
                                                          .hasMatch(value!);
                                                      if (value.isEmpty) {
                                                        return "กรุณากรอกชื่อห้องเรียน*";
                                                      } else if (!roomNameValid) {
                                                        return "ชื่อห้องเรียนต้องเป็นภาษาไทย หรือ อังกฤษ หรือ ตัวเลข สามารถใส่อังษรพิเศษ - หรือ / ได้";
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
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 5),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "ตึกเรียน : ",
                                                style: CustomTextStyle
                                                    .createFontStyle,
                                              ),
                                              const SizedBox(
                                                  width:
                                                      10), // Adjust the width for spacing
                                              Container(
                                                width: 500,
                                                child: Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        buildingController,
                                                    decoration:
                                                        const InputDecoration(
                                                      filled:
                                                          true, // เปิดการใช้งานการเติมพื้นหลัง
                                                      fillColor: Colors.white,
                                                      border: InputBorder
                                                          .none, // กำหนดให้ไม่มีเส้นขอบ
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide
                                                            .none, // กำหนดให้ไม่มีเส้นขอบ
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      bool buildingValid = RegExp(
                                                              r'^[a-zA-Z0-9ก-๙\s\-/]+$')
                                                          .hasMatch(value!);
                                                      if (value.isEmpty) {
                                                        return "กรุณากรอกตึกเรียน*";
                                                      } else if (!buildingValid) {
                                                        return "ตึกเรียนต้องเป็นภาษาไทย หรือ อังกฤษ สามารถใส่อังษรพิเศษ - หรือ / ได้";
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
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 5),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "ละติจูด : ",
                                                style: CustomTextStyle
                                                    .createFontStyle,
                                              ),
                                              const SizedBox(
                                                  width:
                                                      10), // Adjust the width for spacing
                                              Container(
                                                width: 500,
                                                child: Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        latitudeController,
                                                    decoration:
                                                        const InputDecoration(
                                                      filled:
                                                          true, // เปิดการใช้งานการเติมพื้นหลัง
                                                      fillColor: Colors.white,
                                                      border: InputBorder
                                                          .none, // กำหนดให้ไม่มีเส้นขอบ
                                                      enabledBorder:
                                                          OutlineInputBorder(
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
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 5),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "ลองจิจูด : ",
                                                style: CustomTextStyle
                                                    .createFontStyle,
                                              ),
                                              const SizedBox(
                                                  width:
                                                      10), // Adjust the width for spacing
                                              Container(
                                                width: 500,
                                                child: Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        longitudeController,
                                                    decoration:
                                                        const InputDecoration(
                                                      filled:
                                                          true, // เปิดการใช้งานการเติมพื้นหลัง
                                                      fillColor: Colors.white,
                                                      border: InputBorder
                                                          .none, // กำหนดให้ไม่มีเส้นขอบ
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide
                                                            .none, // กำหนดให้ไม่มีเส้นขอบ
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      bool longitudeValid =
                                                          RegExp(r'^(?=.*\d)(?=.*\.)[\d.]+$')
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                roomNameController.text = "";
                                                buildingController.text = "";
                                                latitudeController.text = "";
                                                longitudeController.text = "";
                                              },
                                              child: Container(
                                                  height: 35,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Center(
                                                    child: Text("รีเซ็ต",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (_formfield.currentState!
                                                    .validate()) {
                                                  String roomName =
                                                      roomNameController.text;
                                                  String building =
                                                      buildingController.text;
                                                  bool isExists =
                                                      isRoomNameExists(
                                                          roomName, building);
                                                  if (isExists) {
                                                    showErrorRoomNameExistsAlert(
                                                        roomName);
                                                  } else {
                                                    http.Response response =
                                                        await roomController.addRoom(
                                                            roomNameController
                                                                .text,
                                                            buildingController
                                                                .text,
                                                            latitudeController
                                                                .text,
                                                            longitudeController
                                                                .text);

                                                    if (response.statusCode ==
                                                        200) {
                                                      showSuccessToAddRoomAlert();
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Center(
                                                    child: Text("ยืนยัน",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
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
                    ]),
                  ),
                ],
              ));
  }
}
