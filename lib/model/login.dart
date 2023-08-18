class Login {

  String? username;
  String? password;

  Login({
    this.username,
    this.password,
  });

  Map<String, dynamic> formLoginToJson(){
    return <String, dynamic>{
      'username' : username,
      'password' : password,
    };
  }

  factory Login.formLoginToJson(Map<String, dynamic> json) {
    return Login(
      username: json["username"],
      password: json["password"],
    );
  }

}
