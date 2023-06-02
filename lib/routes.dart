import 'package:flutter/material.dart';
import 'package:qzense_warehouse/screens/loading_last.dart';
import 'package:qzense_warehouse/screens/truck_inside.dart';
import 'package:qzense_warehouse/screens/selection.dart';
import 'package:qzense_warehouse/screens/gate_reporting.dart';
import 'package:qzense_warehouse/screens/login_screen.dart';
import 'package:qzense_warehouse/screens/otp_screen.dart';
import 'package:qzense_warehouse/screens/registration_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const LoginScreen(),
  '/otp': (BuildContext context) => const OTPScreen(),
  '/home': (BuildContext context) => const HomeScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/register': (BuildContext context) => const RegistrationScreen(),
  '/screen2': (BuildContext context) => const TruckInside(),
  '/selection': (BuildContext context) => const SelectionPage(),
  '/loadinglast': (BuildContext context) => const LoadingLastPage(),
};