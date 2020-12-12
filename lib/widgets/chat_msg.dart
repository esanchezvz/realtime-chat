import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:real_time_chat/services/auth.service.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key key,
    @required this.message,
    @required this.uid,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return ScaleTransition(
      scale: this.animationController,
      alignment: this.uid == authService.user.uid
          ? Alignment.bottomRight
          : Alignment.topLeft,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: this.animationController,
          curve: Curves.easeInOut,
        ),
        child: Container(
          child: this.uid == authService.user.uid
              ? _sentMessage()
              : _receivedMessage(),
        ),
      ),
    );
  }

  Widget _sentMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10, left: 50, right: 10),
        child: Text(
          this.message,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _receivedMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10, right: 50, left: 10),
        child: Text(
          this.message,
          style: TextStyle(color: Colors.black87),
        ),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
