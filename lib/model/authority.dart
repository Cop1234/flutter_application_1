class Authority {
  String? id;
  String? role;

  Authority({
    this.id,
    this.role,
  });

  Map<String, dynamic> formAuthorityToJson(json) {
    return <String, dynamic>{
      'id': id,
      'username': role,
    };
  }

  factory Authority.formJsonToAuthority(Map<String, dynamic> json) {
    return Authority(
      id: json["id"],
      role: json["role"],
    );
  }
}
