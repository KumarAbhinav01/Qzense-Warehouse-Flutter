import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  static String? sessionId;
  static String? selectedTruckNumber;

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

  static Future<http.Response> resendOTP() async {
    const url = 'http://65.0.56.125:8000/api/user/resend_otp/';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (kDebugMode) {
        print('Resend OTP Response: ${response.statusCode}');
        print('Resend OTP Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Resend OTP Error: $error');
      }
      rethrow;
    }
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

  static Future<http.Response> changePassword(String currentPassword, String newPassword) async {
    const url = 'http://65.0.56.125:8000/api/user/changepassword/';
    var body = {
      'password': currentPassword,
      'Password2': newPassword,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      http.Response response = await http.post(Uri.parse(url), body: body, headers: headers);

      if (kDebugMode) {
        print('Change Password Response: ${response.statusCode}');
        print('Change Password Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Change Password Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> sendResetPasswordEmail(String email) async {
    const url = 'http://65.0.56.125:8000/api/user/send-reset-password-email/';
    var body = {
      'email': email,
    };

    try {
      http.Response response = await http.post(Uri.parse(url), body: body);

      if (kDebugMode) {
        print('Send Reset Password Email Response: ${response.statusCode}');
        print('Send Reset Password Email Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Send Reset Password Email Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> resetPassword(String userId, String token, String password) async {
    final url = 'http://65.0.56.125:8000/api/user/reset-password/$userId/$token/';
    var body = {
      'password': password,
      'password2': password,
    };

    try {
      http.Response response = await http.post(Uri.parse(url), body: body);

      if (kDebugMode) {
        print('Reset Password Response: ${response.statusCode}');
        print('Reset Password Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Reset Password Error: $error');
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
          selectedTruckNumber = truckNumber;
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

  static Future<http.Response> getEntryDateTime(String truckId) async {
    final url = 'http://65.0.56.125:8000/api/entry_datetime/$truckId';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (kDebugMode) {
        print('Entry Date and Time Response: ${response.statusCode}');
        print('Entry Date and Time Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Entry Date and Time Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> getLatestTruckEntered() async {
    const url = 'http://65.0.56.125:8000/api/latest_truck_entered';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (kDebugMode) {
        print('Latest Truck Entered Response: ${response.statusCode}');
        print('Latest Truck Entered Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Latest Truck Entered Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> getExitTime(String truckId) async {
    final url = 'http://65.0.56.125:8000/api/exit_time/$truckId';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (kDebugMode) {
        print('Exit Time Response: ${response.statusCode}');
        print('Exit Time Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Exit Time Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> insertSKUDetails(Map<String, dynamic> skuDetails) async {
    const url = 'http://65.0.56.125:8000/api/user/insert_sku_details/';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(skuDetails));

      if (kDebugMode) {
        print('Insert SKU Details Response: ${response.statusCode}');
        print('Insert SKU Details Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Insert SKU Details Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> getSKUDetails(String truckId) async {
    final url = 'http://65.0.56.125:8000/api/user/sku_details/$truckId';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (kDebugMode) {
        print('Get SKU Details Response: ${response.statusCode}');
        print('Get SKU Details Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Get SKU Details Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> updateLoadingStatus(String truckId, String status) async {
    final url = 'http://65.0.56.125:8000/api/update_status/$truckId';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var body = {'status': status};

    try {
      http.Response response = await http.patch(Uri.parse(url), headers: headers, body: body);

      if (kDebugMode) {
        print('Update Loading Status Response: ${response.statusCode}');
        print('Update Loading Status Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Update Loading Status Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> phoneValidation(String phoneNumber) async {
    const url = 'http://65.0.56.125:8000/api/user/phone_validation/';
    var body = {'phone': phoneNumber};

    try {
      http.Response response = await http.post(Uri.parse(url), body: body);

      if (kDebugMode) {
        print('Phone Validation Response: ${response.statusCode}');
        print('Phone Validation Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Phone Validation Error: $error');
      }
      rethrow;
    }
  }

  static Future<http.Response> resendEmail(String email) async {
    const url = 'http://65.0.56.125:8000/api/user/resend_email/';
    var body = {'email': email};

    try {
      http.Response response = await http.post(Uri.parse(url), body: body);

      if (kDebugMode) {
        print('Resend Email Response: ${response.statusCode}');
        print('Resend Email Response Body: ${response.body}');
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Resend Email Error: $error');
      }
      rethrow;
    }
  }

}



