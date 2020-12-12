import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/models/login_response.dart';
import 'package:real_time_chat/models/register_user_response.dart';
import 'package:real_time_chat/models/token_response.dart';
import 'package:real_time_chat/models/user.dart';

class AuthService with ChangeNotifier {
  User user;
  bool _authenticating = false;
  final _storage = new FlutterSecureStorage();

  // Auth State
  bool get authenticating => this._authenticating;
  set authenticating(bool v) {
    this._authenticating = v;
    notifyListeners();
  }

  // Auth token
  static Future<String> getToken() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    return token;
  }

  static Future<void> deleteToken() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.authenticating = true;

    final data = {
      'email': email,
      'password': password,
    };

    final res = await http.post(
      '${Environment.apiUrl}/auth/login',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    this.authenticating = false;

    if (res.statusCode == 200) {
      final response = loginResponseFromJson(res.body);
      this.user = response.data.user;
      await this._saveToken(response.data.token);

      return true;
    }

    return false;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    this.authenticating = true;
    final data = {
      'name': name,
      'email': email,
      'password': password,
    };

    final res = await http.post(
      '${Environment.apiUrl}/auth/register',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    this.authenticating = false;
    if (res.statusCode == 200) {
      final response = registerUserResponseFromJson(res.body);
      this.user = response.data.user;
      await this._saveToken(response.data.token);

      final map = {
        'success': true,
        'message': '',
      };

      return map;
    }
    final map = {
      'success': false,
      'message': jsonDecode(res.body)['message'] != null
          ? jsonDecode(res.body)['message']
          : 'Revisa que tus credenciales sean correctas.',
    };

    return map;
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final res = await http.get('${Environment.apiUrl}/auth/token', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    print(res.body);

    if (res.statusCode == 200) {
      final response = tokenResponseFromJson(res.body);
      this.user = response.data.user;
      await this._saveToken(response.data.token);

      return true;
    }

    await this.logout();

    return false;
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }
}
