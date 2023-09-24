import 'dart:convert';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/ws_config.dart';
import 'package:http/http.dart' as http;

class RoomController {
  Future addRoom(String roomName, String building, String latitude,
      String longitude) async {
    Map data = {
      "roomName": roomName,
      "building": building,
      "latitude": latitude,
      "longitude": longitude
    };

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/room/add");

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }

  Future listAllRooms() async {
    var url = Uri.parse(baseURL + '/room/list');

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Room> list = jsonResponse.map((e) => Room.formJsonToRoom(e)).toList();
    return list;
  }

  Future get_Room(String id) async {
    var url = Uri.parse(baseURL + '/room/getbyid/' + id);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    Room room = Room.formJsonToRoom(jsonResponse);
    return room;
  }

  Future update_Room(Room room) async {
    Map<String, dynamic> data = room.formRoomToJson();

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/room/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }

  Future deleteRoom(String id) async {
    var url = Uri.parse(baseURL + "/room/delete/" + id);

    http.Response response = await http.delete(url);

    return response;
  }
}
