import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/validation.dart';
import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  // void _submitOTP() {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //
  //     // Make API request for OTP verification
  //     APIService.verifyOTP(_otpController.text).then((response) {
  //       if (response.statusCode == 200) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const HomeScreen()),
  //         );
  //       } else {
  //         // Handle OTP verification error case
  //         // Show an error message or perform any required actions
  //       }
  //     }).catchError((error) {
  //       // Handle API request error
  //       // Show an error message or perform any required actions
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _otpController,
                validator: (value) {
                  return Validation.validateOTP(value);
                },
                onSaved: (value) {
                  // Save OTP value if needed
                },
              ),
              ElevatedButton(
                onPressed: null,
                // onPressed: _submitOTP,
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
