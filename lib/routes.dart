import 'package:flutter/material.dart';
import 'package:qzense_warehouse/screens/welcome_screen.dart';
import 'package:qzense_warehouse/screens/home_screen.dart';
import 'package:qzense_warehouse/screens/login_screen.dart';
import 'package:qzense_warehouse/screens/otp_screen.dart';
import 'package:qzense_warehouse/screens/registration_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const RegistrationScreen(),
  // '/welcome' : (BuildContext context) => WelcomeScreen(),
  '/otp': (BuildContext context) => const OTPScreen(),
  '/home': (BuildContext context) => const HomeScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
};
