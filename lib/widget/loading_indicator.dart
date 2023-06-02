import 'package:flutter/material.dart';

class LodingInd extends StatefulWidget {

  const LodingInd({super.key});

  @override
  State<LodingInd> createState() => _LodingIndState();
}

class _LodingIndState extends State<LodingInd> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        decoration: const BoxDecoration(),
        child: Dialog(
          elevation: 2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/truck.gif"),
                const Text(
                  'Loading',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
