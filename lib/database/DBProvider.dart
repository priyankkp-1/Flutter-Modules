import 'dart:async';
import 'dart:io';

import 'package:fireabase_firestore_demo/models/ClientModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider dbProvider = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "firstname TEXT,"
          "lastname TEXT,"
          "blocked BIT"
          ")");
    });
  }

  newClient(Client newClient) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT INTO Client (id, firstname, lastname, blocked) VALUES (?, ?, ?, ?)",
        [id, newClient.firstName, newClient.lastName, newClient.blocked]);
    return raw;
  }

  Future<List<Client>> getAllClient() async {
    final db = await database;

    var res = await db.query("Client");

    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Client", where: "id=?", whereArgs: [id]);
  }

  blockedOrUnlocked(Client item) async {
    final db = await database;
    Client blocked = Client(
      id: item.id,
      firstName: item.firstName,
      lastName: item.lastName,
      blocked: !item.blocked,
    );
    var res = await db
        .update("Client", blocked.toMap(), where: "id=?", whereArgs: [item.id]);
    return res;
  }
}
