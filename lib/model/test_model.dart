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
      'https://1d51-197-54-19-157.ngrok-free.app/containers/$containerId');
  final headers = {
    'ngrok-skip-browser-warning': 'skip-browser-warning',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.get(url, headers: headers);

    // Check if the response has a successful status code
    if (response.statusCode == 200) {
      // Check if the response content type is JSON
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        // Parse the JSON data
        final data = jsonDecode(response.body);
        return ContainerData.fromJson(data);
      } else {
        // Log an error if the content type is not JSON
        print(
            'Error: Expected JSON response but received content type: $contentType');
        print('Response body: ${response.body}');
      }
    } else {
      // Log an error if the status code indicates a failure
      print(
          'Error: Received status code ${response.statusCode} from the server.');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Log any exceptions that occur during the request
    print('Exception occurred: $e');
  }

  return null;
}

// Sample widget to display container data
class ContainerDataWidget extends StatefulWidget {
  final String containerId;

  ContainerDataWidget({required this.containerId});

  @override
  _ContainerDataWidgetState createState() => _ContainerDataWidgetState();
}

class _ContainerDataWidgetState extends State<ContainerDataWidget> {
  late Future<ContainerData?> futureContainerData;

  @override
  void initState() {
    super.initState();
    futureContainerData = fetchContainerData(widget.containerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Container Data'),
      ),
      body: Center(
        child: FutureBuilder<ContainerData?>(
          future: futureContainerData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              final containerData = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${containerData.id}'),
                    Text('Status: ${containerData.status}'),
                    Text('Timestamp: ${containerData.timestamp}'),
                    Text('History:'),
                    ...containerData.history
                        .map((event) => Text('- $event'))
                        .toList(),
                  ],
                ),
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContainerDataWidget(containerId: 'ABCD'),
  ));
}
