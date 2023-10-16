import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String?> textFromImage() async {
  final url = Uri.parse("http://127.0.0.1:8000/text_from_image");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to fetch text_from_image : ${response.statusCode}");
  }
}
