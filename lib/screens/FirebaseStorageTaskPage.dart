import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseStorageTaskPage extends StatelessWidget {
  FirebaseStorageTaskPage({@required this.title, this.description});

  final description;
  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(description),
            RaisedButton(
              child: Text('Return'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
