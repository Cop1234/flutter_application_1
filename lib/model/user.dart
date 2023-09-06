class User {
  int? id;
  String? userid;
  String? typeuser;
  String? email;
  String? fname;
  String? lname;
  String? birthdate;
  String? gender;
  String? username;

  User(
      {this.id,
      this.userid,
      this.typeuser,
      this.email,
      this.fname,
      this.lname,
      this.birthdate,
      this.gender,
      this.username});

  Map<String, dynamic> formUserToJson() {
    return <String, dynamic>{
      'id': id,
      'userid': userid,
      'typeuser': typeuser,
      'email': email,
      'fname': fname,
      'lname': lname,
      'birthdate': birthdate,
      'gender': gender,
      'username': username,
    };
  }

  factory User.formUserToJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      userid: json["userid"],
      typeuser: json["typeuser"],
      email: json["email"],
      fname: json["fname"],
      lname: json["lname"],
      birthdate: json["birthdate"],
      gender: json["gender"],
      username: json["username"],
    );
  }
}
