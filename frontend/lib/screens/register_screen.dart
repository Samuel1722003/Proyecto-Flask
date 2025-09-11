import 'package:flutter/material.dart';
import 'package:frontend/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() {
    final name = _nameController.text;
    // ignore: unused_local_variable
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    // Aquí iría la lógica de conexión con la API Flask
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Usuario $name registrado con éxito")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(labelText: "Nombre completo", controller: _nameController),
            CustomTextField(labelText: "Correo electrónico", controller: _emailController),
            CustomTextField(labelText: "Contraseña", controller: _passwordController, obscureText: true),
            CustomTextField(labelText: "Confirmar contraseña", controller: _confirmPasswordController, obscureText: true),
            const SizedBox(height: 20),
            CustomButton(text: "Registrarse", onPressed: _register),
          ],
        ),
      ),
    );
  }
}
