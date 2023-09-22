import 'package:flutter_application_1/model/login.dart';

class User {
  String? birthdate;
  int? id;
  Login? login;
  String? email;
  String? fname;
  String? gender;
  String? lname;
  String? typeuser;
  String? userid;

  // เปลี่ยนประเภทของ loginid เป็น Login

  User({
    this.birthdate,
    this.id,
    this.login,
    this.email,
    this.fname,
    this.gender,
    this.lname,
    this.typeuser,
    this.userid,
  });

  Map<String, dynamic> formUserToJson() {
    return <String, dynamic>{
      'birthdate': birthdate,
      'id': id,
      'login': login?.formLoginToJson(), // แปลง Login ให้เป็น JSON
      'email': email,
      'fname': fname,
      'gender': gender,
      'lname': lname,
      'typeuser': typeuser,
      'userid': userid,
    };
  }

  factory User.formJsonToUser(Map<String, dynamic> json) {
    return User(
      birthdate: json["birthdate"],
      id: json["id"],
      login: Login.formJsonTOLogin(json["login"]), // แปลง JSON เป็น Login
      email: json["email"],
      fname: json["fname"],
      gender: json["gender"],
      lname: json["lname"],
      typeuser: json["typeuser"],
      userid: json["userid"],
    );
  }
}
