import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class APIService {
  static String? sessionId;

  static Future<http.Response> registerUser(User user) {
    const url = 'http://65.0.56.125:8000/api/user/register/';
    final body = user.toJson();
    if (kDebugMode) {
      print('Registration Request Body: $body');
    }
    return http.post(Uri.parse(url), body: body)
        .then((response) {
      if (kDebugMode) {
        print('Registration Response: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Registration Response Body: ${response.body}');
      }
      final session = response.headers['set-cookie'];
      if (session != null) {
        final sessionId = session.split(';').first;
        APIService.sessionId = sessionId;
        if (kDebugMode) {
          print('Session ID: $sessionId');
        }
      }
      return response;
    })
        .catchError((error) {
      if (kDebugMode) {
        print('Registration Error: $error');
      }
      throw error;
    });
  }

  static Future<http.Response> verifyOTP(String otp) {
    const url = 'http://65.0.56.125:8000/api/user/verify_otp/';
    final body = {'otp': otp};
    final headers = {'Cookie': APIService.sessionId!};
    if (kDebugMode) {
      print('OTP Verification Request Body: $body');
    }
    return http.post(Uri.parse(url), body: body, headers: headers)
        .then((response) {
      if (kDebugMode) {
        print('OTP Verification Response: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('OTP Verification Response Body: ${response.body}');
      }
      return response;
    })
        .catchError((error) {
      if (kDebugMode) {
        print('OTP Verification Error: $error');
      }
      throw error;
    });
  }

  static Future<http.Response> loginUser(String email, String password) {
    const url = 'http://65.0.56.125:8000/api/user/login/';
    final body = {'email': email, 'password': password};
    if (kDebugMode) {
      print('Login Request Body: $body');
    }
    return http.post(Uri.parse(url), body: body).then((response) {
      if (kDebugMode) {
        print('Login Response: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Login Response Body: ${response.body}');
      }
      return response;
    }).catchError((error) {
      if (kDebugMode) {
        print('Login Error: $error');
      }
      throw error;
    });
  }
}



