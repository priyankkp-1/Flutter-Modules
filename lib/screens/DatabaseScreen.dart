import 'dart:math' as math;

import 'package:fireabase_firestore_demo/database/DBProvider.dart';
import 'package:fireabase_firestore_demo/models/ClientModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatabaseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _databaseScreen();

  final title;
  final index;

  DatabaseScreen({this.title, this.index});
}

class _databaseScreen extends State<DatabaseScreen> {
  List<Client> testTheDB = [
    Client(firstName: "Brijesh", lastName: "Goswami", blocked: false),
    Client(firstName: "Dakshay", lastName: "Sanghvi", blocked: false),
    Client(firstName: "Hardik", lastName: "Talabira", blocked: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Hero(
          tag: "link_${widget.index}",
          child: FutureBuilder<List<Client>>(
              future: DBProvider.dbProvider.getAllClient(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Client item = snapshot.data[index];
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                        ),
                        onDismissed: (direction) {
                          DBProvider.dbProvider.deleteClient(item.id);
                          setState(() {});
                        },
                        child: ListTile(
                          title: Text(item.lastName),
                          leading: Text(item.id.toString()),
                          trailing: Checkbox(
                              value: item.blocked,
                              onChanged: (bool isdelete) {
                                DBProvider.dbProvider.blockedOrUnlocked(item);
                                setState(() {});
                              }),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: new CircularProgressIndicator());
                }
              })),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Client rnd = testTheDB[math.Random().nextInt(testTheDB.length)];
          await DBProvider.dbProvider.newClient(rnd);
          setState(() {});
        },
      ),
    );
  }
}
