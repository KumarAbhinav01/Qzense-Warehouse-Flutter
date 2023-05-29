import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import '../widget/loadingIndicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key, required this.title, required this.accessToken})
      : super(key: key);

  final String title;
  final String accessToken;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  XFile? _image;
  final picker = ImagePicker();
  static String truckNumber = '';
  late bool _showTruckNumber = false;
  final LocalStorage storage = LocalStorage('truckNumber');
  bool showLoading = false;

  Future pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      } else {
        // print('No image selected.');
      }
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future getTruckNumber() async {
    try{
      setState(() {
        showLoading = true;
      });
      // Validate required fields
      if (_image == null) {
        // Error dialog
        return;
      }

      var headers = {
        'Accept': 'application/json'
      };
      var request = http.MultipartRequest('POST', Uri.parse('http://65.0.56.125:8000/api/text_rekognition/'));
      request.files.add(await http.MultipartFile.fromPath('picture', _image!.path));
      request.headers.addAll(headers);
      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        String responseBody = response.body;
        if (kDebugMode) {
          print(responseBody); // {"text":"RJ.09GA.0165"}

          setState(() {
            Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
            truckNumber = jsonResponse['text'];
            storage.setItem('truckNumber', truckNumber);
            _showTruckNumber = true;
          });
        }
      }
    } catch (e){
      debugPrint('error Message is ${e.toString()}');
    } finally{
      setState(() {
        showLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF27485D),
        title: const Center(child: Text('Qzense Labs')),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/logo.jpg', width: 10.0, height: 70.0,),
                  const SizedBox(height: 40),
                  const SizedBox(height: 15.0),
                  const Text(
                    'Welcome to qZense Labs',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'To continue, please proceed by clicking a picture of the Truck.',
                    style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  if (_image != null) ...[
                    // const SizedBox(height: 10.0),
                    Image.file(
                      File(_image!.path),
                      width: 150.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20,),
                  ],


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: MaterialButton(
                          height: 50,
                          color: const Color(0xFF27485D),
                          onPressed: pickImageFromCamera,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Take Photo',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: MaterialButton(
                          height: 50,
                          color: const Color(0xFF27485D),
                          onPressed: pickImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo_library, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Upload Image',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10.0),
                  if (_image != null) ...[
                    // const SizedBox(height: 10.0),
                    MaterialButton(
                      onPressed: getTruckNumber,
                      color: const Color(0xFF27485D),
                      child: const Text('Get Truck Number',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],

                  if (showLoading) ...[
                    // Show the loading indicator
                    LodingInd(),
                  ] else
                    if (_showTruckNumber) ...[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.grey[200],
                        child: Row(
                          children: [
                            const Text(
                              "Truck Number:",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              truckNumber,
                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        color: const Color(0xFF27485D),
                        child: const Text('Next',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
