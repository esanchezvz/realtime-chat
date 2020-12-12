import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:real_time_chat/models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final users = <User>[
    User(
      email: 'esteban.sanvaz@gmail.com',
      name: 'Esteban Sánchez',
      online: true,
      uid: 'esteban',
    ),
    User(
      email: 'manuel@gmail.com',
      name: 'Manuel Sánchez',
      online: false,
      uid: 'manuel',
    ),
    User(
      email: 'maribel@gmail.com',
      name: 'Maribelita Sánchez',
      online: true,
      uid: 'maribel',
    ),
  ];

  RefreshController _refreshCtrl = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshCtrl.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Nombre',
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
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            // child: Icon(
            //   Icons.offline_bolt,
            //   color: Colors.red,
            // ),
            child: Icon(
              Icons.check_circle,
              color: Colors.blue[400],
            ),
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
    );
  }
}
