import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/arquivo.dart';
import '../../widgets/app_bar_comum.dart';

class ImagemViewerScreen extends StatefulWidget {
  final Arquivo arquivo;

  const ImagemViewerScreen({super.key, required this.arquivo});

  @override
  State<ImagemViewerScreen> createState() => _ImagemViewerScreenState();
}

class _ImagemViewerScreenState extends State<ImagemViewerScreen> {
  bool _isDownloading = false;
  double _progress = 0.0;

  Future<void> _downloadFile() async {
    // A lógica de download é a mesma da tela de materiais
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComum(titulo: widget.arquivo.nomeOriginal),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.8,
          maxScale: 4,
          child: Image.network(
            widget.arquivo.url,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text(
                  'Não foi possível carregar a imagem.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: _isDownloading
          ? FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(
                value: _progress > 0 ? _progress : null,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              onPressed: _downloadFile,
              tooltip: 'Baixar Imagem',
              child: const Icon(Icons.download_rounded),
            ),
    );
  }
}
