import 'package:flutter/material.dart';

class MultilineInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLength;
  final String? hintText;

  const MultilineInputField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLength = 500,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: 4,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          counterText: "",
        ),
      ),
    );
  }
}