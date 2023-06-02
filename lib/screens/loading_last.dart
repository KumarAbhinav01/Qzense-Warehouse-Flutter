import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class LoadingLastPage extends StatefulWidget {
  const LoadingLastPage({Key? key}) : super(key: key);

  @override
  State<LoadingLastPage> createState() => _LoadingLastPageState();
}

class _LoadingLastPageState extends State<LoadingLastPage> {

  final LocalStorage storage = LocalStorage('truckNumber');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                'Loading Complete\n'
                    'Thank you for sharing picture with consignment',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                '\n Exit Details ',
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
                      " Truck Number:",
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
            ],
          ),
        ),
      ),
    );
  }
}