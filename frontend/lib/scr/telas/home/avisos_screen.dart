import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/aviso.dart';
import '../../services/aviso_service.dart';
import 'aviso_detalhes_screen.dart';

class AvisosScreen extends StatefulWidget {
  const AvisosScreen({super.key});

  @override
  State<AvisosScreen> createState() => _AvisosScreenState();
}

class _AvisosScreenState extends State<AvisosScreen> {
  late Future<List<Aviso>> _avisosFuture;
  final _avisoService = AvisoService();

  @override
  void initState() {
    super.initState();
    _avisosFuture = _avisoService.getMeusAvisos();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    // Fundo diagonal
    final bool isWide = w >= 1200;
    final bool isPhoneNarrow = w < 420;
    final double imgScale = isWide ? 1.32 : (isPhoneNarrow ? 1.42 : 1.12);
    //final double imgOffsetY = isWide ? 0 : (isPhoneNarrow ? 5 : -10);
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
                  minWidth: 0, minHeight: 0,
                  maxWidth: double.infinity, maxHeight: double.infinity,
                  alignment: Alignment.bottomRight,
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

          // conteúdo
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cw = constraints.maxWidth;
                EdgeInsets pagePad = const EdgeInsets.fromLTRB(24, 18, 24, 28);
                double vSpace = 12;
                if (cw < 740 && cw >= 420) {
                  pagePad = const EdgeInsets.fromLTRB(20, 16, 20, 24);
                  vSpace = 10;
                } else if (cw < 420) {
                  pagePad = const EdgeInsets.fromLTRB(16, 14, 16, 24);
                  vSpace = 10;
                }

                final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.85),
                    );

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _avisosFuture = _avisoService.getMeusAvisos();
                    });
                  },
                  child: Padding(
                    padding: pagePad,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avisos', style: titleStyle),
                        const SizedBox(height: 10),
                        Expanded(
                          child: FutureBuilder<List<Aviso>>(
                            future: _avisosFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Erro ao carregar avisos: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text('Nenhum aviso encontrado.'));
                              }
                              
                              final avisos = snapshot.data!;
                              
                              return ListView.separated(
                                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                itemCount: avisos.length,
                                separatorBuilder: (_, __) => SizedBox(height: vSpace),
                                itemBuilder: (_, i) => _AvisoCard(
                                  aviso: avisos[i],
                                  compact: cw < 420,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
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

// Card para Aviso
class _AvisoCard extends StatelessWidget {
  final Aviso aviso;
  final bool compact;
  const _AvisoCard({required this.aviso, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final EdgeInsets pad = compact
        ? const EdgeInsets.fromLTRB(16, 12, 12, 12)
        : const EdgeInsets.fromLTRB(16, 12, 12, 12);

    final titleStyle = txt.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: compact ? 14 : txt.titleMedium?.fontSize,
    );

    final infoStyle = txt.bodySmall!.copyWith(
      color: Colors.black.withOpacity(0.65),
      fontSize: compact ? 11 : 12,
    );
    
    // Converte a data para o fuso horário de Brasília (UTC-3)
    final dataBrasilia = aviso.createdAt.subtract(const Duration(hours: 3));
    final dataFormatada = DateFormat('dd/MM/yyyy \'às\' HH:mm', 'pt_BR').format(dataBrasilia);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AvisoDetalhesScreen(aviso: aviso),
          ));
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: pad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(aviso.titulo, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.notifications, size: 20, color: poliedroBlue),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Por: ${aviso.nomeAutor}', style: infoStyle),
                  Text(dataFormatada, style: infoStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
