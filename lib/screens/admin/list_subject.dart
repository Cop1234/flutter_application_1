import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color.dart';
import 'package:flutter_application_1/controller/section_controller.dart';
import 'package:flutter_application_1/controller/subject_controller.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/screens/admin/add_subject.dart';
import 'package:flutter_application_1/screens/admin/detail_subject.dart';
import 'package:flutter_application_1/screens/widget/mainTextStyle.dart';
import 'package:flutter_application_1/screens/widget/my_abb_bar.dart';
import 'package:flutter_application_1/screens/widget/navbar_admin.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class ListSubjectScreen extends StatefulWidget {
  const ListSubjectScreen({super.key});

  @override
  State<ListSubjectScreen> createState() => _ListSubjectScreenState();
}

class _ListSubjectScreenState extends State<ListSubjectScreen> {
  final SubjectController subjectController = SubjectController();
  final SectionController sectionController = SectionController();

  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> dataForCheck = [];
  bool isSubjectInUse = true;
  bool? isLoaded = false;
  List<Subject>? subjects;
  List<Section>? sections;

  //ฟังชั่นโหลดข้อมูลเว็บ
  void fetchData() async {
    List<Subject> fetchedSubjects = await subjectController.listAllSubjects();
    List<Section> fetchedSections = await sectionController.listAllSection();

    setState(() {
      subjects = fetchedSubjects;
      data = fetchedSubjects
          .map((subject) => {
                'id': subject.id,
                'subjectId': subject.subjectId,
                'subjectName': subject.subjectName,
                'detail': subject.detail,
                'credit': subject.credit,
              })
          .toList();
      dataForCheck = fetchedSections
          .map((section) => {
                'id': section.id,
                'IdSubject': section.course?.subject?.id,
              })
          .toList();
      print(dataForCheck);
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //เช็คว่ารายวิชานี้มีการใช้งานอยู่ไหม
  void isSubjectIdInDataForCheck(int subjectId) {
    bool isSubjectInUseCheck =
        dataForCheck.any((data) => data['IdSubject'] == subjectId);

    if (isSubjectInUseCheck) {
      // หากมี subjectId ใน dataForCheck
      isSubjectInUse = false;
      print('Subject ID $subjectId is in dataForCheck.');
    } else {
      // หากไม่มี subjectId ใน dataForCheck
      isSubjectInUse = true;
      print('Subject ID $subjectId is not in dataForCheck.');
    }
  }

  void showSureToDeleteSubjectAlert(String subjectId) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการลบข้อมูลวิชาหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        barrierDismissible: false,
        onConfirmBtnTap: () async {
          http.Response response =
              await subjectController.deleteSubject(subjectId);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpDeleteSubjectSuccessAlert();
          } else {
            showFailToDeleteSubjectAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToDeleteSubjectAlert() {
    QuickAlert.show(
      context: context,
      title: "เกิดข้อผิดพลาด",
      text: "ไม่สามารถลบข้อมูลวิชาได้",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  void showUpDeleteSubjectSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        barrierDismissible: false,
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const ListSubjectScreen()));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const NavbarAdmin(),
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                              return const AddSubjectScreen();
                                            }));
                                          });
                                        },
                                        child: Container(
                                            height: 35,
                                            width: 110,
                                            decoration: BoxDecoration(
                                              color: maincolor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Center(
                                              child: Text("เพิ่มวิชา",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                  dataRowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black),
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: SizedBox(
                                        width:
                                            100, // กำหนดความกว้างของ DataColumn
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
                                        width:
                                            200, // กำหนดความกว้างของ DataColumn
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'รหัสวิชา',
                                            style: CustomTextStyle.TextHeadBar,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width:
                                            400, // กำหนดความกว้างของ DataColumn
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ชื่อวิชา',
                                            style: CustomTextStyle.TextHeadBar,
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
                                            style: CustomTextStyle.TextHeadBar,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Add more DataColumn as needed
                                  ],
                                  rows: data.asMap().entries.map((entry) {
                                    int index =
                                        entry.key + 1; // นับลำดับเริ่มจาก 1
                                    Map<String, dynamic> row = entry.value;
                                    isSubjectIdInDataForCheck(row['id']);
                                    bool isSubjectEnabled = isSubjectInUse;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Container(
                                          width: 100,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(index.toString(),
                                                style: CustomTextStyle
                                                    .TextGeneral),
                                          ),
                                        )),
                                        DataCell(
                                          Container(
                                            width: 200,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                row['subjectId'],
                                                style:
                                                    CustomTextStyle.TextGeneral,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 400,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                row['subjectName'],
                                                style:
                                                    CustomTextStyle.TextGeneral,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign
                                                    .center, // จัดให้อยู่ตรงกลาง
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Container(
                                            width: 100,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: PopupMenuButton(
                                                icon: const Icon(
                                                  Icons.settings,
                                                  color: Colors.white,
                                                ),
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      child: Row(
                                                        children: const <
                                                            Widget>[
                                                          Icon(
                                                              Icons
                                                                  .change_circle,
                                                              color:
                                                                  Colors.black),
                                                          SizedBox(width: 10.0),
                                                          Text('แก้ไข'),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        await Future.delayed(
                                                            Duration
                                                                .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(builder:
                                                                    (BuildContext
                                                                        context) {
                                                          return DetailSubjectScreen(
                                                              id: row['id']
                                                                  .toString());
                                                        }));
                                                      }),
                                                  PopupMenuItem(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(Icons.delete,
                                                            color:
                                                                Colors.black),
                                                        SizedBox(width: 10.0),
                                                        Text('ลบ'),
                                                      ],
                                                    ),
                                                    enabled: isSubjectEnabled,
                                                    onTap: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 0),
                                                          () => showSureToDeleteSubjectAlert(
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
