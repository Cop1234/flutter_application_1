import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';

import '../../controller/section_controller.dart';
import '../../model/section.dart';
import '../widget/mainTextStyle.dart';
import '../widget/my_abb_bar.dart';
import '../widget/navbar_teacher.dart';

class TeacherQR extends StatefulWidget {
  final String sectionId;
  const TeacherQR({super.key, required this.sectionId});

  @override
  State<TeacherQR> createState() => _TeacherQRState();
}

class _TeacherQRState extends State<TeacherQR> {
  final SectionController sectionController = SectionController();
  bool? isLoaded;
  String qrData = 'Initial Data'; // ข้อมูล QR code ตั้งต้น
  int countdown = 30;
  String? selectedDropdownValue = "1";
  bool showQRCode = false;
  int? sectionid;

  var startTimeForQR;
  String? formattedStartTime;

  Section? section;
  TextEditingController subjectid = TextEditingController();
  TextEditingController subjectName = TextEditingController();
  TextEditingController teacherFName = TextEditingController();
  TextEditingController teacherLName = TextEditingController();
  TextEditingController sectionNumber = TextEditingController();
  DateTime sectionTime = DateTime.now();
  TextEditingController room = TextEditingController();
  TextEditingController sectiontype = TextEditingController();
  TextEditingController building = TextEditingController();

  void setDataToText() {
    subjectid.text = section?.course?.subject?.subjectId ?? "";
    subjectName.text = section?.course?.subject?.subjectName ?? "";
    teacherFName.text = section?.user?.fname ?? "";
    teacherLName.text = section?.user?.lname ?? "";
    sectionNumber.text = section?.sectionNumber ?? "";
    building.text = section?.room?.building ?? "";
    sectionTime = DateFormat('HH:mm').parse(section?.startTime ?? "").toLocal();
    sectiontype.text = section?.type ?? "";
    room.text = section?.room?.roomName ?? "";
  }

  void userData(String sectionId) async {
    setState(() {
      isLoaded = false;
    });
    section = await sectionController.get_Section(sectionId);
    setDataToText();

    setState(() {
      startTimeForQR = section?.startTime;
      formattedStartTime = startTimeForQR?.replaceAll(':', '-');
      qrData =
          'DateScan:${DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()},TimeScan:${DateFormat('HH-mm-ss').format(DateTime.now()).toString()},Section:${section?.id},StartTime:$formattedStartTime';
      isLoaded = true;
    });
    print('ทดสอบ QR ${qrData}');
  }

////////////////////////////// dropdownItems ////////////////////////////////////////////////
  List<String> dropdownItems = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
  ];

  bool? stop = false;

  void onChangedDropdown(String? newValue) {
    setState(() {
      // Stop the existing countdown timer if it's running
      timecountdown?.cancel();
      QRCode?.cancel();
      selectedDropdownValue = newValue;
      showQRCode = true;
      // Start a new countdown timer
      startTimer();
      // Reset the QR code
      Qrcodereset();
      countdown = 30;
    });
  }

//////////////////////////////////////////////////////////////////////////////
  Timer? QRCode;
  int? timeqrcode;
  // สร้าง QR code และเปลี่ยนข้อมูลทุก 10 วินาที
  void generateQRCode() {
    setState(() {
      qrData =
          'DateScan:${DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()},TimeScan:${DateFormat('HH-mm-ss').format(DateTime.now()).toString()},Section:${section?.id},StartTime:$formattedStartTime';
    });
  }

  void Qrcodereset() {
    if (stop == false) {
      QRCode = Timer.periodic(const Duration(seconds: 30), (QRCode) {
        generateQRCode();
        Qrcodereset();
      });
      print('QRCODE $timeqrcode');
    }
  }

////////////////////////////////////////////////////////////////////////////

  Timer? timecountdown;
  // เริ่มต้น Timer
  void startTimer() {
    if (stop == false) {
      timecountdown =
          Timer.periodic(const Duration(seconds: 1), (timecountdown) {
        setState(() {
          if (countdown > 1) {
            countdown--;
          } else {
            countdown = 30;
          }
        });
      });
    }
  }

  /////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();

    userData(widget.sectionId);
    selectedDropdownValue = dropdownItems[0];
    setState(() {
      timeqrcode = countdown;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const NavbarTeacher(),
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
                                  borderRadius: BorderRadius.circular(10)),
                              color: const Color.fromARGB(255, 226, 226, 226),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 1200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "รหัสวิชา : ${subjectid.text}",
                                          style: CustomTextStyle.mainFontStyle,
                                        ),
                                        Text(
                                          "ชื่อวิชา : ${subjectName.text}",
                                          style: CustomTextStyle.mainFontStyle,
                                        ),
                                        Text(
                                          "อาจารย์ : ${teacherFName.text} ${teacherLName.text}",
                                          style: CustomTextStyle.mainFontStyle,
                                        ),
                                        Text(
                                          "กลุ่ม : ${sectionNumber.text}   " +
                                              "เวลา : ${DateFormat('jm').format(sectionTime)}   ",
                                          style: CustomTextStyle.mainFontStyle,
                                        ),
                                        Text(
                                          "ห้อง : ${room.text}   " +
                                              "ตึก : ${building.text}   ",
                                          style: CustomTextStyle.mainFontStyle,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
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
                              borderRadius: BorderRadius.circular(10)),
                          color: const Color.fromARGB(255, 226, 226, 226),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 1200,
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        height:
                                            16.0), // เพิ่มระยะห่างระหว่างปุ่มและ QR code
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Center(
                                          child: Text("สัปดาห์ที่ : ",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          // dropdown below..s
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: selectedDropdownValue,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                            items: dropdownItems
                                                .map<DropdownMenuItem<String>>(
                                                    (String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: onChangedDropdown,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            underline: const SizedBox(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: buildQRCodeWidget(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQRCodeWidget() {
    if (showQRCode) {
      return Column(
        children: [
          Center(
            child: QrImage(
                data:
                    '$qrData,Week:$selectedDropdownValue,timelimit:$timeqrcode', // ข้อมูล QR code
                version: QrVersions.auto,
                size: 400.0,
                foregroundColor: Colors.green // สีของรหัส QR นั้นเอง
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Countdown: ${countdown} seconds',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox
          .shrink(); // ถ้าไม่ควรแสดง QRCODE ให้ใช้ SizedBox.shrink() เพื่อซ่อน
    }
  }
}
