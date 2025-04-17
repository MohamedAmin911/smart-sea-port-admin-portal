import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model class to represent the container data
class ContainerData {
  final String id;
  final String status;
  final DateTime timestamp;
  final List<String> history;

  ContainerData({
    required this.id,
    required this.status,
    required this.timestamp,
    required this.history,
  });

  // Factory constructor to create an instance from JSON
  factory ContainerData.fromJson(Map<String, dynamic> json) {
    return ContainerData(
      id: json['ID'],
      status: json['Status'],
      timestamp: DateTime.parse(json['Timestamp']),
      history: List<String>.from(json['History']),
    );
  }
}

// Function to fetch container data from the API
Future<ContainerData?> fetchContainerData(String containerId) async {
  final url = Uri.parse(
      'https://24d9f93b3f66a3a109c184c24b196d24.serveo.net/containers/$containerId');
  final headers = {
    'ngrok-skip-browser-warning': 'skip-browser-warning',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.get(url, headers: headers);

    // Check if the response has a successful status code
    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        final data = jsonDecode(response.body);
        return ContainerData.fromJson(data);
      } else {
        print('Error: Expected JSON but received: $contentType');
        print('Response body: ${response.body}');
      }
    } else {
      print('Error: Status code ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Exception occurred: $e');
  }

  return null;
}

// UI to test fetching container data
class TestContainerDataUI extends StatefulWidget {
  @override
  _TestContainerDataUIState createState() => _TestContainerDataUIState();
}

class _TestContainerDataUIState extends State<TestContainerDataUI> {
  final TextEditingController _controller = TextEditingController();
  ContainerData? _containerData;
  bool _isLoading = false;
  String? _errorMessage;

  void _fetchData() async {
    final containerId = _controller.text.trim();
    if (containerId.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a container ID";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final data = await fetchContainerData(containerId);

    setState(() {
      _isLoading = false;
      if (data != null) {
        _containerData = data;
      } else {
        _errorMessage = "Failed to fetch container data";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Container Data Test UI")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter Container ID",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchData,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Fetch Data"),
            ),
            SizedBox(height: 16),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (_containerData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.only(top: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Container Details",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("ID: ${_containerData!.id}"),
                          Text("Status: ${_containerData!.status}"),
                          Text("Timestamp: ${_containerData!.timestamp}"),
                          SizedBox(height: 8),
                          Text("History:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ..._containerData!.history
                              .map((event) => Text("- $event"))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TestContainerDataUI(),
  ));
}
