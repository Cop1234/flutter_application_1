import 'dart:convert';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/ws_config.dart';
import 'package:http/http.dart' as http;

class RoomController {

  Future listAllRooms () async {

    var url = Uri.parse(baseURL + '/room/list');

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Room> list = jsonResponse.map((e) => Room.formRoomToJson(e)).toList();
    return list; 

  }

  Future deleteRoom (String id) async{

    var url = Uri.parse(baseURL + "/room/delete/" + id);

    http.Response response = await http.delete(url);

    return response;

  }

}