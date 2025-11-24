// lib/src/screens/professor/professor_notas_screen.dart
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import '../../constants/app_colors.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';
import '../../services/nota_service.dart';

class ProfessorNotasScreen extends StatefulWidget {
  const ProfessorNotasScreen({super.key});

  @override
  State<ProfessorNotasScreen> createState() => _ProfessorNotasScreenState();
}

class _ProfessorNotasScreenState extends State<ProfessorNotasScreen> {
  final NotaService _notaService = NotaService();
  List<Map<String, dynamic>> _turmas = [];
  bool _isLoading = true;

  final List<String> _tipos = ['Atividade', 'Trabalho', 'Prova', 'Outro'];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final turmasFetched = await _notaService.getTurmas();
      setState(() {
        _turmas = turmasFetched
            .map((turma) => {
                  'id': turma['_id'],
                  'nome': turma['nome'],
                  'atividades': <Map<String, dynamic>>[],
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Erro ao carregar turmas: $e', name: 'ProfessorNotasScreen');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar turmas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ========== AÇÕES: ATIVIDADES ==========

  Future<void> _adicionarAtividade(int turmaIndex) async {
    final tituloController = TextEditingController();
    final pesoController = TextEditingController(text: '1.0');
    final avaliacaoIdController = TextEditingController();
    String tipoSelecionado = _tipos.first;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Nova atividade - ${_turmas[turmaIndex]['nome']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ex: Prova Bimestral 2',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                items: _tipos
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      ),
                    )
                    .toList(),
                onChanged: (v) => tipoSelecionado = v ?? _tipos.first,
                decoration: const InputDecoration(labelText: 'Tipo (visual)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pesoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Peso',
                  hintText: 'Ex: 1.0',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: avaliacaoIdController,
                decoration: const InputDecoration(
                  labelText: 'ID da Avaliação (MongoDB)',
                  hintText: 'Ex: 664f0a... (ObjectId)',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'No uso real, esse ID viria da avaliação selecionada em outra tela.\n'
                'Por enquanto, você pode colar manualmente o _id da avaliação.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () {
              final titulo = tituloController.text.trim();
              final pesoText = pesoController.text.trim().replaceAll(',', '.');
              final peso = double.tryParse(pesoText) ?? 1.0;
              final avaliacaoId = avaliacaoIdController.text.trim();

              if (titulo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informe um título para a atividade.'),
                  ),
                );
                return;
              }

              if (avaliacaoId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informe o ID da avaliação.'),
                  ),
                );
                return;
              }

              setState(() {
                (_turmas[turmaIndex]['atividades'] as List).add({
                  'titulo': titulo,
                  'peso': peso,
                  'avaliacaoId': avaliacaoId,
                  'notas': <Map<String, dynamic>>[],
                });
              });

              Navigator.pop(context);
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editarAtividade(int turmaIndex, int atividadeIndex) async {
    final atividade =
        (_turmas[turmaIndex]['atividades'] as List)[atividadeIndex]
            as Map<String, dynamic>;

    final tituloController =
        TextEditingController(text: atividade['titulo'] as String? ?? '');
    final pesoController = TextEditingController(
      text: (atividade['peso'] as num?)?.toString() ?? '1.0',
    );
    final avaliacaoIdController =
        TextEditingController(text: atividade['avaliacaoId'] as String? ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar atividade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pesoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Peso'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: avaliacaoIdController,
              decoration:
                  const InputDecoration(labelText: 'ID da Avaliação (MongoDB)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () {
              final titulo = tituloController.text.trim();
              final pesoText =
                  pesoController.text.trim().replaceAll(',', '.');
              final peso = double.tryParse(pesoText) ?? 1.0;
              final avaliacaoId = avaliacaoIdController.text.trim();

              if (titulo.isEmpty || avaliacaoId.isEmpty) return;

              setState(() {
                atividade['titulo'] = titulo;
                atividade['peso'] = peso;
                atividade['avaliacaoId'] = avaliacaoId;
              });

              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _removerAtividade(int turmaIndex, int atividadeIndex) async {
    final atividade =
        (_turmas[turmaIndex]['atividades'] as List)[atividadeIndex]
            as Map<String, dynamic>;
    final titulo = atividade['titulo'] as String? ?? '';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir atividade'),
        content: Text(
          'Deseja excluir "$titulo" e todas as notas associadas (no front)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() {
        (_turmas[turmaIndex]['atividades'] as List).removeAt(atividadeIndex);
      });
    }
  }

  // ========== LANÇAMENTO DE NOTAS ==========

  Future<void> _abrirLancamentoNotas(
      int turmaIndex, int atividadeIndex) async {
    final turma = _turmas[turmaIndex];
    final atividade =
        (turma['atividades'] as List)[atividadeIndex] as Map<String, dynamic>;
    
    final avaliacaoId = atividade['avaliacaoId'] as String?;
    if (avaliacaoId == null || avaliacaoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Atividade sem ID da Avaliação do backend.'),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    // Exibe o loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final notas = await _notaService.getNotasDaAvaliacao(avaliacaoId);
      setState(() {
        atividade['notas'] = notas;
      });
    } catch (e) {
      developer.log('Erro ao buscar notas: $e', name: 'ProfessorNotasScreen');
      if (mounted) {
        Navigator.pop(context); // Fecha o loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao buscar alunos/notas: $e'),
          backgroundColor: Colors.red,
        ));
      }
      return;
    }

    if (mounted) {
      Navigator.pop(context); // Fecha o loading
    } else {
      return; 
    }

    final List notas = atividade['notas'] as List? ?? <Map<String, dynamic>>[];
    final pesoInicial = (atividade['peso'] as num?)?.toString() ?? '1.0';
    final pesoController = TextEditingController(text: pesoInicial);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        final size = MediaQuery.of(ctx).size;
        final isMobile = size.width < 800;

        return Padding(
          padding: EdgeInsets.only(
            left: isMobile ? 10 : 16,
            right: isMobile ? 10 : 16,
            top: 14,
            bottom:
                (isMobile ? 10 : 16) + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      isMobile ? size.height * 0.85 : size.height * 0.75,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                turma['nome'] as String,
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                atividade['titulo'] as String? ?? 'Atividade',
                                style: TextStyle(
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Peso:',
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: pesoController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              final v = double.tryParse(
                                      value.replaceAll(',', '.')) ??
                                  (atividade['peso'] as double? ?? 1.0);
                              setModalState(() {
                                atividade['peso'] = v;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '(${notas.length} aluno${notas.length == 1 ? '' : 's'})',
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID da Avaliação: $avaliacaoId',
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 11,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tabela
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade50,
                        ),
                        child: Column(
                          children: [
                            // Cabeçalho tabela
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 8 : 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Aluno',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isMobile ? 12 : 13,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isMobile ? 8 : 12),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      'Nota',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isMobile ? 12 : 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (notas.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Nenhum aluno encontrado para esta avaliação no backend.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isMobile ? 11 : 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: ListView.builder(
                                  itemCount: notas.length,
                                  itemBuilder: (ctx, i) {
                                    final linha =
                                        notas[i] as Map<String, dynamic>;
                                    final nome =
                                        linha['nomeAluno']?.toString() ?? '';
                                    final notaAtual =
                                        (linha['nota'] as num?)?.toString() ??
                                            '';

                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 8 : 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              nome,
                                              style: TextStyle(
                                                fontSize:
                                                    isMobile ? 12 : 13,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: isMobile ? 8 : 12),
                                          SizedBox(
                                            width: 70,
                                            child: TextFormField(
                                              initialValue: notaAtual,
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  const TextInputType
                                                          .numberWithOptions(
                                                      decimal: true),
                                              decoration:
                                                  const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 4,
                                                ),
                                                border:
                                                    OutlineInputBorder(),
                                              ),
                                              onChanged: (value) {
                                                final v = double.tryParse(
                                                        value.replaceAll(
                                                            ',', '.')) ??
                                                    null;
                                                linha['nota'] = v;
                                              },
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
                      ),
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: poliedroBlue,
                        ),
                        onPressed: () async {
                           // Mostra o loading
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(child: CircularProgressIndicator()),
                          );

                          try {
                            await _notaService.salvarNotasDaAtividade(
                                atividade);

                            if(mounted) {
                              Navigator.pop(context); // Fecha o loading
                              Navigator.pop(ctx); // Fecha o BottomSheet
                            }
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Notas salvas com sucesso no servidor.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            developer.log('Erro ao salvar notas: $e', name: 'ProfessorNotasScreen');
                             if(mounted) {
                              Navigator.pop(context); // Fecha o loading
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Erro ao salvar notas: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: Text(
                          'Salvar alterações',
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ========== BUILD PRINCIPAL (RESPONSIVO) ==========

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfessorHomeScreen(),
              ),
            );
          },
        ),
        title: Text(
          'Notas e Lançamentos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 18 : 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(isMobile ? 10 : 16),
              child: _turmas.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma turma cadastrada para o professor.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _turmas.length,
                      itemBuilder: (context, turmaIndex) {
                        final turma = _turmas[turmaIndex];
                        final atividades =
                            (turma['atividades'] as List?) ??
                                <Map<String, dynamic>>[];

                        return Card(
                          margin: EdgeInsets.symmetric(
                            vertical: isMobile ? 5 : 6,
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 12 : 16,
                              vertical: isMobile ? 2 : 4,
                            ),
                            leading: Icon(
                              Icons.class_outlined,
                              color: poliedroBlue,
                              size: isMobile ? 22 : 24,
                            ),
                            title: Text(
                              turma['nome'] as String? ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                            subtitle: Text(
                              '${atividades.length} atividade(s) cadastrada(s)',
                              style: TextStyle(
                                fontSize: isMobile ? 11 : 12,
                                color: Colors.grey,
                              ),
                            ),
                            childrenPadding: EdgeInsets.fromLTRB(
                              isMobile ? 10 : 16,
                              8,
                              isMobile ? 10 : 16,
                              10,
                            ),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Atividades e provas',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isMobile ? 13 : 14,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () =>
                                        _adicionarAtividade(turmaIndex),
                                    icon: Icon(
                                      Icons.add,
                                      size: isMobile ? 16 : 18,
                                      color: poliedroBlue,
                                    ),
                                    label: Text(
                                      'Nova atividade',
                                      style: TextStyle(
                                        color: poliedroBlue,
                                        fontSize: isMobile ? 11 : 12.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (atividades.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Nenhuma atividade cadastrada para esta turma.',
                                    style: TextStyle(
                                      fontSize: isMobile ? 11 : 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                )
                              else
                                Column(
                                  children: List.generate(
                                    atividades.length,
                                    (atividadeIndex) {
                                      final atividade =
                                          atividades[atividadeIndex]
                                              as Map<String, dynamic>;
                                      final titulo =
                                          atividade['titulo'] as String? ??
                                              'Atividade';
                                      final peso =
                                          atividade['peso'] as num? ?? 1.0;
                                      final notas =
                                          (atividade['notas'] as List?) ?? [];

                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: isMobile ? 3 : 4,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isMobile ? 8 : 10,
                                          vertical: isMobile ? 6 : 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 0.6,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    titulo,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize:
                                                          isMobile ? 12.5 : 13.5,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Peso: ${peso.toString()} • ${notas.length} aluno(s)',
                                                    style: TextStyle(
                                                      fontSize:
                                                          isMobile ? 10 : 11.5,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: isMobile ? 4 : 8),
                                            TextButton(
                                              onPressed: () =>
                                                  _abrirLancamentoNotas(
                                                    turmaIndex,
                                                    atividadeIndex,
                                                  ),
                                              child: Text(
                                                'Lançar / editar notas',
                                                style: TextStyle(
                                                  fontSize:
                                                      isMobile ? 10.5 : 11.5,
                                                  color: poliedroBlue,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'Editar atividade',
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                size: isMobile ? 16 : 18,
                                                color: poliedroBlue,
                                              ),
                                              onPressed: () => _editarAtividade(
                                                  turmaIndex, atividadeIndex),
                                            ),
                                            IconButton(
                                              tooltip: 'Excluir atividade',
                                              icon: Icon(
                                                Icons.delete_outline,
                                                size: isMobile ? 16 : 18,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () => _removerAtividade(
                                                  turmaIndex, atividadeIndex),
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
                      },
                    ),
            ),
    );
  }
}
