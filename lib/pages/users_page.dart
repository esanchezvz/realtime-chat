import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:real_time_chat/models/user.dart';
import 'package:real_time_chat/services/auth.service.dart';
import 'package:real_time_chat/services/chat.service.dart';
import 'package:real_time_chat/services/socket.service.dart';
import 'package:real_time_chat/services/users.service.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshCtrl = RefreshController(initialRefresh: false);
  final userService = new UsersService();
  List<User> users = [];

  void _onRefresh() async {
    try {
      this.users = await userService.getUsers();
      print('${this.users}');
      setState(() {});
      _refreshCtrl.refreshCompleted();
    } catch (e) {
      _refreshCtrl.refreshFailed();
    }
  }

  @override
  void initState() {
    this._onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    final _socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_authService.user.name}',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {
            _socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: _socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshCtrl,
        enablePullDown: true,
        onRefresh: _onRefresh,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, i) => _userListTile(users[i]),
          separatorBuilder: (_, i) => Divider(),
          itemCount: users.length,
        ),
      ),
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          user.name.substring(0, 2),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.toUser = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
