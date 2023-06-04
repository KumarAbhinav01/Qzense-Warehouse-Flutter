import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = LocalStorage('truckNumber');

class UnloadSummary extends StatelessWidget {
  const UnloadSummary({super.key});

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
        body: Center(
          child: SingleChildScrollView(
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Invoice Product Summary ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(10.0),
                    color: const Color(0xFF27485D),
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.document_scanner,
                          color: Colors.white,
                          size: 124.0,
                          semanticLabel: 'Text to announce in accessibility modes',
                        ),
                      ],
                    ),
                  ),
                  //Image.asset(
                  //'assets/invoice.png',
                  //height: 200,
                  //),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/unloading-details');
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