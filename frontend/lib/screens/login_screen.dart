import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final result = await ApiService.login(email, password);

    debugPrint("🔍 Resultado del login: $result");

    if (result.containsKey("token")) {
      // Guardar token en local
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", result["token"]);
      await prefs.setInt("user_id", result["user_id"]);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login exitoso")));

      // Limpiar los campos
      _emailController.clear();
      _passwordController.clear();

      Navigator.pushReplacementNamed(context, "ProjectConfigScreen");
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en login: ${result['msg']}")),
      );

      // Limpiar la contraseña para volver a ingresarla
      _passwordController.clear();
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = 350; // ancho máximo de los inputs

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("confie_logotipo.png", height: 100),
                  const SizedBox(height: 20),
                  const Text(
                    "PLATAFORMA INTERACTIVA PARA EL DISEÑO DE PROPUESTAS TECNOLÓGICAS INNOVADORAS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 7, 19),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Iniciar Sesión",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 22),

                  // Campo correo
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Correo electrónico",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingrese su correo";
                      }
                      if (!value.contains("@")) {
                        return "Correo inválido";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Campo contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingrese su contraseña";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),

                  // Botón ingresar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          216,
                          129,
                          30,
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Ingresar"),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Link a registro
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "RegisterScreen");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 71, 42, 8),
                    ),
                    child: const Text("¿No tienes cuenta? Regístrate aquí"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
