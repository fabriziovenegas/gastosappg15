import 'dart:io';

import 'package:gastosappg15/models/gasto_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelperGastos {
  //constructor privado
  DbHelperGastos._internal();

  static final DbHelperGastos instance = DbHelperGastos._internal();

  static Database? _myGastosDatabase;

  Future<Database> get database async {
    if (_myGastosDatabase != null) return _myGastosDatabase!;
    _myGastosDatabase = await _initDatabase();
    return _myGastosDatabase!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String pathDatabase = join(directory.path, "GastosDB.db");
    return openDatabase(
      pathDatabase,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute("""
              CREATE TABLE gastos(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                price REAL NOT NULL,
                dateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
                type TEXT NOT NULL
              )
        """);
      },
    );
  }

  Future<int> insertGasto(GastoModel gasto) async {
    Database db = await database;
    int res = await db.insert("gastos", gasto.toDb());
    print(res);
    return res;
  }

  Future<List<GastoModel>> getGastos() async {
    Database db = await database;
    List<Map<String, dynamic>> data = await db.query("gastos");
    List<GastoModel> gastoModelList = data
        .map((e) => GastoModel.fromDB(e))
        .toList();

    print(gastoModelList);
    return gastoModelList;
  }
}
