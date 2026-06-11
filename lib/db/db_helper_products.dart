import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastosappg15/models/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// CON PATRÓN SINGLETON Y USO DEL PRODUCTO MODEL
class DbHelperProducts {
  // Definimos un constructor privado: Nadie puede hacer DbHelperProducts()
  DbHelperProducts._internal();

  // Instancia única (objeto único)
  static final DbHelperProducts instance = DbHelperProducts._internal();

  // Referencia a la BD (SE CREA UNA SOLA VEZ)
  static Database? _myProductsDatabase;

  // Getter: esto asegura que se INICIALICE solo si aún no existe
  Future<Database> get database async {
    if (_myProductsDatabase != null) return _myProductsDatabase!;
    _myProductsDatabase = await _initDatabase();
    return _myProductsDatabase!;
  }

  // inicializamos la db DE MANERA PRIVADA
  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print(directory);
    String pathDatabase = join(directory.path, "ProductsDB.db");
    return openDatabase(
      pathDatabase,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute("""
          CREATE TABLE productos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT NOT NULL,
              precio REAL NOT NULL,
              stock INTEGER NOT NULL
            )

        """);
      },
    );
  }

  // inserción
  Future<int> insertProduct(ProductModel productModel) async {
    final db = await instance.database;
    return await db.insert("productos", productModel.tomap());
  }

  // LISTAR
  Future<List<ProductModel>> getProductos() async {
    final Database db = await instance.database;

    final result = await db.query("productos", orderBy: "id DESC");
    return result.map((element) => ProductModel.fromMap(element)).toList();
  }

  // ACTUALIZAR
  Future<int> updateProduct(ProductModel product) async {
    final db = await instance.database;
    return await db.update(
      "productos",
      product.tomap(),
      where: "id = ?",
      whereArgs: [product.id],
    );
  }

  // ELIMINACIÓN
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete("productos", where: "id = ?", whereArgs: [id]);
  }
}

// DB SIN PATRÓN SINGLETON
// class DbHelperProducts {
//   Database? myProductsDatabase;

//   Future<Database> initDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     print(directory);
//     String pathDatabase = join(directory.path, "ProductsDB.db");
//     return openDatabase(
//       pathDatabase,
//       version: 1,
//       onCreate: (Database db, int version) {
//         db.execute("""
//           CREATE TABLE productos (
//               id INTEGER PRIMARY KEY AUTOINCREMENT,
//               nombre TEXT NOT NULL,
//               precio REAL NOT NULL,
//               stock INTEGER NOT NULL
//             )

//         """);
//       },
//     );
//   }

//   // INSERTAR
//   Future<void> insertProduct(String nombre, double precio, int stock) async {
//     final db = await initDatabase();
//     db.insert("productos", {
//       "nombre": nombre,
//       "precio": precio,
//       "stock": stock,
//     });
//   }

//   // OBTENER REGISTROS
//   Future<List<Map<String, dynamic>>> obtenerProductos() async {
//     final db = await initDatabase();
//     return db.rawQuery("SELECT * FROM productos");
//     // return db.rawQuery("SELECT nombre, stock FROM productos WHERE stock < 11");
//     // return db.query(
//     //   "productos",
//     //   where: "nombre = 'Teclado' ",
//     //   columns: ["id,nombre"],
//     // );
//   }

//   // ACTUALIZACIÓN
//   Future<void> actualizarProducto(int id, String nombre) async {
//     final db = await initDatabase();
//     await db.update(
//       "productos",
//       {"nombre": nombre},
//       where: "id = ?",
//       whereArgs: [id],
//     );
//   }

//   // ELIMINACIÓN
//   Future<void> eliminarProducto(int id) async {
//     final db = await initDatabase();
//     await db.delete("productos", where: "id = ? ", whereArgs: [id]);
//   }
// }
