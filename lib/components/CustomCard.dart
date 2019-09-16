import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/FirebaseStorageTaskPage.dart';

class CustomCard extends StatelessWidget {
  final title;
  final description;

  CustomCard({@required this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            Text(title),
            FlatButton(
              child: Text('see more'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FirebaseStorageTaskPage(title: title, description: description)));
              },
            )
          ],
        ),
      ),
    );
  }
}
