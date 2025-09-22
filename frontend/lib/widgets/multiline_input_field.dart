import 'package:flutter/material.dart';

class MultilineInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLength;

  const MultilineInputField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLength = 500, // ✅ valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: 4,
        maxLength: maxLength, // límite de caracteres
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          counterText: "", // opcional: oculta el contador visual abajo
        ),
      ),
    );
  }
}
