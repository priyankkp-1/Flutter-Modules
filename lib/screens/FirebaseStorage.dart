import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireabase_firestore_demo/components/CustomCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseStorage extends StatefulWidget {
  FirebaseStorage({@required this.title, this.index});

  final title;
  final index;

  @override
  State<StatefulWidget> createState() => _firebaseStorage();
}

class _firebaseStorage extends State<FirebaseStorage> {
  TextEditingController taskTitleInputController, taskDescripInputController;

  @override
  initState() {
    taskTitleInputController = new TextEditingController();
    taskDescripInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('tasks').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new Hero(
                    tag: "link_${widget.index}",
                    child: new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new CustomCard(
                          title: document['title'],
                          description: document['description'],
                        );
                      }).toList(),
                    ),
                  );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Please fill all fields to create a new task"),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Task Title*'),
                  controller: taskTitleInputController,
                ),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Task Description*'),
                  controller: taskDescripInputController,
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  taskTitleInputController.clear();
                  taskDescripInputController.clear();
                  Navigator.pop(context);
                }),
            FlatButton(
                child: Text('Add'),
                onPressed: () {
                  if (taskDescripInputController.text.isNotEmpty &&
                      taskTitleInputController.text.isNotEmpty) {
                    Firestore.instance
                        .collection('tasks')
                        .add({
                          "title": taskTitleInputController.text,
                          "description": taskDescripInputController.text
                        })
                        .then((result) => {
                              Navigator.pop(context),
                              taskTitleInputController.clear(),
                              taskDescripInputController.clear(),
                            })
                        .catchError((err) => print(err));
                  }
                })
          ],
        );
      },
    );
  }
}
