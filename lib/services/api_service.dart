import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<http.Response> loginUser(String email, String password) async {
    const url = 'http://65.0.56.125:8000/api/user/login/';
    final body = {'email': email, 'password': password};
    if (kDebugMode) {
      print('Login Request Body: $body');
    }

    try {
      http.Response response = await http.post(Uri.parse(url), body: body);
      if (kDebugMode) {
        print('Login Response: ${response.statusCode}');
        print('Login Response Body: ${response.body}');
      }

      // Store the access token in local storage
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final accessToken = jsonResponse['token']['access'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Login Error: $error');
      }
      rethrow;
    }
  }

  static Future<String?> getTruckNumber(String imagePath) async {
    try {
      var headers = {'Accept': 'application/json'};
      var request = http.MultipartRequest('POST', Uri.parse('http://65.0.56.125:8000/api/text_rekognition/'));
      request.files.add(await http.MultipartFile.fromPath('picture', imagePath));
      request.headers.addAll(headers);

      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        String responseBody = response.body;
        if (kDebugMode) {
          print(responseBody); // {"text":"RJ.09GA.0165"}

          Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
          String truckNumber = jsonResponse['text'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('truckNumber', truckNumber);
          return truckNumber;
        }
      }
    } catch (e) {
      debugPrint('Error Message: ${e.toString()}');
    }
    return null;
  }


  static Future<http.Response> getTrucksInside() async {
    const url = 'http://65.0.56.125:8000/api/show_truck';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        return http.Response(responseBody, response.statusCode);
      } else {
        return http.Response('', response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }

}



