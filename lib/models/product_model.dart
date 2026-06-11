class ProductModel {
  int? id;
  String nombre;
  double precio;
  int stock;

  ProductModel({
    this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
  });

  Map<String, dynamic> tomap() {
    return {"id": id, "nombre": nombre, "precio": precio, "stock": stock};
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map["id"],
      nombre: map["nombre"],
      precio: map["precio"],
      stock: map["stock"],
    );
  }
}
