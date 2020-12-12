import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/models/chat_response.dart';
import 'package:real_time_chat/models/user.dart';
import 'package:real_time_chat/services/auth.service.dart';

class ChatService with ChangeNotifier {
  User toUser;

  Future<List<Message>> getChat(String userId) async {
    try {
      final token = await AuthService.getToken();
      final res = await http.get(
        '${Environment.apiUrl}/messages/$userId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final response = chatResponseFromJson(res.body);

      return response.data.messages;
    } catch (e) {
      return [];
    }
  }
}
