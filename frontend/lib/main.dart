import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmerScan',
      initialRoute:
          AppRoute.initialRoute, // ← La ruta inicial, la cual es 'home'
      routes: AppRoute.getMenuRoutes(), // ← Aquí van todas las rutas del menú
      onGenerateRoute:
          AppRoute.onGenerateRoute, // ← Si se va por una ruta que no existe
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}