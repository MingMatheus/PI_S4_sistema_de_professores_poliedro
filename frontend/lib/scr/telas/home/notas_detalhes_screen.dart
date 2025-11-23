// lib/scr/telas/home/notas_detalhes_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/materia.dart';
import '../../models/nota.dart';
import '../../models/avaliacao.dart';
import '../../widgets/app_bar_comum.dart';
import '../../constants/app_colors.dart';

class NotasDetalhesScreen extends StatelessWidget {
  final Materia materia;
  final List<Nota> allNotes;

  const NotasDetalhesScreen({
    super.key, 
    required this.materia,
    required this.allNotes,
  });

  // Calcula a média ponderada para uma lista de notas, normalizando-as.
  double _calcularMediaPonderada(List<Nota> notas) {
    if (notas.isEmpty) return 0.0;

    double somaNotasPonderadas = notas.fold(0, (sum, n) {
      // Normaliza a nota para a escala da matéria (0 a notaMaxima da matéria)
      final notaNormalizada = (n.notaObtida / n.avaliacao.notaMaxima) * materia.notaMaxima;
      return sum + (notaNormalizada * n.avaliacao.peso);
    });

    double somaPesos = notas.fold(0, (sum, n) => sum + n.avaliacao.peso);

    if (somaPesos == 0) return 0.0;

    return somaNotasPonderadas / somaPesos;
  }

  String _formatarNota(double nota) {
    return NumberFormat("0.##", "pt_BR").format(nota);
  }

  @override
  Widget build(BuildContext context) {
    final notasDaMateria = allNotes.where((n) => n.avaliacao.materia.id == materia.id).toList();
    final provas = notasDaMateria.where((n) => n.avaliacao.tipo == TipoAvaliacao.prova).toList();
    final trabalhos = notasDaMateria.where((n) => n.avaliacao.tipo == TipoAvaliacao.trabalho).toList();

    final mediaProvas = _calcularMediaPonderada(provas);
    final mediaTrabalhos = _calcularMediaPonderada(trabalhos);
    
    final double somaPesosMateria = materia.pesoProva + materia.pesoTrabalho;
    final mediaFinal = somaPesosMateria > 0
        ? ((mediaProvas * materia.pesoProva) + (mediaTrabalhos * materia.pesoTrabalho)) / somaPesosMateria
        : 0.0;
    
    final bool isAprovado = mediaFinal >= materia.mediaParaPassar;
    final String situacao = isAprovado ? 'Aprovado' : 'Reprovado';
    final Color corSituacao = isAprovado ? Colors.green.shade700 : Colors.red.shade700;

    return Scaffold(
      appBar: AppBarComum(titulo: materia.nome),
      body: Builder(
        builder: (context) {
          if (notasDaMateria.isEmpty) {
            return const Center(child: Text('Nenhuma nota lançada para esta matéria.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildResumoCard(context, mediaProvas, mediaTrabalhos, mediaFinal, situacao, corSituacao),
                const SizedBox(height: 16),
                if (provas.isNotEmpty) ...[
                  _buildNotasCard(context, 'Provas', provas, materia.pesoProva),
                  const SizedBox(height: 16),
                ],
                if (trabalhos.isNotEmpty) ...[
                  _buildNotasCard(context, 'Trabalhos', trabalhos, materia.pesoTrabalho),
                ],
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildResumoCard(BuildContext context, double mediaProvas, double mediaTrabalhos, double mediaFinal, String situacao, Color corSituacao) {
    final notaMaximaStr = _formatarNota(materia.notaMaxima);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo da Matéria', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildResumoRow('Média das Provas:', '${_formatarNota(mediaProvas)} / $notaMaximaStr'),
            _buildResumoRow('Média dos Trabalhos:', '${_formatarNota(mediaTrabalhos)} / $notaMaximaStr'),
            const Divider(height: 24, thickness: 1),
            _buildResumoRow('Média Final:', '${_formatarNota(mediaFinal)} / $notaMaximaStr', isBold: true),
            _buildResumoRow('Média para Passar:', '${_formatarNota(materia.mediaParaPassar)} / $notaMaximaStr', isMuted: true),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Situação:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  situacao,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corSituacao),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoRow(String label, String value, {bool isBold = false, bool isMuted = false}) {
    final style = TextStyle(
      fontSize: 16, 
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: isMuted ? Colors.grey[600] : Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  Widget _buildNotasCard(BuildContext context, String title, List<Nota> notas, double pesoNaMedia) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(
              'Peso na Média: ${_formatarNota(pesoNaMedia)}',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const Divider(height: 16),
            ...notas.map((nota) => ListTile(
                  title: Text(nota.avaliacao.nome),
                  subtitle: Text(
                    'Peso: ${_formatarNota(nota.avaliacao.peso)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  trailing: Text(
                    '${_formatarNota(nota.notaObtida)} / ${_formatarNota(nota.avaliacao.notaMaxima)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: poliedroBlue),
                  ),
                  contentPadding: EdgeInsets.zero,
                )),
          ],
        ),
      ),
    );
  }
}
