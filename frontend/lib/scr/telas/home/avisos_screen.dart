import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    // mesma posição das faixas 
    final bool isWide = w >= 1200;
    final double imgScale   = isWide ? 1.32 : 1.30;
    final double imgOffsetY = isWide ? 65.0 : 100.0;
    final double imgOffsetX = isWide ? 0.0 : -28.0;

    // 👇 garantir double (com .0)
    final double contentMaxWidth = () {
      if (w >= 1400) return 980.0;
      if (w >= 1200) return 940.0;
      if (w >= 1080) return 900.0;
      if (w >= 900)  return 860.0;
      return double.infinity; // mobile/tablet preenche
    }();

    const bg = Color(0xFFF2F4F7);

    return Container(
      color: bg,
      child: Stack(
        children: [
          // 🎨 FUNDO DIAGONAL
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.bottomRight,
                child: OverflowBox(
                  minWidth: 0, minHeight: 0,
                  maxWidth: double.infinity, maxHeight: double.infinity,
                  alignment: Alignment.bottomRight,
                  child: Transform.translate(
                    offset: Offset(imgOffsetX, imgOffsetY),
                    child: Transform.scale(
                      scale: imgScale,
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/images/poliedro_diagonal.png',
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 📦 CONTEÚDO
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avisos',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _avisos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _AvisoCard(aviso: _avisos[i]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== DATA MODEL ==========
class _Aviso {
  final String titulo;
  final String corpo;
  final String quando;
  final bool lido; // false = não lido (preto) | true = lido (azul)

  const _Aviso({
    required this.titulo,
    required this.corpo,
    required this.quando,
    required this.lido,
  });
}

// ========== LISTA FAKE (2 pretos, 2 azuis) ==========
const List<_Aviso> _avisos = [
  _Aviso(
    titulo: 'Prof. Silva — Física',
    corpo: 'Olá João. Recebi seu trabalho e gostei muito da sua análise. Continue assim!',
    quando: 'Hoje — 15:20',
    lido: false, // preto
  ),
  _Aviso(
    titulo: 'Prof. Marina — Matemática',
    corpo: 'Corrigi sua lista. Você melhorou muito nas últimas atividades, continue praticando!',
    quando: 'Ontem — 18:45',
    lido: false, // preto
  ),
  _Aviso(
    titulo: 'Prof. Lucas — Química',
    corpo: 'Ótimo desempenho no laboratório, sua explicação das ligações covalentes foi ótima.',
    quando: 'Ontem — 09:10',
    lido: true, // azul
  ),
  _Aviso(
    titulo: 'Coordenação — Poliedro',
    corpo: 'Lembrando que o prazo para entrega dos trabalhos de revisão termina sexta-feira.',
    quando: '01/10 — 11:00',
    lido: true, // azul
  ),
];

// ========== CARD ==========
class _AvisoCard extends StatelessWidget {
  const _AvisoCard({required this.aviso});
  final _Aviso aviso;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final Color iconColor = aviso.lido ? poliedroBlue : Colors.black87;

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aviso.titulo,
                    style: txt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    aviso.corpo,
                    style: txt.bodyMedium?.copyWith(
                      color: Colors.black.withOpacity(0.78),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(height: 1, color: Colors.black.withOpacity(0.06)),
                  const SizedBox(height: 6),
                  Text(
                    aviso.quando,
                    style: txt.bodySmall?.copyWith(
                      color: Colors.black.withOpacity(0.55),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.notifications_rounded, size: 22, color: iconColor),
          ],
        ),
      ),
    );
  }
}
