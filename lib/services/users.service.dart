import 'package:http/http.dart' as http;

import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/models/user.dart';
import 'package:real_time_chat/models/users_response.dart';
import 'package:real_time_chat/services/auth.service.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final token = await AuthService.getToken();

      final res = await http.get(
        '${Environment.apiUrl}/users',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final response = usersResponseFromJson(res.body);

      return response.data.users;
    } catch (e) {
      return [];
    }
  }
}
