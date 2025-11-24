import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/aviso.dart';
import '../../widgets/app_bar_comum.dart';

class AvisoDetalhesScreen extends StatelessWidget {
  final Aviso aviso;

  const AvisoDetalhesScreen({super.key, required this.aviso});

  @override
  Widget build(BuildContext context) {
    final dataBrasilia = aviso.createdAt.subtract(const Duration(hours: 3));
    final dataFormatada = DateFormat('dd/MM/yyyy \'às\' HH:mm', 'pt_BR').format(dataBrasilia);
    
    return Scaffold(
      appBar: const AppBarComum(titulo: 'Detalhes do Aviso'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              aviso.titulo,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: poliedroBlue,
              ),
            ),
            const SizedBox(height: 12),
            
            // Meta Info (Autor e Data)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Por: ${aviso.nomeAutor}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
                Text(
                  dataFormatada,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1.5),

            // Conteúdo
            Text(
              aviso.conteudo,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
