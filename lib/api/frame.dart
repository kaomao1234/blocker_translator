import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List?> frame() async {
  final url = Uri.parse("http://127.0.0.1:8000/frame");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else{
     throw Exception(
        "Failed to fetch frame : ${response.statusCode}");
  }
}
