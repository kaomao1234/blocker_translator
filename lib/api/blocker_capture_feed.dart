import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List?> blockerCaptureFeed() async {
  final url = Uri.parse("http://127.0.0.1:8000/blocker_capture_feed");
  final response = await http.post(url);
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else{
     throw Exception(
        "Failed to fetch blockerCaptureFeed : ${response.statusCode}");
  }
}
