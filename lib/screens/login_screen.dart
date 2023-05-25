import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qzense_warehouse/screens/registration_screen.dart';
import '../services/api_service.dart';
import '../utils/validation.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String accessToken = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Make API request for login
      APIService.loginUser(_emailController.text, _passwordController.text)
          .then((response) {
        if (response.statusCode == 200) {
          // Login successful, handle the response
          final jsonResponse = json.decode(response.body);
          accessToken = jsonResponse['token']['access'];

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomeScreen(
                  title: 'Fish Data Collection',
                  accessToken: accessToken,
            )),
          );
        } else {
          // Handle error case
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Login Failed'),
                content: const Text('Invalid email or password.'),
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
        // Handle error case
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Error'),
              content: const Text('An error occurred while logging in.'),
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

  void _navigateToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  return Validation.validateEmail(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  return Validation.validatePassword(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _navigateToRegisterScreen,
                child: const Text(
                  'Dont have an Account? Register Now',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
