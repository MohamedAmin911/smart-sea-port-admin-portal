import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final url =
      Uri.parse('https://2ac9-197-54-66-87.ngrok-free.app/containers/ABCD');
  final headers = {
    'ngrok-skip-browser-warning': 'skip-browser-warning',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
