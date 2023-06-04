import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:localstorage/localstorage.dart';

import '../services/api_service.dart';
import '../widget/loading_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key})
      : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  XFile? _image;
  final picker = ImagePicker();
  static String theTruckNumber = '';
  late bool _showTruckNumber = false;
  final LocalStorage storage = LocalStorage('truckNumber');
  bool showLoading = false;

  Future pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
        retrieveTruckNumber();
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
        retrieveTruckNumber();

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

  void retrieveTruckNumber() async {
    setState(() {
      showLoading = true;
    });

    try {
      String? truckNumber = await APIService.getTruckNumber(_image!.path);
      if (truckNumber != null) {
        setState(() {
          // Update the UI with the retrieved truck number
          _showTruckNumber = true;
          theTruckNumber = truckNumber;
          storage.setItem('truckNumber', truckNumber);
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      // Handle error
    } finally {
      setState(() {
        showLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
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
                          child: GestureDetector(
                            onTap: pickImageFromCamera,
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFF16505C),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.camera_alt, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Take Photo',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFF16505C),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.photo_library, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Upload Image',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),

                          // MaterialButton(
                          //   height: 50,
                          //   color: const Color(0xFF27485D),
                          //   onPressed: pickImage,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: const [
                          //       Icon(Icons.photo_library, color: Colors.white),
                          //       SizedBox(width: 8),
                          //       Text('Upload Image',
                          //           style: TextStyle(color: Colors.white)),
                          //     ],
                          //   ),
                          // ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0),
                    if (_image != null) ...[
                      const SizedBox(height: 25.0),
                    ],

                    if (showLoading) ...[
                      // Show the loading indicator
                      const LodingInd(),
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
                                theTruckNumber,
                                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 120.0),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            color: const Color(0xFF16505C),
                            child: const Text('Next',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
