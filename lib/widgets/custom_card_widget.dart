import 'package:flutter/material.dart';
import 'package:gastosappg15/models/gasto_model.dart';

class CustomCardWidget extends StatelessWidget {
  final GastoModel gastoModel;

  CustomCardWidget({super.key, required this.gastoModel});

  static const Map<String, String> _iconMapping = {
    "Alimentos": "alimentos",
    "Banco y seguros": "bancos",
    "Entretenimiento": "entretenimiento",
    "Servicios": "servicios",
    "Otros": "otros",
  };

  @override
  Widget build(BuildContext context) {
    final iconName = _iconMapping[gastoModel.type];
    return Card(
      child: ListTile(
        leading: Image.asset(
          "assets/icons/$iconName.webp",
          width: 40,
          height: 40,
        ),
        title: Text(
          gastoModel.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(gastoModel.dateTime),
        trailing: Text(
          "S/ ${gastoModel.price}",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
