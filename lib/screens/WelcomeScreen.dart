import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class WelcomeScreen extends StatelessWidget {
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
          print(data);
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
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 430),
          padding: EdgeInsets.all(34),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(11, 54, 105, 0.2),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://mybucketwarehouse.s3.ap-south-1.amazonaws.com/logo.jpg',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to qZense Labs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'To continue, please proceed by clicking a picture of the Truck.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  handleUploadButtonPressed(context);
                },
                child: Text('Upload'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF16505C),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 32),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  handleNextButtonPressed(context);
                },
                child: Text('Next'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF16505C),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 32),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
