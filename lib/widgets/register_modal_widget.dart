import 'package:flutter/material.dart';
import 'package:gastosappg15/db/db_helper_gastos.dart';
import 'package:gastosappg15/models/gasto_model.dart';
import 'package:gastosappg15/utils/data_general.dart';
import 'package:gastosappg15/widgets/field_widget.dart';
import 'package:gastosappg15/widgets/item_type_widget.dart';

class RegisterModalWidget extends StatefulWidget {
  const RegisterModalWidget({super.key});

  @override
  State<RegisterModalWidget> createState() => _RegisterModalWidgetState();
}

class _RegisterModalWidgetState extends State<RegisterModalWidget> {
  TextEditingController titleContoller = TextEditingController();
  TextEditingController priceControler = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String typeSelected = "Alimentos";

  Widget _buildAddButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        onPressed: () {
          GastoModel gastoModel = GastoModel(
            title: titleContoller.text.trim(),
            price: double.tryParse(priceControler.text.trim()) ?? 0,
            dateTime: dateController.text.trim(),
            type: typeSelected,
          );

          DbHelperGastos.instance.insertGasto(gastoModel).then((res) {
            if (res > 0) {
              // Se ha insertado correctamente
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.cyan,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(16),
                  ),
                  content: Text("Se ha registrado correctamente"),
                ),
              );
              Navigator.pop(context);
            }
          });
        },
        child: Text("Añadir", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Registra tu pago", style: TextStyle(fontSize: 22)),
            SizedBox(height: 12),
            FieldWidget(
              controller: titleContoller,
              hintText: "Ingresa el título",
            ),
            FieldWidget(
              controller: priceControler,
              hintText: "Ingresa el monto",
            ),
            FieldWidget(
              controller: dateController,
              hintText: "Ingresa la fecha",
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: types
                  .map(
                    (type) => ItemTypeWidget(
                      data: type,
                      isSelected: typeSelected == type["name"] ? true : false,
                      tap: () {
                        typeSelected = type["name"];
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8),

            _buildAddButton(),
          ],
        ),
      ),
    );
  }
}
