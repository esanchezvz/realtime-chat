import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/services/auth.service.dart';

import 'package:real_time_chat/services/chat.service.dart';
import 'package:real_time_chat/services/socket.service.dart';
import 'package:real_time_chat/widgets/chat_msg.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _msgCtl = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isTyping = false;
  List<ChatMessage> _messages = [];
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('message-sent', _onMessageListener);
  }

  void _onMessageListener(dynamic payload) {
    ChatMessage message = new ChatMessage(
      message: payload['message'],
      uid: payload['from'],
      animationController: new AnimationController(
        duration: Duration(milliseconds: 250),
        vsync: this,
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();

    _msgCtl.clear();
    setState(() => _isTyping = false);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    this.socketService.socket.off('message-sent');

    for (ChatMessage msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toUser = this.chatService.toUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Text(
                toUser.name.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(width: 10),
            Text(
              toUser.name,
              style: TextStyle(color: Colors.black87),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => _focusNode.unfocus(),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (_, i) => _messages[i],
                  itemCount: _messages.length,
                  reverse: true,
                ),
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

  _onSubmit(String text) {
    if (text.length == 0) return;

    final msg = new ChatMessage(
      message: text,
      uid: this.authService.user.uid,
      animationController: new AnimationController(
        duration: Duration(milliseconds: 250),
        vsync: this,
      ),
    );

    _messages.insert(0, msg);
    msg.animationController.forward();

    _msgCtl.clear();
    setState(() => _isTyping = false);
    _focusNode.requestFocus();

    this.socketService.emit('message-sent', {
      'from': this.authService.user.uid,
      'to': this.chatService.toUser.uid,
      'message': text,
    });
  }
}
