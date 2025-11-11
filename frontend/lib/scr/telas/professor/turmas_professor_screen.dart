import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';

class ProfessorTurmasScreen extends StatefulWidget {
  const ProfessorTurmasScreen({super.key});

  @override
  State<ProfessorTurmasScreen> createState() => _ProfessorTurmasScreenState();
}

class _ProfessorTurmasScreenState extends State<ProfessorTurmasScreen> {
  // Lista de turmas: cada turma tem um nome e uma lista de alunos
  final List<Map<String, dynamic>> turmas = [
    {
      'nome': '1º Ano A',
      'alunos': <String>['Ana', 'Lucas', 'Mariana'],
    },
    {
      'nome': '2º Ano B',
      'alunos': <String>['Gustavo', 'Helena'],
    },
  ];

  // -------------------- AÇÕES --------------------

  Future<void> _adicionarTurma() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova turma'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Digite o nome da turma (ex: 1º Ano A)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: poliedroBlue,
            ),
            onPressed: () {
              final nome = controller.text.trim();
              if (nome.isNotEmpty) {
                setState(() {
                  turmas.add({
                    'nome': nome,
                    'alunos': <String>[],
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editarTurma(int index) async {
    final controller =
        TextEditingController(text: turmas[index]['nome'] as String);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar turma'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Novo nome da turma',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: poliedroBlue,
            ),
            onPressed: () {
              final novoNome = controller.text.trim();
              if (novoNome.isNotEmpty) {
                setState(() {
                  turmas[index]['nome'] = novoNome;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _adicionarAluno(int turmaIndex) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar aluno'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome do aluno'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: poliedroBlue,
            ),
            onPressed: () {
              final nome = controller.text.trim();
              if (nome.isNotEmpty) {
                setState(() {
                  (turmas[turmaIndex]['alunos'] as List<String>).add(nome);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _removerAluno(int turmaIndex, int alunoIndex) {
    setState(() {
      (turmas[turmaIndex]['alunos'] as List<String>).removeAt(alunoIndex);
    });
  }

  Future<void> _removerTurma(int index) async {
    final nome = turmas[index]['nome'] as String;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir turma'),
        content: Text('Tem certeza que deseja excluir a turma "$nome"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() {
        turmas.removeAt(index);
      });
    }
  }

  // -------------------- BUILD --------------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 800;

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
          'Gerenciar Turmas',
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

      // FAB ajustado para mobile/desktop
      floatingActionButton: SizedBox(
        height: isMobile ? 44 : 46,
        child: FloatingActionButton.extended(
          onPressed: _adicionarTurma,
          backgroundColor: poliedroBlue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add, size: 22),
          label: Text(
            'Nova turma',
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      floatingActionButtonLocation: isMobile
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,

      body: Padding(
        padding: EdgeInsets.all(isMobile ? 10 : 16),
        child: turmas.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma turma cadastrada.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: turmas.length,
                itemBuilder: (context, index) {
                  final turma = turmas[index];
                  final alunos = (turma['alunos'] as List<String>);

                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: isMobile ? 6 : 8,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: 4,
                      ),
                      leading: const Icon(
                        Icons.class_outlined,
                        color: poliedroBlue,
                      ),
                      title: Text(
                        turma['nome'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                      childrenPadding: EdgeInsets.fromLTRB(
                        isMobile ? 12 : 16,
                        8,
                        isMobile ? 12 : 16,
                        10,
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Alunos (${alunos.length})',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 13 : 14,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _adicionarAluno(index),
                              icon: Icon(
                                Icons.person_add_alt_1_outlined,
                                size: isMobile ? 16 : 18,
                                color: poliedroBlue,
                              ),
                              label: Text(
                                'Adicionar aluno',
                                style: TextStyle(
                                  fontSize: isMobile ? 11.5 : 12.5,
                                  color: poliedroBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (alunos.isEmpty)
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: isMobile ? 4 : 6),
                            child: Text(
                              'Nenhum aluno cadastrado nesta turma.',
                              style: TextStyle(
                                fontSize: isMobile ? 11 : 12,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          ...List.generate(
                            alunos.length,
                            (i) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                alunos[i],
                                style: TextStyle(
                                  fontSize: isMobile ? 12.5 : 13.5,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                  size: isMobile ? 18 : 20,
                                ),
                                onPressed: () =>
                                    _removerAluno(index, i),
                              ),
                            ),
                          ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _editarTurma(index),
                              icon: Icon(
                                Icons.edit_outlined,
                                size: isMobile ? 16 : 18,
                                color: poliedroBlue,
                              ),
                              label: Text(
                                'Editar',
                                style: TextStyle(
                                  fontSize: isMobile ? 11.5 : 12.5,
                                  color: poliedroBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => _removerTurma(index),
                              icon: Icon(
                                Icons.delete_outline,
                                size: isMobile ? 16 : 18,
                                color: Colors.redAccent,
                              ),
                              label: Text(
                                'Excluir',
                                style: TextStyle(
                                  fontSize: isMobile ? 11.5 : 12.5,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
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
