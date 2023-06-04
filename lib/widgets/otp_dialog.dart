import 'package:flutter/material.dart';
import '../screens/gate_reporting.dart';
import '../services/api_service.dart';
import '../utils/validation.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({Key? key}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  void _submitOTP() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Make API request for OTP verification
      APIService.verifyOTP(_otpController.text).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // Handle OTP verification error case
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('OTP Verification Error'),
                content: const Text('Failed to verify OTP. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }).catchError((error) {
        // Handle API request error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('API Request Error'),
              content: const Text('Failed to send OTP verification request.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter OTP'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _otpController,
          validator: (value) {
            return Validation.validateOTP(value);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitOTP,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
