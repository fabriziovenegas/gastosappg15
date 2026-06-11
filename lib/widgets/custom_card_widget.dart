import 'package:flutter/material.dart';
import 'package:gastosappg15/models/gasto_model.dart';

class CustomCardWidget extends StatelessWidget {
  GastoModel gastoModel;

  CustomCardWidget({super.key, required this.gastoModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset("assets/icons/bancos.webp", width: 40, height: 40),
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
