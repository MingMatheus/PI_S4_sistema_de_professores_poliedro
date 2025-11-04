import 'package:flutter/material.dart';

/// Fundo com imagem ancorada no rodapé/direita.
/// Use heightFraction pra controlar o quanto da altura da tela a imagem ocupa.
class DiagonalBackdropImage extends StatelessWidget {
  final String assetPath;
  final double heightFraction; // 0.0..1.0
  final BoxFit fit;
  final Alignment alignment;

  const DiagonalBackdropImage({
    super.key,
    required this.assetPath,
    this.heightFraction = 0.55,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * heightFraction,
      width: size.width,
      child: Align(
        alignment: alignment,
        child: Image.asset(
          assetPath,
          fit: fit,
          width: size.width,       // largura total pra evitar esticar errado
          height: size.height,     // base pro fit funcionar direito
        ),
      ),
    );
  }
}
