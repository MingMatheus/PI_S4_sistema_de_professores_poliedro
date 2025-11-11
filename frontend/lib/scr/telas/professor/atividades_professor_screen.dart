import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';

class ProfessorAtividadesScreen extends StatefulWidget {
  const ProfessorAtividadesScreen({super.key});

  @override
  State<ProfessorAtividadesScreen> createState() =>
      _ProfessorAtividadesScreenState();
}

class _ProfessorAtividadesScreenState extends State<ProfessorAtividadesScreen> {
  // Lista mock/local de atividades
  final List<Map<String, dynamic>> _atividades = [
    {
      'titulo': 'Lista 1 - Funções Afins',
      'turma': '1º Ano A',
      'tipo': 'Trabalho',
      'dataEntrega': '20/03/2025',
      'descricao': 'Resolver os exercícios 1 a 10 do capítulo 3.',
      'status': 'Aberta',
    },
    {
      'titulo': 'Prova - Revolução Francesa',
      'turma': '2º Ano B',
      'tipo': 'Prova',
      'dataEntrega': '25/03/2025',
      'descricao': 'Avaliação com 10 questões dissertativas.',
      'status': 'Aberta',
    },
    {
      'titulo': 'Atividade - Fotossíntese',
      'turma': '1º Ano A',
      'tipo': 'Atividade',
      'dataEntrega': '18/03/2025',
      'descricao': 'Responder questionário sobre o vídeo em sala.',
      'status': 'Encerrada',
    },
  ];

  final List<String> _tipos = ['Atividade', 'Trabalho', 'Prova', 'Outro'];

  // -------------------- AÇÕES --------------------

  Future<void> _adicionarAtividade() async {
    final tituloController = TextEditingController();
    final turmaController = TextEditingController();
    final dataController = TextEditingController();
    final descricaoController = TextEditingController();
    String tipoSelecionado = _tipos.first;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova atividade'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ex: Lista 1 - Funções Afins',
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
              const SizedBox(height: 10),
              TextField(
                controller: dataController,
                decoration: const InputDecoration(
                  labelText: 'Data de entrega',
                  hintText: 'Ex: 20/03/2025',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                decoration:
                    const InputDecoration(labelText: 'Tipo de atividade'),
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
              const SizedBox(height: 10),
              TextField(
                controller: descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Detalhes da atividade, instruções etc.',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Depois é só integrar aqui com as respostas dos alunos / notas.',
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
              final turma = turmaController.text.trim();
              final data = dataController.text.trim();
              final desc = descricaoController.text.trim();

              if (titulo.isNotEmpty &&
                  turma.isNotEmpty &&
                  data.isNotEmpty &&
                  desc.isNotEmpty) {
                setState(() {
                  _atividades.add({
                    'titulo': titulo,
                    'turma': turma,
                    'tipo': tipoSelecionado,
                    'dataEntrega': data,
                    'descricao': desc,
                    'status': 'Aberta',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editarAtividade(int index) async {
    final atividade = _atividades[index];

    final tituloController =
        TextEditingController(text: atividade['titulo'] as String? ?? '');
    final turmaController =
        TextEditingController(text: atividade['turma'] as String? ?? '');
    final dataController =
        TextEditingController(text: atividade['dataEntrega'] as String? ?? '');
    final descricaoController =
        TextEditingController(text: atividade['descricao'] as String? ?? '');
    String tipoSelecionado =
        (atividade['tipo'] as String?) ?? _tipos.first;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar atividade'),
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
                controller: turmaController,
                decoration: const InputDecoration(labelText: 'Turma'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dataController,
                decoration:
                    const InputDecoration(labelText: 'Data de entrega'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                decoration:
                    const InputDecoration(labelText: 'Tipo de atividade'),
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
              const SizedBox(height: 10),
              TextField(
                controller: descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descrição'),
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
              final turma = turmaController.text.trim();
              final data = dataController.text.trim();
              final desc = descricaoController.text.trim();

              if (titulo.isNotEmpty &&
                  turma.isNotEmpty &&
                  data.isNotEmpty &&
                  desc.isNotEmpty) {
                setState(() {
                  _atividades[index] = {
                    'titulo': titulo,
                    'turma': turma,
                    'tipo': tipoSelecionado,
                    'dataEntrega': data,
                    'descricao': desc,
                    'status': atividade['status'],
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

  Future<void> _removerAtividade(int index) async {
    final titulo = _atividades[index]['titulo'] ?? 'atividade';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir atividade'),
        content:
            Text('Tem certeza que deseja excluir "$titulo"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() {
        _atividades.removeAt(index);
      });
    }
  }

  void _alternarStatus(int index) {
    setState(() {
      _atividades[index]['status'] =
          _atividades[index]['status'] == 'Aberta'
              ? 'Encerrada'
              : 'Aberta';
    });
  }

  // -------------------- BUILD --------------------

  Color _statusColor(String status) {
    if (status == 'Encerrada') return Colors.redAccent;
    return Colors.green;
  }

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
          'Atividades',
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
          onPressed: _adicionarAtividade,
          backgroundColor: poliedroBlue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add, size: 22),
          label: Text(
            'Nova atividade',
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
        child: _atividades.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma atividade cadastrada.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: _atividades.length,
                itemBuilder: (context, index) {
                  final atv = _atividades[index];
                  final titulo = atv['titulo'] as String? ?? '';
                  final turma = atv['turma'] as String? ?? '';
                  final tipo = atv['tipo'] as String? ?? '';
                  final data = atv['dataEntrega'] as String? ?? '';
                  final desc = atv['descricao'] as String? ?? '';
                  final status = atv['status'] as String? ?? 'Aberta';

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
                        horizontal: isMobile ? 10 : 14,
                        vertical: 4,
                      ),
                      leading: Icon(
                        Icons.assignment_outlined,
                        color: poliedroBlue,
                        size: isMobile ? 24 : 26,
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
                        child: Row(
                          children: [
                            Text(
                              '$turma • $tipo • $data',
                              style: TextStyle(
                                fontSize: isMobile ? 10.5 : 11.5,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: isMobile ? 9.5 : 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: _statusColor(status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      childrenPadding: EdgeInsets.fromLTRB(
                        isMobile ? 10 : 16,
                        8,
                        isMobile ? 10 : 16,
                        10,
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            desc,
                            style: TextStyle(
                              fontSize: isMobile ? 11.5 : 12.5,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _alternarStatus(index),
                              icon: Icon(
                                status == 'Aberta'
                                    ? Icons.lock_outline
                                    : Icons.lock_open_outlined,
                                size: isMobile ? 16 : 18,
                                color: poliedroBlue,
                              ),
                              label: Text(
                                status == 'Aberta'
                                    ? 'Encerrar'
                                    : 'Reabrir',
                                style: TextStyle(
                                  fontSize: isMobile ? 11.5 : 12.5,
                                  color: poliedroBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton.icon(
                              onPressed: () => _editarAtividade(index),
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
                            const SizedBox(width: 4),
                            TextButton.icon(
                              onPressed: () => _removerAtividade(index),
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
                        const SizedBox(height: 4),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
