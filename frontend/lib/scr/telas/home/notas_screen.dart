// lib/scr/telas/home/notas_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/materia.dart';
import '../../models/nota.dart';
import '../../services/nota_service.dart';
import 'notas_detalhes_screen.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  late Future<List<Nota>> _notasFuture;
  final NotaService _notaService = NotaService();

  @override
  void initState() {
    super.initState();
    _notasFuture = _notaService.getMinhasNotas();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    // ===== fundo diagonal =====
    final bool isWide = w >= 1200;
    final bool isPhoneNarrow = w < 420;
    final double imgScale = isWide ? 1.32 : (isPhoneNarrow ? 1.42 : 1.12);
    final double imgOffsetY = isWide ? 195 : (isPhoneNarrow ? 5 : -10);
    final double imgOffsetX = 0.0;

    const bg = Color(0xFFF2F4F7);

    return Container(
      color: bg,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.bottomRight,
                child: OverflowBox(
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
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

          // =================== conteúdo ===================
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;

                late int cross;
                late double aspect;
                EdgeInsets pagePad = const EdgeInsets.fromLTRB(24, 18, 24, 28);
                double hSpace = 12, vSpace = 12;

                if (w >= 1400) {
                  cross = 4;
                  aspect = 2.8;
                } else if (w >= 1080) {
                  cross = 4;
                  aspect = 2.6;
                } else if (w >= 740) {
                  cross = 2;
                  aspect = 2.2;
                } else if (w >= 420) {
                  cross = 1;
                  aspect = 3.4;
                  pagePad = const EdgeInsets.fromLTRB(20, 16, 20, 24);
                  hSpace = 10;
                  vSpace = 10;
                } else {
                  cross = 1;
                  aspect = 3.6;
                  pagePad = const EdgeInsets.fromLTRB(16, 14, 16, 24);
                  hSpace = 10;
                  vSpace = 10;
                }

                final titleStyle = Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.85),
                    );

                return SingleChildScrollView(
                  padding: pagePad,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Matérias', style: titleStyle),
                      const SizedBox(height: 10),
                      
                      FutureBuilder<List<Nota>>(
                        future: _notasFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Erro ao carregar as matérias.\n${snapshot.error}'),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('Nenhuma matéria com nota encontrada.'),
                            );
                          }

                          final allNotes = snapshot.data!;
                          // Extrai a lista de matérias únicas
                          final materiasMap = <String, Materia>{};
                          for (var nota in allNotes) {
                            materiasMap[nota.avaliacao.materia.id] = nota.avaliacao.materia;
                          }
                          final materias = materiasMap.values.toList();


                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: materias.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: cross,
                              childAspectRatio: aspect,
                              crossAxisSpacing: hSpace,
                              mainAxisSpacing: vSpace,
                            ),
                            itemBuilder: (_, i) => _NotaCard(
                              materia: materias[i],
                              allNotes: allNotes,
                              compact: w < 420,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// === card ===
class _NotaCard extends StatelessWidget {
  final Materia materia;
  final List<Nota> allNotes;
  final bool compact;

  const _NotaCard({required this.materia, required this.allNotes, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final EdgeInsets pad = compact
        ? const EdgeInsets.fromLTRB(12, 10, 10, 8)
        : const EdgeInsets.fromLTRB(16, 14, 14, 12);

    final titleStyle = txt.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: compact ? 18 : 20, // Aumenta o tamanho da fonte
    );
    
    final double iconSize = compact ? 22 : 26; // Aumenta o tamanho do ícone

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // Navega para a tela de detalhes, passando a matéria e a lista de notas
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotasDetalhesScreen(
                materia: materia,
                allNotes: allNotes,
              ),
            ),
          );
        },
        child: Padding(
          padding: pad,
          child: Row( // Usar Row para alinhar texto e ícone
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaça texto e ícone
            crossAxisAlignment: CrossAxisAlignment.center, // Centraliza verticalmente
            children: [
              Expanded( // Permite que o texto ocupe o espaço disponível
                child: Text(
                  materia.nome,
                  maxLines: 2, // Permite mais de uma linha se o nome for longo
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: iconSize,
                color: poliedroBlue.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
