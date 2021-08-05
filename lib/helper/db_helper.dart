import 'package:flutter/material.dart';
import 'package:practicle_interview/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._();
  String table = "Products";
  var database;
  static List<String> products = [
    "INSERT INTO Products(name,selected,color,stock,type)VALUES('Volvo',0,'Red',10,'Car')",
  ];
  initDB() async {
    if (database == null) {
      database = openDatabase(join(await getDatabasesPath(), "product_03.db"),
          version: 1, onCreate: (db, version) {
        String sql =
            "CREATE TABLE $table(id INTEGER, name TEXT,selected INTEGER,color TEXT,stock INTEGER,type TEXT,PRIMARY KEY('id' AUTOINCREMENT))";
        db.execute(sql);
        insertData();
      });
    }
    return database;
  }

  void insertData() async {
    var db = await initDB();
    products.forEach((element) async {
      var res = await db.rawInsert(element);
      print(res);
    });
  }

  addData({required Products products}) async {
    var db = await initDB();
    String sql =
        "INSERT INTO Products(name,selected,color,stock,type)VALUES('${products.name}',0,'${products.color}',${products.stock},'${products.type}')";
    return await db.rawInsert(sql);
  }

  Future<List<Products>> getAllData() async {
    var db = await initDB();
    String sql = "SELECT * FROM $table ";
    List<Map<String, dynamic>> res = await db.rawQuery(sql);
    List<Products> response =
        res.map((record) => Products.fromMap(record)).toList();
    print(response);
    return response;
  }
}

DBHelper dbh = DBHelper._();
