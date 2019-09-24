import 'package:fireabase_firestore_demo/service/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseAuthHomePage extends StatefulWidget {
  String userId;
  BaseAuth auth;
  final VoidCallback onSignedOut;

  FirebaseAuthHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _firebaseAuthHomePage();
}

class _firebaseAuthHomePage extends State<FirebaseAuthHomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth HomePage"),
        actions: <Widget>[
          new FlatButton(
              onPressed: _signOut,
              child: new Text(
                "Logout",
                style: new TextStyle(fontSize: 17.0, color: Colors.white),
              ))
        ],
      ),
      body: new Center(
        child: Container(
          child: Text("This is user : " + widget.userId),
        ),
      ),
    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
      Navigator.of(context).pop(true);
    } catch (e) {
      print(e);
    }
  }
}
