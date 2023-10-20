//ip เครื่องตัวเอง

//ip หอ
//C
// const String ipv4 = '192.168.88.71';
//P
const String ipv4 = '192.168.199.130';

//ip ม.
// const String ipv4 = '10.200.21.241';
//const String ipv4 = '172.16.2.252';

const Map<String, String> headers = {
  "Access-Control-Allow-Origin": "*",
  'Content-Type': 'application/json',
  'Accept-Language': 'th',
  'Accept': '*/*'
};

const String baseURL = "http://" + ipv4 + ":8080";
