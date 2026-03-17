// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:waffar_ly_app/core/helper/extensions/media_query.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.labelText,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      // ✅ النص بلون الـ theme مش hardcoded أسود
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        filled: true,
        // ✅ الخلفية من الـ theme مش hardcoded أبيض
        fillColor: colorScheme.surface,
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.4)),
        prefixIcon: Icon(icon, color: colorScheme.primary),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.w(12)),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.w(12)),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.w(12)),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.w(12)),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),
    );
  }
}
