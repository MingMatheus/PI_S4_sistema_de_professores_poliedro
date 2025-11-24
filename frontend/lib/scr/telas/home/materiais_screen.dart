import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_colors.dart';
import '../../models/arquivo.dart';
import '../../models/pasta.dart';
import '../../services/materiais_service.dart';
import 'imagem_viewer_screen.dart';

class MateriaisScreen extends StatefulWidget {
  const MateriaisScreen({super.key});

  @override
  State<MateriaisScreen> createState() => _MateriaisScreenState();
}

class _MateriaisScreenState extends State<MateriaisScreen> {
  final MateriaisService _materiaisService = MateriaisService();
  late Future<Map<String, List<dynamic>>> _contentFuture;
  final List<Map<String, String?>> _history = [{'id': null, 'nome': 'Início'}];

  @override
  void initState() {
    super.initState();
    _fetchConteudo();
  }

  void _fetchConteudo({String? pastaId}) {
    setState(() {
      _contentFuture = _materiaisService.getConteudoPasta(pastaId: pastaId);
    });
  }

  void _navigateToPasta(Pasta pasta) {
    setState(() {
      _history.add({'id': pasta.id, 'nome': pasta.nome});
    });
    _fetchConteudo(pastaId: pasta.id);
  }

  void _navigateToHistory(int index) {
    if (index == _history.length - 1) return;
    setState(() {
      _history.removeRange(index + 1, _history.length);
    });
    _fetchConteudo(pastaId: _history.last['id']);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    const bg = Color(0xFFF2F4F7);

    return Container(
      color: bg,
      child: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, c) {
                final pagePad = EdgeInsets.fromLTRB(w > 420 ? 24 : 16, 18, w > 420 ? 24 : 16, 0);
                return Padding(
                  padding: pagePad,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBreadcrumb(),
                      const SizedBox(height: 12),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async => _fetchConteudo(pastaId: _history.last['id']),
                          child: FutureBuilder<Map<String, List<dynamic>>>(
                            future: _contentFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Erro: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData) {
                                return const Center(child: Text('Nenhum conteúdo encontrado.'));
                              }
                              final List<Pasta> pastas = snapshot.data!['pastas'] as List<Pasta>;
                              final List<Arquivo> arquivos = snapshot.data!['arquivos'] as List<Arquivo>;
                              if (pastas.isEmpty && arquivos.isEmpty) {
                                return const Center(child: Text('Esta pasta está vazia.'));
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.only(bottom: 28),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: pastas.length + arquivos.length,
                                itemBuilder: (ctx, index) {
                                  if (index < pastas.length) {
                                    return _PastaCard(
                                      pasta: pastas[index],
                                      onTap: () => _navigateToPasta(pastas[index]),
                                    );
                                  } else {
                                    return _ArquivoCard(
                                      arquivo: arquivos[index - pastas.length],
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
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

  Widget _buildBreadcrumb() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_history.length, (index) {
          final item = _history[index];
          final isLast = index == _history.length - 1;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => _navigateToHistory(index),
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  item['nome']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                    color: isLast ? poliedroBlue : Colors.grey[700],
                  ),
                ),
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _PastaCard extends StatelessWidget {
  final Pasta pasta;
  final VoidCallback onTap;
  const _PastaCard({required this.pasta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.folder, color: poliedroBlue, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(pasta.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArquivoCard extends StatefulWidget {
  final Arquivo arquivo;
  const _ArquivoCard({required this.arquivo});

  @override
  State<_ArquivoCard> createState() => _ArquivoCardState();
}

class _ArquivoCardState extends State<_ArquivoCard> {
  bool _isDownloading = false;
  double _progress = 0.0;
  
  Future<void> _downloadFile() async {
    final Directory? downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível encontrar o diretório de downloads.')),
        );
      }
      return;
    }
    final savePath = '${downloadsDir.path}/${widget.arquivo.nomeOriginal}';
    
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    try {
      final dio = Dio();
      await dio.download(
        widget.arquivo.url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      setState(() { _isDownloading = false; });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download de "${widget.arquivo.nomeOriginal}" concluído!'),
            action: SnackBarAction(
              label: 'Abrir',
              onPressed: () => OpenFilex.open(savePath),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() { _isDownloading = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no download: $e')),
        );
      }
    }
  }

  IconData _getIconForMimeType(String mime) {
    if (mime.startsWith('image/')) return Icons.image_outlined;
    if (mime == 'application/pdf') return Icons.picture_as_pdf_rounded;
    if (mime.contains('word')) return Icons.description_rounded;
    return Icons.insert_drive_file_rounded;
  }
  
  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    final isImage = widget.arquivo.tipo.startsWith('image/');
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: isImage ? () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ImagemViewerScreen(arquivo: widget.arquivo),
          ));
        } : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(_getIconForMimeType(widget.arquivo.tipo), color: Colors.grey[700], size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.arquivo.nomeOriginal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                                           Text(
                                            '${_formatBytes(widget.arquivo.tamanho)} • ${DateFormat('dd/MM/yyyy \'às\' HH:mm', 'pt_BR').format(widget.arquivo.createdAt.subtract(const Duration(hours: 3)))}',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                           Text('Enviado por: ${widget.arquivo.nomeProfessor}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: _isDownloading
                                        ? CircularProgressIndicator(value: _progress > 0 ? _progress : null, strokeWidth: 3)
                                        : !isImage
                                          ? IconButton(
                                              padding: EdgeInsets.zero,
                                              tooltip: 'Baixar arquivo',
                                              icon: const Icon(Icons.download_rounded, color: poliedroBlue, size: 28),
                                              onPressed: _downloadFile,
                                            )
                                          : const SizedBox.shrink(), // Não mostra nada se for imagem e não estiver baixando
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
