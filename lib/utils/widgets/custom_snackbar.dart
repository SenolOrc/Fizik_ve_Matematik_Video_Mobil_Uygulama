import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key? key,
    required Widget content,
    Color backgroundColor = Colors.grey,
    double borderRadius = 10.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    Duration duration = const Duration(seconds: 3),
  }) : super(
          key: key,
          content: content,
          backgroundColor: backgroundColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          margin: const EdgeInsets.all(15.0),
          padding: padding,
        );
}

// Kullanım Örneği
void showCustomSnackBar(BuildContext context) {
  final snackBar = CustomSnackBar(
    content: const Text('Lütfen önce bir resim seçin.'),
    backgroundColor: Colors.blue, // Arka plan rengi
    borderRadius: 20.0, // Kenar yuvarlaklığı
    padding: const EdgeInsets.all(16.0), // Padding
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
