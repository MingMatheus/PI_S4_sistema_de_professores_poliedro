import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class NotasCard extends StatelessWidget {
  const NotasCard({super.key});

  @override
  Widget build(BuildContext context) {
    const todas = [
      _Nota('Nota de Prova', 'Matemática - Prova Bimestral (P2): 8.5 / 10'),
      _Nota('Nota de Exercício', 'Química - Lista de Exercícios: 10 / 10'),
      _Nota('Nota de Trabalho em Grupo', 'História - Revolução Industrial: 9.0 / 10'),
      _Nota('Nota de Simulado', 'Biologia - Genética: 7.8 / 10'),
      _Nota('Média Parcial', 'Física - Leis de Newton: 8.2 / 10'),
    ];

    final width = MediaQuery.sizeOf(context).width;
    final isNotebook = width < 1366;
    final itens = isNotebook ? todas.take(4).toList() : todas;

    return SizedBox(
      height: 315, // 🔹 mesmo limite
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(icon: Icons.bar_chart_outlined, titulo: 'Notas e Médias'),
              const SizedBox(height: 12),

              // 🔹 Scroll interno
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  itemCount: itens.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (_, i) => _LinhaNota(nota: itens[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinhaNota extends StatelessWidget {
  const _LinhaNota({required this.nota});
  final _Nota nota;

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_box_outline_blank, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nota.titulo, style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(nota.detalhes, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _Nota {
  final String titulo;
  final String detalhes;
  const _Nota(this.titulo, this.detalhes);
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.titulo});
  final IconData icon;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.bold, color: poliedroBlue);

    return Row(
      children: [
        Icon(icon, color: poliedroBlue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(titulo, style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
