import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, i) => ListTile(
            title: Text(users[i].name),
            leading: CircleAvatar(
              child: Text(
                users[i].name.substring(0, 2),
              ),
            ),
            trailing: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: users[i].online ? Colors.green[300] : Colors.red,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          separatorBuilder: (_, i) => Divider(),
          itemCount: users.length,
        ),
      ),
    );
  }
}
