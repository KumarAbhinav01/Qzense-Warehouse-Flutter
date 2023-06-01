import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = LocalStorage('truckNumber');

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  Future<Map<String, dynamic>> uploadFile(String filePath) async {
    var url = Uri.parse('http://43.205.91.117:8000/api/trucks_inside/');
    var request = http.MultipartRequest('GET', url);

    // var file = await http.MultipartFile.fromPath('picture', filePath);
    // request.files.add(file);

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
            Image.asset(
              'assets/logo.jpg',
              height: 70.0,
            ),
            const SizedBox(height: 40),
            const Text(
              'Choose Action',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(10.0),
              color: const Color(0xFF27485D),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Truck Number:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    storage.getItem('truckNumber'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/screen2');
              },
              color: const Color(0xFF27485D),
              child: const Text('Unloading',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 40),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loadinglast');
              },
              color: const Color(0xFF27485D),
              child:
              const Text('Loading', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}