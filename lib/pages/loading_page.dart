import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/pages/login_page.dart';
import 'package:real_time_chat/pages/users_page.dart';
import 'package:real_time_chat/services/auth.service.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkAuthState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Loading Page'),
          );
        },
      ),
    );
  }

  Future checkAuthState(BuildContext context) async {
    print('Called');
    final authService = Provider.of<AuthService>(context, listen: false);
    final authenticated = await authService.isLoggedIn();

    // TODO connect to socket server
    if (authenticated) {
      // Navigator.pushReplacementNamed(context, 'users');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsersPage(),
          transitionDuration: Duration(
            milliseconds: 0,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: Duration(
            milliseconds: 0,
          ),
        ),
      );
    }
  }
}
