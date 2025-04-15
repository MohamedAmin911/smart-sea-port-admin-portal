import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BlockchainController extends GetxController {
  var isLoading = false.obs;
  var postSuccess = false.obs;
  var errorMessage = ''.obs;

  Future<void> postContainerId(String containerId) async {
    final url =
        Uri.parse('https://5f1f-197-54-66-87.ngrok-free.app/containers');
    final headers = {
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'skip-browser-warning',
    };

    final body = jsonEncode({'containerId': containerId}); // ✅ proper JSON body

    isLoading.value = true;
    postSuccess.value = false;
    errorMessage.value = '';

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        postSuccess.value = true;
      } else {
        errorMessage.value = 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
