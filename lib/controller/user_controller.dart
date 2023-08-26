import 'dart:convert';
import 'package:flutter_application_1/ws_config.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:http/http.dart' as http;

class UserController {

  Future get_User (String username) async{

    var url = Uri.parse(baseURL + '/user/getbyusername/' + username);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    User user = User.formUserToJson(jsonResponse);
    return user; 
  }
  
}