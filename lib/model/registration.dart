import 'package:flutter_application_1/model/login.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/user.dart';

class Registration {
  int? id;
  Section? section;
  User? user;

  Registration({
    this.id,
    this.section,
    this.user,
  });

  Map<String, dynamic> formRegistrationToJson() {
    return <String, dynamic>{
      'id': id,
      'section': section?.formSectionToJson(),
      'user': user?.formUserToJson(),
    };
  }

  factory Registration.formJsonToRegistration(Map<String, dynamic> json) {
    return Registration(
      id: json["id"],
      section: Section.formJsonToSection(json["section"]),
      user: User.formJsonToUser(json["user"]),
    );
  }
}
