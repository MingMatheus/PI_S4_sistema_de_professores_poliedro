import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';
import '../../services/avaliacao_service.dart';

class ProfessorAtividadesScreen extends StatefulWidget {
  const ProfessorAtividadesScreen({super.key});

  @override
  State<ProfessorAtividadesScreen> createState() =>
      _ProfessorAtividadesScreenState();
}

class _ProfessorAtividadesScreenState extends State<ProfessorAtividadesScreen> {
  final List<Map<String, dynamic>> _atividades = [];

  final List<String> _tipos = ['Atividade', 'Trabalho', 'Prova', 'Outro'];

  bool _carregando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarAtividades();
  }

  Future<void> _carregarAtividades() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final lista = await AvaliacaoService.listar();
      setState(() {
        _atividades
          ..clear()
          ..addAll(lista);
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar atividades: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

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
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: turmaController,
                decoration: const InputDecoration(labelText: 'Turma'),
              ),
              TextField(
                controller: dataController,
                decoration:
                    const InputDecoration(labelText: 'Data de entrega'),
              ),
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
                onChanged: (value) =>
                    tipoSelecionado = value ?? _tipos.first,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextField(
                controller: descricaoController,
                maxLines: 3,
                decoration:
                    const InputDecoration(labelText: 'Descrição'),
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
            onPressed: () async {
              if (tituloController.text.isEmpty) return;

              try {
                final nova = await AvaliacaoService.criar(
                  titulo: tituloController.text,
                  tipo: tipoSelecionado,
                  turma: turmaController.text,
                  dataEntrega: dataController.text,
                  descricao: descricaoController.text,
                );

                if (!mounted) return;
                setState(() {
                  _atividades.add(nova);
                });
                Navigator.pop(context);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Erro ao criar atividade: $e'),
                  ),
                );
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
        TextEditingController(text: atividade['titulo']);
    final turmaController =
        TextEditingController(text: atividade['turma']);
    final dataController =
        TextEditingController(text: atividade['dataEntrega']);
    final descricaoController =
        TextEditingController(text: atividade['descricao']);
    String tipoSelecionado = atividade['tipo'];

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar atividade'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: turmaController,
                decoration: const InputDecoration(labelText: 'Turma'),
              ),
              TextField(
                controller: dataController,
                decoration:
                    const InputDecoration(labelText: 'Data de entrega'),
              ),
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
                onChanged: (value) =>
                    tipoSelecionado = value ?? _tipos.first,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextField(
                controller: descricaoController,
                maxLines: 3,
                decoration:
                    const InputDecoration(labelText: 'Descrição'),
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
            onPressed: () async {
              try {
                final atualizada = await AvaliacaoService.atualizar(
                  id: atividade['id'],
                  titulo: tituloController.text,
                  tipo: tipoSelecionado,
                  turma: turmaController.text,
                  dataEntrega: dataController.text,
                  descricao: descricaoController.text,
                  status: atividade['status'],
                );

                if (!mounted) return;
                setState(() {
                  _atividades[index] = atualizada;
                });
                Navigator.pop(context);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Erro ao editar atividade: $e'),
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _alternarStatus(int index) async {
    final atividade = _atividades[index];
    final novoStatus =
        atividade['status'] == 'Aberta' ? 'Encerrada' : 'Aberta';

    try {
      final atualizada = await AvaliacaoService.atualizar(
        id: atividade['id'],
        status: novoStatus,
      );

      setState(() {
        _atividades[index] = atualizada;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao alterar status: $e'),
        ),
      );
    }
  }

  Future<void> _removerAtividade(int index) async {
    final atividade = _atividades[index];

    try {
      await AvaliacaoService.deletar(atividade['id']);
      setState(() => _atividades.removeAt(index));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir atividade: $e'),
        ),
      );
    }
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
        title: const Text(
          'Atividades',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfessorHomeScreen(),
            ),
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
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _erro != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _erro!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _carregarAtividades,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  )
                : _atividades.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma atividade cadastrada.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _atividades.length,
                        itemBuilder: (context, index) {
                          final a = _atividades[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              vertical: isMobile ? 6 : 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: ExpansionTile(
                              title: Text(
                                a['titulo'],
                                style: TextStyle(
                                  fontSize: isMobile ? 13.5 : 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    '${a['turma']} • ${a['tipo']} • ${a['dataEntrega']}',
                                    style: TextStyle(
                                      fontSize:
                                          isMobile ? 10.5 : 11.5,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _statusColor(a['status'])
                                              .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      a['status'],
                                      style: TextStyle(
                                        fontSize:
                                            isMobile ? 9.5 : 10.5,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            _statusColor(a['status']),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              childrenPadding:
                                  EdgeInsets.all(isMobile ? 10 : 16),
                              children: [
                                Text(
                                  a['descricao'],
                                  style: TextStyle(
                                    fontSize:
                                        isMobile ? 11.5 : 12.5,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () =>
                                          _alternarStatus(index),
                                      icon: const Icon(
                                        Icons.lock_open_outlined,
                                      ),
                                      label: Text(
                                        a['status'] == 'Aberta'
                                            ? 'Encerrar'
                                            : 'Reabrir',
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () =>
                                          _editarAtividade(index),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                      ),
                                      label: const Text('Editar'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () =>
                                          _removerAtividade(index),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                      ),
                                      label: const Text('Excluir'),
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            Colors.redAccent,
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
