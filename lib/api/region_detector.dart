import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<String?> regionDetector() async {
  final url = Uri.parse("http://127.0.0.1:8000/region_detector");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        "Failed to fetch regionDetector : ${response.statusCode}");
  }
}
