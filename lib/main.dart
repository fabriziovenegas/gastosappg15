import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gastosappg15/generated/l10n.dart';
import 'package:gastosappg15/home_page.dart';
import 'package:gastosappg15/pages/home_gastos_page.dart';
import 'package:gastosappg15/pages/products_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeGastosPage(),
      debugShowCheckedModeBanner: false,
      // delegados de localización
      localizationsDelegates: [
        S.delegate, //carga nuestros textos personalizados osea arb
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // idiomas soportados por la app
      supportedLocales: S.delegate.supportedLocales,
    ),
  );
}
