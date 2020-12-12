import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/services/auth.service.dart';
import 'package:real_time_chat/services/socket.service.dart';
import 'package:real_time_chat/utils/alert.dart';

import 'package:real_time_chat/widgets/input_field.dart';
import 'package:real_time_chat/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(width: 200, withText: true),
                _Form(),
                _renderLabels(context),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Términos y Condiciones',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderLabels(BuildContext ctx) {
    return Container(
      child: Column(
        children: [
          Text(
            '¿No tienes cuenta?',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(ctx, 'register');
            },
            child: Text(
              'Regístrate',
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    Future<void> _onSubmit() async {
      FocusScope.of(context).unfocus();

      final authenticated = await authService.login(
        emailCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if (authenticated) {
        await socketService.connect();
        Navigator.pushReplacementNamed(context, 'users');
      } else {
        alert(
          context,
          'Ooops',
          'Revisa que tus credenciales sean correctas.',
        );
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Column(
        children: [
          Text(
            'Inicia Sesión',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          InputField(
            icon: Icons.mail_outline,
            placeholder: 'Correo Electrónico',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          InputField(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.text,
            textController: passwordCtrl,
            obscure: true,
            inputAction: TextInputAction.done,
            onSubmitted: (_) async => await _onSubmit(),
          ),
          RaisedButton(
            elevation: 2,
            highlightElevation: 5,
            color: Colors.blue,
            shape: StadiumBorder(),
            onPressed: authService.authenticating ? null : _onSubmit,
            child: Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Ingresar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
