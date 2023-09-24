class Room {
  int? id;
  String? roomName;
  String? building;
  double? latitude;
  double? longitude;

  Room({
    this.id,
    this.roomName,
    this.building,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> formRoomToJson() {
    return <String, dynamic>{
      'id': id,
      'roomName': roomName,
      'building': building,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Room.formJsonToRoom(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      roomName: json["roomName"],
      building: json["building"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}
