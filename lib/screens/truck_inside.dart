import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../services/api_service.dart';

class TruckInside extends StatefulWidget {
  const TruckInside({Key? key}) : super(key: key);

  @override
  State<TruckInside> createState() => _TruckInsideState();
}

class _TruckInsideState extends State<TruckInside> {

  final LocalStorage storage = LocalStorage('truckNumber');
  String _totalTruckInside = '';
  List<dynamic> _trucksList = [];

  Future<void> getTruckNumbers() async {
    debugPrint("Get Truck Numbers Function");


    APIService.getTrucksInside().then((response) {
      if (response.statusCode == 200) {
        debugPrint('Total Trucks Inside: ${response.body}');
        // Parse the JSON response as a list
        List<dynamic> responseData = jsonDecode(response.body);
        // Update the _trucksList variable
        setState(() {
          _trucksList = responseData;
          _totalTruckInside = _trucksList.length.toString();
        });
      } else {
        debugPrint('Error: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed to Fetch'),
              content: const Text('Please Login Again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      debugPrint('API Error: $error');
    });
  }


  @override
  void initState() {
    super.initState();
    getTruckNumbers();
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
                  // Existing content
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/logo.jpg',
                    height: 70.0,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Trucks Inside',
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
                          _totalTruckInside,
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
                    'Select your Invoice',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/selection');
                    },
                    color: const Color(0xFF27485D),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Truck List',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Truck list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _trucksList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var truck = _trucksList[index];
                      return Card(
                        margin: const EdgeInsets.all(10.0),
                        child: ListTile(
                          // leading: SizedBox(
                          //   width: 50,
                          //   height: 50,
                          //   child: Image.network(
                          //     truck['image_url'],
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          title: Text(truck['truck_id']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Entry Time: ${truck['entry_time']}'),
                              Text('Entry Date: ${truck['entry_date']}'),
                            ],
                          ),
                        ),
                      );
                    },
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