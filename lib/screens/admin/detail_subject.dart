import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/subject_controller.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/screens/admin/list_subject.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_admin.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class DetailSubjectScreen extends StatefulWidget {
  final String id;
  const DetailSubjectScreen({super.key, required this.id});

  @override
  State<DetailSubjectScreen> createState() => _DetailSubjectScreenState();
}

class _DetailSubjectScreenState extends State<DetailSubjectScreen> {
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  final SubjectController subjectController = SubjectController();

  TextEditingController subjectIdController = TextEditingController();
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController creditController = TextEditingController();

  Subject? subject;
  bool passToggle = true;
  bool? isLoaded = false;
  List<Subject>? subjects;

  Alignment textHeaderbar = Alignment.centerLeft;
  bool? inputGroupNumber = false;
  bool? inputSubjectId = false;
  bool? inputsubjectName = false;

  void setDataToText() {
    subjectIdController.text = subject?.subjectId ?? "";
    subjectNameController.text = subject?.subjectName ?? "";
    detailController.text = subject?.detail ?? "";
    creditController.text = subject?.credit.toString() ?? "";
  }

  // ฟังก์ชันเช็ค subjectId ว่ามีอยู่ใน subjects หรือไม่
  bool isSubjectIdExists(String subjectId, int id) {
    if (subjects != null) {
      return subjects!
          .any((subject) => subject.subjectId == subjectId && subject.id != id);
    }
    return false;
  }

  void fetchData(String id) async {
    List<Subject> fetchedSubjects = await subjectController.listAllSubjects();
    subject = await subjectController.get_Subject(id);
    setDataToText();
    setState(() {
      subjects = fetchedSubjects;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.id);
  }

  void showSuccessToChangeSubjectAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้ไขวิชาสำเร็จ",
      text: "ข้อมูลวิชาถูกแก้ไขเรียบร้อยแล้ว",
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
                                  width: 800,
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Center(
                                            child: Text("แก้ไขวิชา",
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
                                                          "รหัสวิชา",
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
                                                            border: inputSubjectId!
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
                                                                subjectIdController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            inputFormatters: <TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'^[ก-๙0-9\s\-/]*$')),
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
                                                                  inputSubjectId =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  inputSubjectId =
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
                                                                  'รหัสวิชาต้องเป็นภาษาไทยและมีตัวเลข',
                                                              hintStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                color: inputSubjectId!
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
                                                          "ชื่อวิชา",
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
                                                            border: inputsubjectName!
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
                                                                subjectNameController,
                                                            // ปรับให้รับตัวอักษรภาษาไทยและตัวเลข
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            inputFormatters: <TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .allow(
                                                                RegExp(
                                                                    r'^[a-zA-Z0-9ก-๙\s\-/]+$'),
                                                              ),
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
                                                                  inputsubjectName =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  inputsubjectName =
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
                                                                  'ชื่อวิชาต้องเป็นภาษาไทย หรือ อังกฤษ หรือ ตัวเลข',
                                                              hintStyle:
                                                                  TextStyle(
                                                                fontSize: 18,
                                                                color: inputsubjectName!
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
                                                          "หน่วยกิต",
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
                                                                  bottom: 8.0),
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
                                                                    bottom:
                                                                        10.0),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border: inputGroupNumber!
                                                                    ? Border.all(
                                                                        color: Colors
                                                                            .red)
                                                                    : Border.all(
                                                                        color: Colors
                                                                            .green,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            // dropdown below..
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  creditController,
                                                              //ปรับให้กรอกแค่ตัวเลข
                                                              keyboardType:
                                                                  const TextInputType
                                                                          .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                              inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        r'^[1-9]\d*')),
                                                              ],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                              ),

                                                              validator:
                                                                  (String?
                                                                      value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  setState(() {
                                                                    inputGroupNumber =
                                                                        true;
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    inputGroupNumber =
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
                                                                    'ระบุกลุ่มเรียนเป็นตัวเลขเช่น 1 2',
                                                                hintStyle: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: inputGroupNumber!
                                                                        ? Colors
                                                                            .red
                                                                            .withOpacity(
                                                                                0.5)
                                                                        : Colors
                                                                            .black
                                                                            .withOpacity(0.5)),
                                                              ),
                                                            ),
                                                          )),
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
                                                          "รายละเอียด",
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
                                                                  bottom: 8.0),
                                                          child: Container(
                                                            width: 120,
                                                            height: 150,
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .centerStart,

                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            // dropdown below..
                                                            child:
                                                                TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .multiline,
                                                              maxLines: 6,
                                                              controller:
                                                                  detailController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
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
                                                await Future.delayed(Duration
                                                    .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                  return const ListSubjectScreen();
                                                }));
                                              },
                                              child: Container(
                                                  height: 35,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Center(
                                                    child: Text("ยกเลิก",
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
                                                int? credit = int.tryParse(
                                                    creditController.text);

                                                if (_formfield.currentState!
                                                    .validate()) {
                                                  String subjectId =
                                                      subjectIdController.text;
                                                  int? id = subject?.id;

                                                  // เช็คว่า subjectId มีอยู่ใน subjects หรือไม่
                                                  bool isExists =
                                                      isSubjectIdExists(
                                                          subjectId, id!);
                                                  if (isExists) {
                                                    // แสดง Alert หรือข้อความว่า subjectId มีอยู่ในระบบแล้ว
                                                    showErrorSubjectIdExistsAlert(
                                                        subjectId);
                                                  } else {
                                                    // ทำการ addSubject เมื่อ subjectId ไม่ซ้ำ
                                                    Subject updateSubject =
                                                        Subject(
                                                      id: subject?.id,
                                                      subjectId:
                                                          subjectIdController
                                                              .text,
                                                      subjectName:
                                                          subjectNameController
                                                              .text,
                                                      detail:
                                                          detailController.text,
                                                      credit: credit,
                                                    );
                                                    http.Response response =
                                                        (await subjectController
                                                            .update_Subject(
                                                                updateSubject));

                                                    if (response.statusCode ==
                                                        200) {
                                                      showSuccessToChangeSubjectAlert();
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Center(
                                                    child: Text("แก้ไข",
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
