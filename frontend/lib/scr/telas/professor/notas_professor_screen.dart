import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';

class ProfessorNotasScreen extends StatefulWidget {
  const ProfessorNotasScreen({super.key});

  @override
  State<ProfessorNotasScreen> createState() => _ProfessorNotasScreenState();
}

class _ProfessorNotasScreenState extends State<ProfessorNotasScreen> {
  /// Estrutura:
  /// - turmas[]
  ///   - nome
  ///   - atividades[]
  ///      - titulo
  ///      - peso
  ///      - notas[] (aluno, nota)
  final List<Map<String, dynamic>> _turmas = [
    {
      'nome': '1º Ano A',
      'atividades': [
        {
          'titulo': 'Prova Bimestral 1',
          'peso': 2.0,
          'notas': [
            {'aluno': 'Ana Souza', 'nota': 8.5},
            {'aluno': 'Lucas Ferreira', 'nota': 7.8},
            {'aluno': 'Marcos Lima', 'nota': 6.5},
          ],
        },
        {
          'titulo': 'Atividade - Funções Afins',
          'peso': 1.0,
          'notas': [
            {'aluno': 'Ana Souza', 'nota': 9.0},
            {'aluno': 'Lucas Ferreira', 'nota': 8.0},
            {'aluno': 'Marcos Lima', 'nota': 7.0},
          ],
        },
      ],
    },
    {
      'nome': '2º Ano B',
      'atividades': [
        {
          'titulo': 'Prova - Revolução Francesa',
          'peso': 2.0,
          'notas': [
            {'aluno': 'Mariana Costa', 'nota': 9.2},
            {'aluno': 'João Pedro', 'nota': 7.9},
          ],
        },
        {
          'titulo': 'Trabalho em Grupo - História',
          'peso': 1.5,
          'notas': [
            {'aluno': 'Mariana Costa', 'nota': 10.0},
            {'aluno': 'João Pedro', 'nota': 8.5},
          ],
        },
      ],
    },
  ];

  final List<String> _tipos = ['Atividade', 'Trabalho', 'Prova', 'Outro'];

  // -------------------- AÇÕES: ATIVIDADES --------------------

  Future<void> _adicionarAtividade(int turmaIndex) async {
    final tituloController = TextEditingController();
    final pesoController = TextEditingController(text: '1.0');
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
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => tipoSelecionado = v ?? _tipos.first,
                decoration:
                    const InputDecoration(labelText: 'Tipo (visual)'),
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
              const SizedBox(height: 8),
              const Text(
                'Os alunos desta turma serão carregados a partir de um cadastro futuramente.\n'
                'Por enquanto, você pode editar as notas diretamente na tabela.',
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

              if (titulo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informe um título para a atividade.'),
                  ),
                );
                return;
              }

              setState(() {
                (_turmas[turmaIndex]['atividades'] as List).add({
                  'titulo': titulo,
                  'peso': peso,
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

              if (titulo.isEmpty) return;

              setState(() {
                atividade['titulo'] = titulo;
                atividade['peso'] = peso;
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
            'Deseja realmente excluir "$titulo" e todas as notas associadas?'),
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
        (_turmas[turmaIndex]['atividades'] as List)
            .removeAt(atividadeIndex);
      });
    }
  }

  // -------------------- LANÇAMENTO DE NOTAS --------------------

  Future<void> _abrirLancamentoNotas(
      int turmaIndex, int atividadeIndex) async {
    final turma = _turmas[turmaIndex];
    final atividade =
        (turma['atividades'] as List)[atividadeIndex] as Map<String, dynamic>;
    final List notas =
        (atividade['notas'] as List? ?? <Map<String, dynamic>>[]);

    final pesoInicial = (atividade['peso'] as num?)?.toString() ?? '1.0';
    final pesoController = TextEditingController(text: pesoInicial);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              atividade['titulo'] as String? ??
                                  'Atividade',
                              style: const TextStyle(
                                fontSize: 18,
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
                      const Text(
                        'Peso:',
                        style: TextStyle(
                          fontSize: 13,
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
                            contentPadding:
                                EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
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
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tabela de notas
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        // Cabeçalho da tabela
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Aluno',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  'Nota',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
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
                              'Nenhum aluno cadastrado para esta atividade.\n'
                              'No futuro, isso será preenchido com base na turma.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: notas.length,
                            itemBuilder: (ctx, i) {
                              final linha =
                                  notas[i] as Map<String, dynamic>;
                              final nome =
                                  linha['aluno']?.toString() ?? '';
                              final notaAtual =
                                  (linha['nota'] as num?)?.toString() ?? '';

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
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
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
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
                                                  vertical: 4),
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          final v = double.tryParse(
                                                  value.replaceAll(
                                                      ',', '.')) ??
                                              0.0;
                                          linha['nota'] = v;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: poliedroBlue,
                      ),
                      onPressed: () {
                        // As notas já foram atualizadas na lista.
                        Navigator.pop(ctx);
                        setState(() {}); // atualiza visual da tela principal
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notas salvas para esta atividade.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Salvar alterações'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // -------------------- BUILD PRINCIPAL --------------------

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Notas e Lançamentos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _turmas.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma turma cadastrada para lançamento de notas.',
                  style: TextStyle(color: Colors.grey),
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
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: const Icon(
                        Icons.class_outlined,
                        color: poliedroBlue,
                      ),
                      title: Text(
                        turma['nome'] as String? ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${atividades.length} atividade(s) cadastrada(s)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        12,
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Atividades e provas',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  _adicionarAtividade(turmaIndex),
                              icon: const Icon(
                                Icons.add,
                                size: 18,
                                color: poliedroBlue,
                              ),
                              label: const Text(
                                'Nova atividade',
                                style: TextStyle(
                                  color: poliedroBlue,
                                  fontSize: 12.5,
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
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          )
                        else
                          Column(
                            children: List.generate(atividades.length,
                                (atividadeIndex) {
                              final atividade =
                                  atividades[atividadeIndex]
                                      as Map<String, dynamic>;
                              final titulo =
                                  atividade['titulo'] as String? ??
                                      'Atividade';
                              final peso = atividade['peso'] as num? ?? 1.0;
                              final notas =
                                  (atividade['notas'] as List?) ?? [];

                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
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
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.5,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Peso: ${peso.toString()} • ${notas.length} aluno(s)',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () =>
                                          _abrirLancamentoNotas(
                                            turmaIndex,
                                            atividadeIndex,
                                          ),
                                      child: const Text(
                                        'Lançar / editar notas',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: poliedroBlue,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Editar atividade',
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: poliedroBlue,
                                      ),
                                      onPressed: () => _editarAtividade(
                                          turmaIndex, atividadeIndex),
                                    ),
                                    IconButton(
                                      tooltip: 'Excluir atividade',
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () => _removerAtividade(
                                          turmaIndex, atividadeIndex),
                                    ),
                                  ],
                                ),
                              );
                            }),
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
