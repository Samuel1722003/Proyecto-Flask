import 'package:flutter/material.dart';
import 'package:frontend/models/menu_options.dart';
import 'package:frontend/screens/login_screen.dart';
// import 'package:frontend/screens/screen.dart';

class AppRoute {
  static const initialRoute = 'home';

  static final List<MenuOptions> menuOptions = [
    MenuOptions(
      route: 'LoginScreen',
      title: 'Iniciar Sesión',
      screen: const LoginScreen(),
      icon: Icons.login,
    )
  ];

  static Map<String, Widget Function(BuildContext)> getMenuRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'home': (BuildContext context) => const LoginScreen()});
    for (final options in menuOptions) {
      appRoutes[options.route] = (BuildContext context) => options.screen;
    }
    return appRoutes;
  }
}