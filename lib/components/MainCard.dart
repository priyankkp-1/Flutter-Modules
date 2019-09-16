import 'package:fireabase_firestore_demo/screens/FirebaseStorage.dart';
import 'package:fireabase_firestore_demo/screens/GoogleMapScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final image;
  final title;
  final index;

  MainCard({@required this.image, @required this.title, this.index});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Container(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            new InkWell(
              onTap: () async {
                if (title == "Firebase") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirebaseStorage(
                                title: title,
                                index: index,
                              )));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoogleMapScreen(
                                title: title,
                                index: index,
                              )));
                }
              },
              child: Hero(
                tag: "link_$index",
                child: new Image.asset(
                  image,
                  width: 500,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(title, style: TextStyle(fontSize: 28)),
                  Text("Sub title", style: TextStyle(fontSize: 22)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
