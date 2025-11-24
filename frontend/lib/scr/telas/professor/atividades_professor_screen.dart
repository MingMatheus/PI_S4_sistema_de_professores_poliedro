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
            children: [
              TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título')),
              TextField(controller: turmaController, decoration: const InputDecoration(labelText: 'Turma')),
              TextField(controller: dataController, decoration: const InputDecoration(labelText: 'Data de entrega')),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                items: _tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => tipoSelecionado = value ?? _tipos.first,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextField(controller: descricaoController, maxLines: 3, decoration: const InputDecoration(labelText: 'Descrição')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () {
              if (tituloController.text.isNotEmpty) {
                setState(() {
                  _atividades.add({
                    'titulo': tituloController.text,
                    'turma': turmaController.text,
                    'tipo': tipoSelecionado,
                    'dataEntrega': dataController.text,
                    'descricao': descricaoController.text,
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

  void _editarAtividade(int index) {
    final atividade = _atividades[index];
    final tituloController = TextEditingController(text: atividade['titulo']);
    final turmaController = TextEditingController(text: atividade['turma']);
    final dataController = TextEditingController(text: atividade['dataEntrega']);
    final descricaoController = TextEditingController(text: atividade['descricao']);
    String tipoSelecionado = atividade['tipo'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar atividade'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título')),
              TextField(controller: turmaController, decoration: const InputDecoration(labelText: 'Turma')),
              TextField(controller: dataController, decoration: const InputDecoration(labelText: 'Data de entrega')),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                items: _tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => tipoSelecionado = value ?? _tipos.first,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextField(controller: descricaoController, maxLines: 3, decoration: const InputDecoration(labelText: 'Descrição')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () {
              setState(() {
                _atividades[index] = {
                  'titulo': tituloController.text,
                  'turma': turmaController.text,
                  'tipo': tipoSelecionado,
                  'dataEntrega': dataController.text,
                  'descricao': descricaoController.text,
                  'status': atividade['status'],
                };
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _alternarStatus(int index) {
    setState(() {
      _atividades[index]['status'] =
          _atividades[index]['status'] == 'Aberta' ? 'Encerrada' : 'Aberta';
    });
  }

  void _removerAtividade(int index) {
    setState(() => _atividades.removeAt(index));
  }

  Color _statusColor(String status) =>
      status == 'Encerrada' ? Colors.redAccent : Colors.green;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        title: const Text('Atividades', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfessorHomeScreen()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarAtividade,
        backgroundColor: poliedroBlue,
        icon: const Icon(Icons.add),
        label: const Text('Nova atividade'),
      ),
      floatingActionButtonLocation: isMobile
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 10 : 16),
        child: _atividades.isEmpty
            ? const Center(
                child: Text('Nenhuma atividade cadastrada.',
                    style: TextStyle(color: Colors.grey)),
              )
            : ListView.builder(
                itemCount: _atividades.length,
                itemBuilder: (context, index) {
                  final a = _atividades[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: isMobile ? 6 : 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ExpansionTile(
                      title: Text(a['titulo'],
                          style: TextStyle(
                              fontSize: isMobile ? 13.5 : 15,
                              fontWeight: FontWeight.w600)),
                      subtitle: Row(
                        children: [
                          Text('${a['turma']} • ${a['tipo']} • ${a['dataEntrega']}',
                              style: TextStyle(
                                  fontSize: isMobile ? 10.5 : 11.5,
                                  color: Colors.grey[700])),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color:
                                    _statusColor(a['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(a['status'],
                                style: TextStyle(
                                    fontSize: isMobile ? 9.5 : 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(a['status']))),
                          ),
                        ],
                      ),
                      childrenPadding:
                          EdgeInsets.all(isMobile ? 10 : 16),
                      children: [
                        Text(a['descricao'],
                            style: TextStyle(
                                fontSize: isMobile ? 11.5 : 12.5,
                                color: Colors.grey[800])),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          children: [
                            TextButton.icon(
                              onPressed: () => _alternarStatus(index),
                              icon: const Icon(Icons.lock_open_outlined),
                              label: Text(a['status'] == 'Aberta'
                                  ? 'Encerrar'
                                  : 'Reabrir'),
                            ),
                            TextButton.icon(
                              onPressed: () => _editarAtividade(index),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Editar'),
                            ),
                            TextButton.icon(
                              onPressed: () => _removerAtividade(index),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Excluir'),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.redAccent),
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
