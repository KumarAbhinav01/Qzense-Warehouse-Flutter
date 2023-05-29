import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> uploadFile(String filePath) async {
    var url = Uri.parse('http://43.205.91.117:8000/api/text_rekognition/');
    var request = http.MultipartRequest('POST', url);

    var file = await http.MultipartFile.fromPath('picture', filePath);
    request.files.add(file);

    var response = await request.send();
    var responseJson = await response.stream.bytesToString();

    return json.decode(responseJson);
  }

  void handleUploadButtonPressed(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String? filePath = result.files.single.path;

      if (filePath != null) {
        var data = await uploadFile(filePath);
        // Handle the response data as needed
        if (kDebugMode) {
          print('Data : $data');
        }
      }
    }
  }

  void handleNextButtonPressed(BuildContext context) {
    // Handle the "Next" button click
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://mybucketwarehouse.s3.ap-south-1.amazonaws.com/logo.jpg',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to qZense Labs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'To continue, please proceed by clicking a picture of the Truck.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  handleUploadButtonPressed(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF16505C),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Upload'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  handleNextButtonPressed(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF16505C),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      );
  }
}
