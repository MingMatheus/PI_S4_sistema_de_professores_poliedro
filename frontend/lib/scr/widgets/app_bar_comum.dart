// lib/scr/widgets/app_bar_comum.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppBarComum extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  const AppBarComum({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: poliedroBlue,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
