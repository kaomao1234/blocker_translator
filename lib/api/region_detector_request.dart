import 'dart:convert';
import 'package:blocker_translator/model/index.dart';
import 'package:http/http.dart' as http;

void regionDetectorRequest(BlockerModel blockerModel) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json', // You can set other headers as needed
  };
  final url = Uri.parse("http://127.0.0.1:8000/region_dectector");
  final response = await http.post(url,
      headers: headers, body: jsonEncode(blockerModel.toJson()));
  if (response.statusCode != 200) {
    throw Exception(
        "Failed to fetch regionDetectorRequest : ${response.statusCode}");
  }
}
