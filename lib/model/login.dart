class Login {
  int? id;
  String? password;
  String? username;

  Login({
    this.id,
    this.password,
    this.username,
  });

  Map<String, dynamic> formLoginToJson() {
    return <String, dynamic>{
      'id': id,
      'password': password,
      'username': username,
    };
  }

  factory Login.formJsonToLogin(Map<String, dynamic> json) {
    return Login(
      id: json["id"],
      password: json["password"],
      username: json["username"],
    );
  }
}
