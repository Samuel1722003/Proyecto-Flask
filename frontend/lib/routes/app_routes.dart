import 'package:flutter/material.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/models/menu_options.dart';

class AppRoute {
  static const initialRoute = 'home';

  static final List<MenuOptions> menuOptions = [
    MenuOptions(
      route: 'LoginScreen',
      title: 'Iniciar Sesión',
      screen: const LoginScreen(),
      icon: Icons.login,
    ),
    MenuOptions(
      route: 'RegisterScreen',
      title: 'Registro',
      screen: const RegisterScreen(),
      icon: Icons.person_add,
    ),
    MenuOptions(
      route: 'EditProfileScreen',
      title: 'Editar Perfil',
      screen: const ProjectConfigScreen(),
      icon: Icons.edit,
    ),
    MenuOptions(
      route: 'ProjectConfigScreen',
      title: 'Configurar Proyecto',
      screen: const ProjectConfigScreen(),
      icon: Icons.settings,
    ),
  ];

  static Map<String, Widget Function(BuildContext)> getMenuRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    // Ruta inicial
    appRoutes.addAll({'home': (BuildContext context) => const ProjectConfigScreen()});

    // Agregar todas las pantallas dinámicamente
    for (final option in menuOptions) {
      appRoutes[option.route] = (BuildContext context) => option.screen;
    }
    return appRoutes;
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
