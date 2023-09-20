import 'package:flutter_application_1/model/authority.dart';
import 'package:flutter_application_1/model/login.dart';

class Authoritylogins {
  Authority? authorityid;
  Login? loginid;

  Authoritylogins({
    this.authorityid,
    this.loginid,
  });

  Map<String, dynamic> formAuthorityLoginToJson() {
    return <String, dynamic>{
      'authorityid': authorityid?.id,
      'loginid': loginid?.id,
    };
  }

  factory Authoritylogins.formJsonToAuthorityLogin(Map<String, dynamic> json) {
    return Authoritylogins(
      authorityid: json["authorityid"],
      loginid: json["loginid"],

      /* authorityid: Authority.formAuthorityToJson(json["authorityid"]),
      loginid: Login.formLoginToJson( json["loginid"]),*/
    );
  }
}
