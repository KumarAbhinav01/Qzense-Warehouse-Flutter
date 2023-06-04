import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = LocalStorage('truckNumber');

class LoadingDetails extends StatelessWidget {
  const LoadingDetails({super.key});

  Future<Map<String, dynamic>> getTruckNumber(String filePath) async {
    var url = Uri.parse('http://43.205.91.117:8000/api/trucks_inside/');
    var request = http.MultipartRequest('GET', url);
    var response = await request.send();
    var responseJson = await response.stream.bytesToString();
    debugPrint(responseJson);
    return json.decode(responseJson);
  }

  void handleNextButtonPressed(BuildContext context) {
    // Handle the "Next" button click
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                    'Truck Number ',
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
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: const [
                        Text(
                          'SKU Code :',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                            width:
                            8.0), // Add some spacing between the text and text form field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child:  Row(
                      children: const [
                        Text(
                          'Picklist Batch :',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                            width:
                            8.0), // Add some spacing between the text and text form field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child:  Row(
                      children: const [
                        Text(
                          'Picklist MFG:',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                            width:
                            8.0), // Add some spacing between the text and text form field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child:  Row(
                      children: const [
                        Text(
                          'Picklist Qty :',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                            width:
                            8.0), // Add some spacing between the text and text form field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child:  Row(
                      children: const [
                        Text(
                          'SKU Description :',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                            width:
                            8.0), // Add some spacing between the text and text form field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child:  Row(
                      children:const [
                        Text(
                          'Actual Batch:',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                            width:
                            8.0), // Add some spacing between the text and text form field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child:  Row(
                      children: const [
                        Text(
                          'Actual MFG Date :',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                            width:
                            8.0), // Add some spacing between the text and text form field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child:  Row(
                      children: const [
                        Text(
                          'Quantity:',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                            width:
                            8.0), // Add some spacing between the text and text form field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter text',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/loading-last');
                    },
                    color: const Color(0xFF27485D),
                    child:
                    const Text('Next', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}