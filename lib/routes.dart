import 'package:flutter/material.dart';
import 'package:qzense_warehouse/screens/loading/loading_details.dart';
import 'package:qzense_warehouse/screens/loading/loading_last.dart';
import 'package:qzense_warehouse/screens/truck_inside.dart';
import 'package:qzense_warehouse/screens/selection.dart';
import 'package:qzense_warehouse/screens/gate_reporting.dart';
import 'package:qzense_warehouse/screens/auth/login_screen.dart';
import 'package:qzense_warehouse/screens/auth/registration_screen.dart';
import 'package:qzense_warehouse/screens/unloading/unload_details.dart';
import 'package:qzense_warehouse/screens/unloading/unload_summary.dart';
import 'package:qzense_warehouse/screens/unloading/unloading_last_page.dart';
import 'package:qzense_warehouse/screens/welcome_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const LoginScreen(),
  '/home': (BuildContext context) => const HomeScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/register': (BuildContext context) => const RegistrationScreen(),
  '/welcome': (BuildContext context)=> const WelcomeScreen(),
  '/screen2': (BuildContext context) => const TruckInside(),
  '/selection': (BuildContext context) => const SelectionPage(),
  '/loading-details': (BuildContext context) => const LoadingDetails(),
  '/loading-last': (BuildContext context) => const LoadingLastPage(),
  '/unloading-details': (BuildContext context) => const UnloadDetails(),
  '/unloading-summary': (BuildContext context) => const UnloadSummary(),
  '/unloading-last': (BuildContext context) => const UnloadingLastPage(),
};