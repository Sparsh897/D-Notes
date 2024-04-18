import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:notes_app/models/shared_prefrence.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _issiginupLoading = false;

  bool get signupLoading => _issiginupLoading;

  bool _isresetLoading = false;
  bool get resetLoading => _isresetLoading;

  Future<bool> siginwemail(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5003/api/users/login'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String accessToken = responseData['accessToken'];
        await MySharedPreferences.saveAccessToken(accessToken);
        print('Access Token: $accessToken');

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> signupwemail(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5003/api/users/register'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 201) {
        notifyListeners();
        print(response);
      } else {
        throw Exception('Failed to add the user');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> resetPassword(
    String email,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5003/api/users/sendemail'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        notifyListeners();
        print(response);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void signinIsLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void signupIsLoading() {
    _issiginupLoading = true;
    notifyListeners();
  }

  void stopupLoading() {
    _issiginupLoading = false;
    notifyListeners();
  }

  void forgotpassLoading() {
    _isresetLoading = true;
    notifyListeners();
  }
  void stopforgotpassLoading() {
    _isresetLoading = false;
    notifyListeners();
  }
}
