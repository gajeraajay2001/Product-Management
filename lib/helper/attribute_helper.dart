import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AttributeHelper {
  AttributeHelper._();
  String Table = "Attribute";
  var database;
  initDB() async {
    if (database == null) {
      database = openDatabase(join(await getDatabasesPath(), "attribute_06.db"),
          version: 1, onCreate: (db, version) {
        String sql =
            "CREATE TABLE $Table(id INTEGER, attribute TEXT,productID INTEGER,PRIMARY KEY('id' AUTOINCREMENT))";
        db.execute(sql);
      });
    }
    return database;
  }

  void insertData({required String attributes}) async {
    var db = await initDB();
    String sql =
        "INSERT INTO $Table(attribute,productID)VALUES('$attributes',0)";
    return await db.rawInsert(sql);
  }

  deleteAttributes({required int id}) async {
    var db = await initDB();
    String sql = "DELETE FROM $Table WHERE id = $id";
    return await db.rawInsert(sql);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    var db = await initDB();
    String sql = "SELECT * FROM $Table";
    return await db.rawQuery(sql);
  }

  addData({required List attrValues, required productId}) async {
    var db = await initDB();
    String sql = "";
    return await db.rawQuery(sql);
  }
}

AttributeHelper attributeHelper = AttributeHelper._();
