import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';

class ProfessorMateriaisScreen extends StatefulWidget {
  const ProfessorMateriaisScreen({super.key});

  @override
  State<ProfessorMateriaisScreen> createState() =>
      _ProfessorMateriaisScreenState();
}

class _ProfessorMateriaisScreenState extends State<ProfessorMateriaisScreen> {
  // Lista de materiais (mock/local)
  final List<Map<String, String>> _materiais = [
    {
      'titulo': 'Lista de Exercícios - Funções Quadráticas.pdf',
      'disciplina': 'Matemática',
      'tipo': 'PDF',
      'turma': '1º Ano A',
    },
    {
      'titulo': 'Resumo - Revolução Francesa.pptx',
      'disciplina': 'História',
      'tipo': 'Apresentação',
      'turma': '2º Ano B',
    },
    {
      'titulo': 'Vídeo - Fotossíntese (YouTube)',
      'disciplina': 'Biologia',
      'tipo': 'Link',
      'turma': '1º Ano A',
    },
  ];

  final List<String> _tipos = ['PDF', 'Apresentação', 'Link', 'Outro'];

  // -------------------- HELPERS --------------------

  IconData _iconForTipo(String tipo) {
    switch (tipo) {
      case 'PDF':
        return Icons.picture_as_pdf_outlined;
      case 'Apresentação':
        return Icons.slideshow_outlined;
      case 'Link':
        return Icons.link_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  // -------------------- AÇÕES --------------------

  Future<void> _adicionarMaterial() async {
    final tituloController = TextEditingController();
    final disciplinaController = TextEditingController();
    final turmaController = TextEditingController();
    String tipoSelecionado = _tipos.first;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Novo material'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título do material',
                  hintText: 'Ex: Lista de Exercícios - Funções',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: disciplinaController,
                decoration: const InputDecoration(
                  labelText: 'Disciplina',
                  hintText: 'Ex: Matemática',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: turmaController,
                decoration: const InputDecoration(
                  labelText: 'Turma',
                  hintText: 'Ex: 1º Ano A',
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButtonFormField<String>(
                  value: tipoSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de material',
                  ),
                  items: _tipos
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(t),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      tipoSelecionado = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Obs: upload/link real pode ser conectado depois à API.',
                style: TextStyle(fontSize: 10.5, color: Colors.grey),
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
              final disciplina = disciplinaController.text.trim();
              final turma = turmaController.text.trim();

              if (titulo.isNotEmpty &&
                  disciplina.isNotEmpty &&
                  turma.isNotEmpty) {
                setState(() {
                  _materiais.add({
                    'titulo': titulo,
                    'disciplina': disciplina,
                    'tipo': tipoSelecionado,
                    'turma': turma,
                  });
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

  Future<void> _editarMaterial(int index) async {
    final original = _materiais[index];
    final tituloController = TextEditingController(text: original['titulo']);
    final disciplinaController =
        TextEditingController(text: original['disciplina']);
    final turmaController = TextEditingController(text: original['turma']);
    String tipoSelecionado = original['tipo'] ?? _tipos.first;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar material'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: disciplinaController,
                decoration: const InputDecoration(labelText: 'Disciplina'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: turmaController,
                decoration: const InputDecoration(labelText: 'Turma'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                decoration:
                    const InputDecoration(labelText: 'Tipo de material'),
                items: _tipos
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) tipoSelecionado = value;
                },
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
              final disciplina = disciplinaController.text.trim();
              final turma = turmaController.text.trim();

              if (titulo.isNotEmpty &&
                  disciplina.isNotEmpty &&
                  turma.isNotEmpty) {
                setState(() {
                  _materiais[index] = {
                    'titulo': titulo,
                    'disciplina': disciplina,
                    'tipo': tipoSelecionado,
                    'turma': turma,
                  };
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

  Future<void> _removerMaterial(int index) async {
    final titulo = _materiais[index]['titulo'] ?? 'material';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir material'),
        content:
            Text('Tem certeza que deseja excluir "$titulo" da lista de materiais?'),
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
        _materiais.removeAt(index);
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
          'Materiais de Aula',
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
        height: isMobile ? 44 : 46,
        child: FloatingActionButton.extended(
          onPressed: _adicionarMaterial,
          backgroundColor: poliedroBlue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add, size: 22),
          label: Text(
            'Novo material',
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
        child: _materiais.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum material cadastrado.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: _materiais.length,
                itemBuilder: (context, index) {
                  final mat = _materiais[index];
                  final titulo = mat['titulo'] ?? '';
                  final disciplina = mat['disciplina'] ?? '';
                  final tipo = mat['tipo'] ?? 'Outro';
                  final turma = mat['turma'] ?? '';

                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: isMobile ? 6 : 8,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 10 : 14,
                        vertical: isMobile ? 8 : 10,
                      ),
                      leading: Icon(
                        _iconForTipo(tipo),
                        color: poliedroBlue,
                        size: isMobile ? 26 : 30,
                      ),
                      title: Text(
                        titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 13.5 : 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '$disciplina • $turma • $tipo',
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            tooltip: 'Editar',
                            icon: Icon(
                              Icons.edit_outlined,
                              size: isMobile ? 18 : 20,
                              color: poliedroBlue,
                            ),
                            onPressed: () => _editarMaterial(index),
                          ),
                          IconButton(
                            tooltip: 'Excluir',
                            icon: Icon(
                              Icons.delete_outline,
                              size: isMobile ? 18 : 20,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _removerMaterial(index),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Aqui futuramente pode abrir o PDF/link/etc.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Ação de abrir material pode ser ligada ao backend depois.'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
