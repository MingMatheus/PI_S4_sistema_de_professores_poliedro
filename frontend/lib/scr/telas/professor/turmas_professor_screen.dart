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
  
  final List<Map<String, dynamic>> turmas = [
    {
      'nome': '1º Ano A',
      'alunos': ['Ana', 'Lucas', 'Mariana'],
    },
    {
      'nome': '2º Ano B',
      'alunos': ['Gustavo', 'Helena'],
    },
  ];

  // -------------------- AÇÕES --------------------

  // Criar nova turma
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

  // Editar nome da turma
  Future<void> _editarTurma(int index) async {
    final controller = TextEditingController(text: turmas[index]['nome'] as String);

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

  // Adicionar aluno
  Future<void> _adicionarAluno(int turmaIndex) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar aluno'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nome do aluno',
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

  // Remover aluno
  void _removerAluno(int turmaIndex, int alunoIndex) {
    setState(() {
      (turmas[turmaIndex]['alunos'] as List<String>).removeAt(alunoIndex);
    });
  }

  // Remover turma
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
    final isMobile = MediaQuery.of(context).size.width < 800;

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

      
      floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: _adicionarTurma,
          backgroundColor: poliedroBlue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add, size: 22),
          label: const Text(
            'Nova turma',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      floatingActionButtonLocation: isMobile
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.endFloat,

      body: Padding(
        padding: const EdgeInsets.all(16),
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
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
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
                        turma['nome'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Alunos (${alunos.length})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _adicionarAluno(index),
                              icon: const Icon(
                                Icons.person_add_alt_1_outlined,
                                size: 18,
                                color: poliedroBlue,
                              ),
                              label: const Text(
                                'Adicionar aluno',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: poliedroBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (alunos.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'Nenhum aluno cadastrado nesta turma.',
                              style: TextStyle(
                                fontSize: 12,
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
                                style: const TextStyle(fontSize: 13.5),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                onPressed: () => _removerAluno(index, i),
                              ),
                            ),
                          ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _editarTurma(index),
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: poliedroBlue,
                              ),
                              label: const Text(
                                'Editar',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: poliedroBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => _removerTurma(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                              label: const Text(
                                'Excluir',
                                style: TextStyle(
                                  fontSize: 12.5,
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
