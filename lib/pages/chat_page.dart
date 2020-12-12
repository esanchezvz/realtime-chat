import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _msgCtl = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isTyping = false;

  _onSubmit(String text) {
    print(text);
    _msgCtl.clear();
    setState(() => _isTyping = false);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            Text(
              'Maribelita Sánchez',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => Text('$i'),
                reverse: true,
              ),
            ),
            Divider(height: 1),
            Container(
              color: Colors.white,
              child: _chatInput(),
            )
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _msgCtl,
                onSubmitted: _onSubmit,
                onChanged: (text) {
                  setState(() {
                    text.trim().length > 0
                        ? _isTyping = true
                        : _isTyping = false;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Esccribe un mensaje...',
                  border: InputBorder.none,
                ),
                focusNode: _focusNode,
              ),
            ),
            Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed:
                        _isTyping ? () => _onSubmit(_msgCtl.text.trim()) : null,
                  )
                : IconTheme(
                    data: IconThemeData(color: Colors.blue[400]),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _isTyping
                          ? () => _onSubmit(_msgCtl.text.trim())
                          : null,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
