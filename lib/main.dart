import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:real_time_chat/routes/app_routes.dart';

void main() => runApp(RealTimeChatApp());

class RealTimeChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      initialRoute: 'chat',
      routes: appRoutes,
    );
  }
}
