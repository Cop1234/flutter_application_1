import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Alignment textHeaderbar = Alignment.centerLeft;
  bool? inputroomName = false;

  var items = [
    'อาคารจุฬาภรณ์',
    'อาคารเทพ พงษ์พานิช',
    'อาคารสำนักงานบัณฑิตวิทยาลัยและศูนย์ภาษา',
    'อาคารเพิ่มพูล',
    'อาคารเรียนรวม 60 ปี',
    'อาคารเรียนรวมแม่โจ้ 70 ปี',
    'อาคารเสาวรัจ นิตยวรรธนะ',
    'อาคาร 75 ปี',
    'อาคารช่วงเกษตรศิลป์',
    'อาคารเรียนรวมสุวรรณวาจกกสิกิจ',
    'อาคารเฉลิมพระเกียรตสมพระเทพฯ',
    'อาคารเฉลิมพระเกียรติสมเด็จพระศรีนครินทร์',
    'อาคาร 25 ปี คณะธุรกิจการเกษตร',
    'อาคารประเสริฐ นคร',
    'อาคารเรียนและปฎิบัติการรวมทางปฐพีวิทยา',
    'อาคารกำจรบุญแบ่ง',
    'อาคารรัตนโกสินทร์ 200 ปี',
    'อาคารคณะเทคโนโลยีการประมงและทรัพยากรน้ำ',
    'อาคารเทคโนโลยีภูมิทัศน์',
    'อาคารเกษตรกลวิธาน',
    'อาคารสมิตตานนท์',
    'อาคารโรงงานนำร่อง',
    'อาคารธรรมศักดิ์มนตรี',
    'อาคารเรียนรวม 80 ปี',
    'อาคารศูนย์สัตว์ศาสตร์และเทคโนโลยี'
  ];
  String dropdownvalue = 'อาคารจุฬาภรณ์';

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
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
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
                              color: Colors.white,
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
                                        const Center(
                                            child: Text("เพิ่มห้องเรียน",
                                                style: CustomTextStyle
                                                    .Textheader)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: Table(
                                            // border: TableBorder.all(),
                                            columnWidths: const {
                                              0: FractionColumnWidth(0.25),
                                              1: FractionColumnWidth(0.5),
                                            },
                                            children: [
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    child: IntrinsicWidth(
                                                      child: Container(
                                                        alignment:
                                                            textHeaderbar,
                                                        padding: EdgeInsets.all(
                                                            12.0),
                                                        child: const Text(
                                                          "ชื่อห้อง",
                                                          style: CustomTextStyle
                                                              .createFontStyle,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: IntrinsicWidth(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 8.0,
                                                          top: 8.0,
                                                          right: 8.0,
                                                          bottom: 8.0,
                                                        ),
                                                        child: Container(
                                                          width: 120,
                                                          height: 50,
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .centerStart,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 20.0,
                                                            top: 15.0,
                                                            right: 10.0,
                                                            bottom: 10.0,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            border: inputroomName!
                                                                ? Border.all(
                                                                    color: Colors
                                                                        .red)
                                                                : Border.all(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 2.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: TextFormField(
                                                            controller:
                                                                roomNameController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            inputFormatters: <TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'^[a-zA-Z0-9ก-๙\s\-]+$')),
                                                            ],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                            validator: (String?
                                                                value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                setState(() {
                                                                  inputroomName =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  inputroomName =
                                                                      false;
                                                                });
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              errorBorder:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  'ชื่อห้องต้องเป็นภาษาไทยและมีตัวเลข',
                                                              hintStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                color: inputroomName!
                                                                    ? Colors.red
                                                                        .withOpacity(
                                                                            0.5)
                                                                    : Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    child: IntrinsicWidth(
                                                      child: Container(
                                                        alignment:
                                                            textHeaderbar,
                                                        padding: EdgeInsets.all(
                                                            12.0),
                                                        child: const Text(
                                                          "ตึกเรียน",
                                                          style: CustomTextStyle
                                                              .createFontStyle,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: IntrinsicWidth(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0,
                                                                top: 8.0,
                                                                right: 8.0,
                                                                bottom: 8.0),
                                                        child: //ปุ่มเลือกระยะเวลาเรียน
                                                            Container(
                                                          width: 300,
                                                          height: 50,
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .centerStart,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20.0,
                                                                  top: 10.0,
                                                                  right: 10.0,
                                                                  bottom: 10.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 2.0),
                                                          ),
                                                          // dropdown below..
                                                          child: DropdownButton<
                                                              String>(
                                                            isExpanded: true,
                                                            value:
                                                                dropdownvalue,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                            items: items.map(
                                                              (String items) {
                                                                return DropdownMenuItem(
                                                                  value: items,
                                                                  child: Text(
                                                                      items),
                                                                );
                                                              },
                                                            ).toList(),
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                dropdownvalue =
                                                                    newValue!;
                                                              });
                                                            },
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),
                                                            underline:
                                                                const SizedBox(),
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
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                roomNameController.text = "";
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
                                                        .validate() &&
                                                    inputroomName == false) {
                                                  String roomName =
                                                      roomNameController.text;
                                                  String building =
                                                      dropdownvalue;
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
                                                                    .text =
                                                                dropdownvalue,
                                                            latitudeController
                                                                .text = "99.99",
                                                            longitudeController
                                                                    .text =
                                                                "99.99");

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
