import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';

class ProfessorAvisosScreen extends StatefulWidget {
  const ProfessorAvisosScreen({super.key});

  @override
  State<ProfessorAvisosScreen> createState() => _ProfessorAvisosScreenState();
}

class _ProfessorAvisosScreenState extends State<ProfessorAvisosScreen> {
  // Turmas disponíveis
  final List<String> _turmasDisponiveis = [
    '1º Ano A',
    '1º Ano B',
    '2º Ano A',
    '2º Ano B',
    '3º Ano A',
    '3º Ano B',
    'Geral', // Geral = todos os alunos
  ];

  // Lista de avisos (mock)
  // Cada aviso tem: titulo, mensagem, turmas (List<String>), data, importante
  final List<Map<String, dynamic>> _avisos = [
    {
      'titulo': 'Prova de Matemática',
      'mensagem':
          'Prova bimestral de Matemática será na próxima terça-feira. Estudem os capítulos 3 e 4.',
      'turmas': ['1º Ano A'],
      'data': '10/03/2025',
      'importante': true,
    },
    {
      'titulo': 'Entrega de Trabalho de História',
      'mensagem':
          'Prazo final para entrega do trabalho sobre Revolução Francesa é sexta-feira.',
      'turmas': ['2º Ano B'],
      'data': '08/03/2025',
      'importante': false,
    },
    {
      'titulo': 'Aviso Geral',
      'mensagem':
          'Lembramos que o uso do uniforme completo é obrigatório em todas as aulas.',
      'turmas': ['Geral'],
      'data': '05/03/2025',
      'importante': false,
    },
  ];

  // ---------- HELPERS ----------

  bool _isGeral(List<String> turmas) {
    return turmas.isEmpty || turmas.contains('Geral');
  }

  String _turmasLabel(List<String> turmas) {
    if (_isGeral(turmas)) return 'Todos os alunos';
    if (turmas.length == 1) return 'Turma: ${turmas.first}';
    return 'Turmas: ${turmas.join(', ')}';
  }

  // ---------- CRIAR AVISO ----------

  Future<void> _adicionarAviso() async {
    final tituloController = TextEditingController();
    final mensagemController = TextEditingController();
    List<String> turmasSelecionadas = [];
    bool importante = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        final largura = MediaQuery.of(dialogContext).size.width;
        final bool isMobile = largura < 600;

        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            void toggleTurma(String turma) {
              setStateDialog(() {
                if (turma == 'Geral') {
                  // "Geral" é exclusivo
                  if (turmasSelecionadas.contains('Geral')) {
                    turmasSelecionadas.remove('Geral');
                  } else {
                    turmasSelecionadas
                      ..clear()
                      ..add('Geral');
                  }
                } else {
                  if (turmasSelecionadas.contains(turma)) {
                    turmasSelecionadas.remove(turma);
                  } else {
                    turmasSelecionadas.add(turma);
                  }
                  turmasSelecionadas.remove('Geral');
                }
              });
            }

            return AlertDialog(
              title: const Text('Novo aviso'),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? largura * 0.9 : 520,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          hintText:
                              'Ex: Aviso de prova, trabalho, recado geral...',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Turmas destino',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _turmasDisponiveis.map((turma) {
                          final selected =
                              turmasSelecionadas.contains(turma);

                          return FilterChip(
                            label: Text(
                              turma == 'Geral' ? 'Todos os alunos' : turma,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            selected: selected,
                            selectedColor: poliedroBlue.withOpacity(0.16),
                            checkmarkColor: poliedroBlue,
                            onSelected: (_) => toggleTurma(turma),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: mensagemController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Mensagem',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: importante,
                            activeColor: poliedroBlue,
                            onChanged: (v) {
                              setStateDialog(() {
                                importante = v ?? false;
                              });
                            },
                          ),
                          const Flexible(
                            child: Text(
                              'Marcar como aviso importante',
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Se nenhuma turma for selecionada, o aviso será marcado como geral (todos os alunos).',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: poliedroBlue,
                  ),
                  onPressed: () {
                    final titulo = tituloController.text.trim();
                    final mensagem = mensagemController.text.trim();

                    if (titulo.isEmpty || mensagem.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha pelo menos título e mensagem do aviso.',
                          ),
                        ),
                      );
                      return;
                    }

                    if (turmasSelecionadas.isEmpty) {
                      turmasSelecionadas = ['Geral'];
                    }

                    final hoje = DateTime.now();
                    final dataFormatada =
                        '${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}/${hoje.year}';

                    setState(() {
                      _avisos.insert(0, {
                        'titulo': titulo,
                        'mensagem': mensagem,
                        'turmas': List<String>.from(turmasSelecionadas),
                        'data': dataFormatada,
                        'importante': importante,
                      });
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Publicar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------- EDITAR AVISO ----------

  Future<void> _editarAviso(int index) async {
    final aviso = _avisos[index];

    final tituloController =
        TextEditingController(text: aviso['titulo']?.toString() ?? '');
    final mensagemController =
        TextEditingController(text: aviso['mensagem']?.toString() ?? '');
    List<String> turmasSelecionadas =
        List<String>.from(aviso['turmas'] ?? <String>[]);
    bool importante = aviso['importante'] == true;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        final largura = MediaQuery.of(dialogContext).size.width;
        final bool isMobile = largura < 600;

        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            void toggleTurma(String turma) {
              setStateDialog(() {
                if (turma == 'Geral') {
                  if (turmasSelecionadas.contains('Geral')) {
                    turmasSelecionadas.remove('Geral');
                  } else {
                    turmasSelecionadas
                      ..clear()
                      ..add('Geral');
                  }
                } else {
                  if (turmasSelecionadas.contains(turma)) {
                    turmasSelecionadas.remove(turma);
                  } else {
                    turmasSelecionadas.add(turma);
                  }
                  turmasSelecionadas.remove('Geral');
                }
              });
            }

            return AlertDialog(
              title: const Text('Editar aviso'),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? largura * 0.9 : 520,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Turmas destino',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _turmasDisponiveis.map((turma) {
                          final selected =
                              turmasSelecionadas.contains(turma);

                          return FilterChip(
                            label: Text(
                              turma == 'Geral' ? 'Todos os alunos' : turma,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            selected: selected,
                            selectedColor: poliedroBlue.withOpacity(0.16),
                            checkmarkColor: poliedroBlue,
                            onSelected: (_) => toggleTurma(turma),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: mensagemController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Mensagem',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: importante,
                            activeColor: poliedroBlue,
                            onChanged: (v) {
                              setStateDialog(() {
                                importante = v ?? false;
                              });
                            },
                          ),
                          const Flexible(
                            child: Text(
                              'Marcar como aviso importante',
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: poliedroBlue,
                  ),
                  onPressed: () {
                    final titulo = tituloController.text.trim();
                    final mensagem = mensagemController.text.trim();

                    if (titulo.isEmpty || mensagem.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha pelo menos título e mensagem do aviso.',
                          ),
                        ),
                      );
                      return;
                    }

                    if (turmasSelecionadas.isEmpty) {
                      turmasSelecionadas = ['Geral'];
                    }

                    setState(() {
                      _avisos[index] = {
                        'titulo': titulo,
                        'mensagem': mensagem,
                        'turmas': List<String>.from(turmasSelecionadas),
                        'data': aviso['data'],
                        'importante': importante,
                      };
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------- REMOVER AVISO ----------

  Future<void> _removerAviso(int index) async {
    final aviso = _avisos[index];
    final titulo = aviso['titulo'] ?? '';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir aviso'),
        content: Text(
          'Tem certeza que deseja excluir o aviso "$titulo"?',
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
        _avisos.removeAt(index);
      });
    }
  }

  // ---------- BUILD ----------

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final bool isMobile = largura < 800;

    final EdgeInsets pagePadding = EdgeInsets.symmetric(
      horizontal: isMobile ? 12 : 24,
      vertical: 16,
    );

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
          'Avisos e Comunicados',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarAviso,
        backgroundColor: poliedroBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo aviso'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        color: const Color(0xFFF5F7FA),
        child: Padding(
          padding: pagePadding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: _avisos.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum aviso publicado até o momento.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _avisos.length,
                      itemBuilder: (context, index) {
                        final aviso = _avisos[index];
                        final importante = aviso['importante'] == true;
                        final turmas =
                            List<String>.from(aviso['turmas'] ?? <String>[]);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: importante
                                  ? Colors.redAccent.withOpacity(0.12)
                                  : poliedroBlue.withOpacity(0.10),
                              child: Icon(
                                importante
                                    ? Icons.notification_important_outlined
                                    : Icons.campaign_outlined,
                                color:
                                    importante ? Colors.redAccent : poliedroBlue,
                                size: 22,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    aviso['titulo'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  aviso['data'] ?? '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  aviso['mensagem'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.group_outlined,
                                      size: 15,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _turmasLabel(turmas),
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    if (importante) ...[
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent
                                              .withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'IMPORTANTE',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  tooltip: 'Editar aviso',
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: poliedroBlue,
                                    size: 20,
                                  ),
                                  onPressed: () => _editarAviso(index),
                                ),
                                IconButton(
                                  tooltip: 'Excluir aviso',
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                  onPressed: () => _removerAviso(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
