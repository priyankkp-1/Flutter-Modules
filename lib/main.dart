import 'package:fireabase_firestore_demo/components/MainCard.dart';
import 'package:fireabase_firestore_demo/screens/SplashScreen.dart';
import 'package:flutter/material.dart';

import 'components/MainCard.dart';
import 'models/MainListModel.dart';

void main() => runApp(MyApp());

List<MainListModel> mainList = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) =>
            new MyHomePage(title: 'Flutter Modules')
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

//  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController taskTitleInputController, taskDescripInputController;

  @override
  initState() {
    taskTitleInputController = new TextEditingController();
    taskDescripInputController = new TextEditingController();
    mainList.add(MainListModel(
        image: "assets/images/firebase.png",
        title: "Firebase",
        subTitle: "firestore demo"));
    mainList.add(MainListModel(
        image: "assets/images/google_map.png",
        title: "Google Map",
        subTitle: "google map demo"));
    mainList.add(MainListModel(
        image: "assets/images/firebase.png",
        title: "Firebase Auth",
        subTitle: "authentication demo"));
    mainList.add(MainListModel(
        image: "assets/images/database.png",
        title: "Database",
        subTitle: "SQLite Database"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: ListView.builder(
              itemCount: mainList.length,
              itemBuilder: (BuildContext cntx, int index) {
                return new MainCard(
                  image: mainList[index].image,
                  title: mainList[index].title,
                  subTitle: mainList[index].subTitle,
                  index: index,
                );
              }),
        ),
      ),
    );
  }
}
