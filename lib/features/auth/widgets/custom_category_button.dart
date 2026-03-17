import 'package:flutter/material.dart';
import 'package:waffar_ly_app/core/helper/extensions/media_query.dart';


class CustomCategoryButton extends StatelessWidget {
  const CustomCategoryButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(4),
        vertical: context.h(8),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          // ✅ بيستخدم theme colors مش hardcoded
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.w(12)),
          ),
          padding: EdgeInsets.symmetric(vertical: context.h(14)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: context.sp(14),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
