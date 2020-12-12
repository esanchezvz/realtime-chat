import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

alert(BuildContext ctx, String title, String subtitle) {
  if (Platform.isAndroid) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: [
          MaterialButton(
            child: Text('Aceptar'),
            elevation: 5,
            onPressed: () => Navigator.pop(ctx),
          )
        ],
      ),
    );
  } else {
    showCupertinoDialog(
      context: ctx,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Aceptar'),
            onPressed: () => Navigator.pop(ctx),
          )
        ],
      ),
    );
  }
}
