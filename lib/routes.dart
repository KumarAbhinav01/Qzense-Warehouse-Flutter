import 'package:flutter/material.dart';
import 'package:qzense_warehouse/screens/loadinglast.dart';
import 'package:qzense_warehouse/screens/screen_2.dart';
import 'package:qzense_warehouse/screens/selection.dart';
import 'package:qzense_warehouse/screens/welcome_screen.dart';
import 'package:qzense_warehouse/screens/home_screen.dart';
import 'package:qzense_warehouse/screens/login_screen.dart';
import 'package:qzense_warehouse/screens/otp_screen.dart';
import 'package:qzense_warehouse/screens/registration_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const LoginScreen(),
  // '/welcome' : (BuildContext context) => WelcomeScreen(),
  '/otp': (BuildContext context) => const OTPScreen(),
  '/home': (BuildContext context) => const HomeScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/screen2': (BuildContext context) => const TrucksInside(),
  '/selection': (BuildContext context) => const SelectionPage(),
  '/loadinglast': (BuildContext context) => const LoadingLastPage(),
};