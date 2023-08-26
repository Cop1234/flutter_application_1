class Login {

  String? id;
  String? username;
  String? password;

  Login({
    this.id,
    this.username,
    this.password,
  });

  Map<String, dynamic> formLoginToJson(){
    return <String, dynamic>{
      'id' : id,
      'username' : username,
      'password' : password,
    };
  }

  factory Login.formLoginToJson(Map<String, dynamic> json) {
    return Login(
      id: json["id"],
      username: json["username"],
      password: json["password"],
    );
  }

}
