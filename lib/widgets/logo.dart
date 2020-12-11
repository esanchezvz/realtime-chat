import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double width;
  final double fontSize;
  final bool withText;

  const Logo({
    Key key,
    @required this.width,
    this.withText = false,
    this.fontSize = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/img/chat-logo.png'),
              width: this.width,
            ),
            if (this.withText) SizedBox(height: 20),
            if (this.withText)
              Text(
                'Realtime Messenger',
                style: TextStyle(fontSize: this.fontSize),
              ),
          ],
        ),
      ),
    );
  }
}
