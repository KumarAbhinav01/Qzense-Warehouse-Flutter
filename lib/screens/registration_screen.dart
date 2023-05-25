import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../utils/validation.dart';
import '../widgets/custom_dialog.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final User _user = User();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Make API request for registration
      APIService.registerUser(_user).then((response) {
        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog();
            },
          );
        } else {
          // Handle error case
        }
      });
    }
  }

  void _navigateToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  return Validation.validateFirstName(value);
                },
                onSaved: (value) {
                  _user.firstName = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextFormField(
                controller: _lastNameController,
                validator: (value) {
                  return Validation.validateLastName(value);
                },
                onSaved: (value) {
                  _user.lastName = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  return Validation.validateEmail(value);
                },
                onSaved: (value) {
                  _user.email = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _phoneController,
                validator: (value) {
                  return Validation.validatePhoneNumber(value);
                },
                onSaved: (value) {
                  _user.phoneNumber = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  return Validation.validatePassword(value);
                },
                onSaved: (value) {
                  _user.password = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                validator: (value) {
                  return Validation.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  );
                },
                onSaved: (value) {
                  _user.confirmPassword = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _navigateToLoginScreen,
                child: const Text(
                  'Already have an Account? Login Now',
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
