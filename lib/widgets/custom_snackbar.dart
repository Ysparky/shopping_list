import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({super.key, required String message, bool isError = false})
    : super(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? Colors.red.shade800
            : const Color(0xFF4CAF50), // Verde más oscuro
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          96,
        ), // Margen inferior aumentado
        duration: const Duration(milliseconds: 1500), // Duración reducida
        elevation: 6,
      );

  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars(); // Limpia snackbars anteriores
    messenger.showSnackBar(CustomSnackBar(message: message, isError: isError));
  }
}
