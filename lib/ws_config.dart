//ip เครื่องตัวเอง

//ip หอ
const String ipv4 = '192.168.88.71';
//const String ipv4 = '192.168.20.130';
//

//ip ม.
//const String ipv4 = '10.11.24.187';

const Map<String, String> headers = {
  "Access-Control-Allow-Origin": "*",
  'Content-Type': 'application/json',
  'Accept-Language': 'th',
  'Accept': '*/*'
};

const String baseURL = "http://" + ipv4 + ":8080";
