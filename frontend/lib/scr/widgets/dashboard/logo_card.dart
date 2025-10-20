import 'package:flutter/material.dart';

class LogoCard extends StatelessWidget {
  const LogoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Image.asset(
        'assets/images/logo.jpg',
        height: 150,
      ),
    ));
  }
}