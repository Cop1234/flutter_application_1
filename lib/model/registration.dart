import 'package:flutter_application_1/model/login.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/user.dart';

class registration {
  int? id;
  String? regisStatus;
  Section? section;
  User? userid;

  // เปลี่ยนประเภทของ loginid เป็น Login

  registration({
    this.id,
    this.regisStatus,
    this.section,
    this.userid,
  });

  Map<String, dynamic> formUserToJson() {
    return <String, dynamic>{
      'id': id,
      'regisStatus': regisStatus,
      'section': section?.formSectionToJson(),
      'userid': userid?.formUserToJson(),
    };
  }

  factory registration.formJsonToUser(Map<String, dynamic> json) {
    return registration(
      id: json["id"],
      regisStatus: json["regisStatus"],
      section: json["section"],
      userid: json["userid"],

      ///section: Section.formJsonTOLogin(json["section"]), // แปลง JSON เป็น Login
    );
  }
}
