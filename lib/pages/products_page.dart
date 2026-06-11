import 'package:flutter/material.dart';
import 'package:gastosappg15/db/db_helper_products.dart';
import 'package:gastosappg15/models/product_model.dart';

class ProductsPage extends StatefulWidget {
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  List<ProductModel> products = [];

  Future<void> loadProducts() async {
    final data = await DbHelperProducts.instance.getProductos();
    setState(() {
      products = data;
    });
  }

  Future<void> saveProduct() async {
    final nombre = nombreController.text.trim();
    final precio = double.tryParse(precioController.text.trim()) ?? 0;
    final stock = int.tryParse(stockController.text.trim()) ?? 0;

    if (nombre.isEmpty || precio <= 0 || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa los datos correctamente")),
      );
      return;
    }

    final ProductModel productModel = ProductModel(
      nombre: nombre,
      precio: precio,
      stock: stock,
    );

    await DbHelperProducts.instance.insertProduct(productModel);

    nombreController.clear();
    stockController.clear();
    precioController.clear();

    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await DbHelperProducts.instance.deleteProduct(id);
    await loadProducts();
  }

  Future<void> showEditDialog(ProductModel product) async {
    final TextEditingController editNombreController = TextEditingController(
      text: product.nombre,
    );
    final TextEditingController editStockController = TextEditingController(
      text: product.stock.toString(),
    );
    final TextEditingController editPrecioController = TextEditingController(
      text: product.precio.toString(),
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar producto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNombreController,
                decoration: InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: editPrecioController,
                decoration: InputDecoration(labelText: "Precio"),
              ),
              TextField(
                controller: editStockController,
                decoration: InputDecoration(labelText: "Stock"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final ProductModel updatedProductModel = ProductModel(
                  id: product.id,
                  nombre: editNombreController.text.trim(),
                  precio:
                      double.tryParse(editPrecioController.text.trim()) ?? 0,
                  stock: int.tryParse(editStockController.text.trim()) ?? 0,
                );
                await DbHelperProducts.instance.updateProduct(
                  updatedProductModel,
                );

                if (!context.mounted) return;
                Navigator.pop(context);
                await loadProducts();
              },
              child: Text("Editar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    stockController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // USO CON PATRÓN SINGLETON

          ProductModel producto1 = ProductModel(
            id: 4,
            nombre: "Zapatillas Adidas",
            precio: 120.00,
            stock: 15,
          );
          // await DbHelperProducts.instance.insertProduct(producto1);
          await DbHelperProducts.instance.updateProduct(producto1);
          await DbHelperProducts.instance.deleteProduct(6);

          await DbHelperProducts.instance.getProductos().then((value) {
            List<ProductModel> productsList = value;
            print(value);
            print(productsList.length);
            productsList.forEach((element) {
              print(element.nombre);
            });
          });

          // USO SIN PATRÓN SINGLETON
          // // await DbHelperProducts().initDatabase();
          // DbHelperProducts dbHelperProducts = DbHelperProducts();
          // // dbHelperProducts.insertProduct("Teclado", 150.00, 2);
          // // dbHelperProducts.actualizarProducto(2, "Ratón Gamer");
          // dbHelperProducts.eliminarProducto(3);
          // List<Map<String, dynamic>> productosObtenidos = await dbHelperProducts
          //     .obtenerProductos();
          // ;

          // print(productosObtenidos);
        },
      ),
      appBar: AppBar(
        title: Text("Productos con SQLite"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombre del producto",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: precioController,
                  decoration: InputDecoration(
                    labelText: "Precio",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: stockController,
                  decoration: InputDecoration(
                    labelText: "Stock",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      saveProduct();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(Icons.save),
                    label: Text("Guardar producto"),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: products.isEmpty
                ? Center(child: Text("No hay productos registrados"))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = products[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(
                              product.stock.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(product.nombre),
                          subtitle: Text(
                            "S/ ${product.precio.toStringAsFixed(2)}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showEditDialog(product);
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteProduct(product.id!);
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
