import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/aluno.dart';
import '../../models/aviso.dart';
import '../../models/serie.dart';
import '../../models/turma.dart';
import '../../services/aluno_service.dart';
import '../../services/aviso_service.dart';
import '../../services/serie_service.dart';
import '../../services/turma_service.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';

class ProfessorAvisosScreen extends StatefulWidget {
  const ProfessorAvisosScreen({super.key});

  @override
  State<ProfessorAvisosScreen> createState() => _ProfessorAvisosScreenState();
}

class _ProfessorAvisosScreenState extends State<ProfessorAvisosScreen> {
  // Services
  final AvisoService _avisoService = AvisoService();
  final SerieService _serieService = SerieService();
  final TurmaService _turmaService = TurmaService();
  final AlunoService _alunoService = AlunoService();

  // Futures
  late Future<List<Aviso>> _avisosFuture;
  late Future<void> _initialDataFuture;

  // Data lists
  List<Serie> _series = [];
  List<Turma> _turmas = [];
  List<Aluno> _alunos = [];

  @override
  void initState() {
    super.initState();
    _fetchAvisos();
    _initialDataFuture = _fetchInitialData();
  }

  void _fetchAvisos() {
    setState(() {
      _avisosFuture = _avisoService.getMeusAvisos();
    });
  }
  Future<void> _fetchInitialData() async {
    try {
      final results = await Future.wait([
        _serieService.getSeries(),
        _turmaService.getTurmas(),
        _alunoService.getAlunos(),
      ]);
      if (mounted) {
        setState(() {
          _series = results[0] as List<Serie>;
          _turmas = results[1] as List<Turma>;
          _alunos = results[2] as List<Aluno>;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados de apoio: $e')),
        );
      }
    }
  }
  String _formatarAlvos(Aviso aviso) {
    if (aviso.seriesAlvo.isEmpty &&
        aviso.turmasAlvo.isEmpty &&
        aviso.alunosAlvo.isEmpty) {
      return 'Geral: Todos os alunos';
    }
    final parts = <String>[];
    if (aviso.seriesAlvo.isNotEmpty) {
      parts.add('Séries (${aviso.seriesAlvo.length})');
    }
    if (aviso.turmasAlvo.isNotEmpty) {
      parts.add('Turmas (${aviso.turmasAlvo.length})');
    }
    if (aviso.alunosAlvo.isNotEmpty) {
      parts.add('Alunos (${aviso.alunosAlvo.length})');
    }
    return parts.join(' • ');
  }

  Future<void> _removerAviso(String avisoId, String titulo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir aviso'),
        content: Text('Tem certeza que deseja excluir o aviso "$titulo"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _avisoService.deleteAviso(avisoId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Aviso excluído com sucesso!'),
                backgroundColor: Colors.green),
          );
        }
        _fetchAvisos();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erro ao excluir aviso: $e'),
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _adicionarOuEditarAviso({Aviso? aviso}) async {
    final bool isEditing = aviso != null;
    final tituloController =
        TextEditingController(text: isEditing ? aviso.titulo : '');
    final conteudoController =
        TextEditingController(text: isEditing ? aviso.conteudo : '');

    Set<String> selectedSeries = {};
    Set<String> selectedTurmas = {};
    Set<String> selectedAlunos = {};

    if (isEditing) {
      // Robust mapping to handle both String IDs and and Maps from the Aviso model
      selectedSeries = (aviso!.seriesAlvo.map((e) {
        return e is String ? e : e['_id'] as String;
      }).toSet() as Set<String>);
      selectedTurmas = (aviso!.turmasAlvo.map((e) {
        return e is String ? e : e['_id'] as String;
      }).toSet() as Set<String>);
      selectedAlunos = (aviso!.alunosAlvo.map((e) {
        return e is String ? e : e['_id'] as String;
      }).toSet() as Set<String>);
    }

    final formKey = GlobalKey<FormState>();
    bool _showRecipientError = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> showMultiSelect<T>({
              required String title,
              required List<T> allItems,
              required Set<String> selectedIds,
              required String Function(T) display,
              required String Function(T) id,
              String? Function(T)? subtitle,
            }) async {
              final result = await showDialog<Set<String>>(
                context: context,
                builder: (ctx) => _MultiSelectDialog<T>(
                  title: title,
                  allItems: allItems,
                  selectedIds: selectedIds,
                  display: display,
                  id: id,
                  subtitle: subtitle,
                ),
              );
              if (result != null) {
                setStateDialog(() {
                  if (T == Serie) selectedSeries = result;
                  if (T == Turma) selectedTurmas = result;
                  if (T == Aluno) selectedAlunos = result;
                  // Hide error message once a selection is made
                  if (result.isNotEmpty) {
                    _showRecipientError = false;
                  }
                });
              }
            }

            return AlertDialog(
              title: Text(isEditing ? 'Editar Aviso' : 'Novo Aviso'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: tituloController,
                          decoration:
                              const InputDecoration(labelText: 'Título'),
                          validator: (v) =>
                              v!.trim().isEmpty ? 'Título é obrigatório' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: conteudoController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                              labelText: 'Conteúdo do aviso',
                              border: OutlineInputBorder()),
                          validator: (v) => v!.trim().isEmpty
                              ? 'Conteúdo é obrigatório'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const Text('Selecione os Destinatários',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.school_outlined),
                          title: const Text('Séries'),
                          subtitle: Text(selectedSeries.isEmpty
                              ? 'Nenhuma selecionada'
                              : '${selectedSeries.length} selecionada(s)'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => showMultiSelect<Serie>(
                              title: 'Selecionar Séries',
                              allItems: _series,
                              selectedIds: selectedSeries,
                              display: (s) => s.nome,
                              id: (s) => s.id),
                        ),
                        ListTile(
                          leading: const Icon(Icons.class_outlined),
                          title: const Text('Turmas'),
                          subtitle: Text(selectedTurmas.isEmpty
                              ? 'Nenhuma selecionada'
                              : '${selectedTurmas.length} selecionada(s)'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => showMultiSelect<Turma>(
                              title: 'Selecionar Turmas',
                              allItems: _turmas,
                              selectedIds: selectedTurmas,
                              display: (t) => t.nome,
                              id: (t) => t.id),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Alunos Específicos'),
                          subtitle: Text(selectedAlunos.isEmpty
                              ? 'Nenhum selecionado'
                              : '${selectedAlunos.length} selecionado(s)'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => showMultiSelect<Aluno>(
                              title: 'Selecionar Alunos',
                              allItems: _alunos,
                              selectedIds: selectedAlunos,
                              display: (a) => a.nome,
                              id: (a) => a.id,
                              subtitle: (a) => 'RA: ${a.ra}'),
                        ),
                        if (_showRecipientError)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, left: 16.0),
                            child: Text(
                              'Selecione ao menos um destinatário (série, turma ou aluno).',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancelar')),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: poliedroBlue),
                  onPressed: () async {
                    final formIsValid = formKey.currentState!.validate();
                    final recipientsAreValid = selectedSeries.isNotEmpty ||
                        selectedTurmas.isNotEmpty ||
                        selectedAlunos.isNotEmpty;

                    if (!recipientsAreValid) {
                      setStateDialog(() {
                        _showRecipientError = true;
                      });
                    } else {
                      setStateDialog(() {
                        _showRecipientError = false;
                      });
                    }

                    if (!formIsValid || !recipientsAreValid) {
                      return;
                    }

                    final payload = {
                      'titulo': tituloController.text.trim(),
                      'conteudo': conteudoController.text.trim(),
                      'seriesAlvo': selectedSeries.toList(),
                      'turmasAlvo': selectedTurmas.toList(),
                      'alunosAlvo': selectedAlunos.toList(),
                    };

                    try {
                      if (isEditing) {
                        await _avisoService.updateAviso(aviso.id, payload);
                      } else {
                        await _avisoService.createAviso(payload);
                      }
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Aviso ${isEditing ? 'atualizado' : 'publicado'} com sucesso!'),
                              backgroundColor: Colors.green),
                        );
                      }
                      _fetchAvisos();
                      Navigator.pop(dialogContext);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Erro: $e'),
                              backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                  child: Text(isEditing ? 'Salvar' : 'Publicar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final bool isMobile = largura < 800;
    final EdgeInsets pagePadding =
        EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24, vertical: 16);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ProfessorHomeScreen())),
        ),
        title: const Text('Gerenciar Avisos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen())),
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<void>(
        future: _initialDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.error == null) {
            return FloatingActionButton.extended(
              onPressed: () => _adicionarOuEditarAviso(),
              backgroundColor: poliedroBlue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Novo aviso'),
            );
          }
          return FloatingActionButton.extended(
            onPressed: null,
            backgroundColor: Colors.grey,
            icon: const Icon(Icons.add),
            label: const Text('Novo aviso'),
          );
        },
      ),
      body: Padding(
        padding: pagePadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: FutureBuilder<void>(
              future: _initialDataFuture,
              builder: (context, initialDataSnapshot) {
                if (initialDataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: Text('Carregando dados de apoio...'));
                }
                if (initialDataSnapshot.hasError) {
                  return Center(
                      child: Text(
                          'Erro ao carregar dados de apoio: ${initialDataSnapshot.error}'));
                }

                return FutureBuilder<List<Aviso>>(
                  future: _avisosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Erro ao carregar avisos: ${snapshot.error}'));
                    }
                    final avisos = snapshot.data ?? [];

                    return RefreshIndicator(
                      onRefresh: () async => _fetchAvisos(),
                      child: avisos.isEmpty
                          ? const Center(
                              child: Text('Nenhum aviso publicado por você.',
                                  style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              itemCount: avisos.length,
                              itemBuilder: (context, index) {
                                final aviso = avisos[index];
                                final dataFormatada =
                                    DateFormat('dd/MM/yy \'às\' HH:mm', 'pt_BR')
                                        .format(aviso.createdAt.toLocal());

                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    leading: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: poliedroBlue,
                                      child: Icon(Icons.notifications,
                                          color: Colors.white, size: 22),
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                            child: Text(aviso.titulo,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15))),
                                        const SizedBox(width: 8),
                                        Text(dataFormatada,
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600])),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          aviso.conteudo,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.group_outlined,
                                                size: 15,
                                                color: Colors.grey[700]),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                _formatarAlvos(aviso),
                                                style: TextStyle(
                                                    fontSize: 11.5,
                                                    color: Colors.grey[700]),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Wrap(
                                      spacing: -8,
                                      children: [
                                        IconButton(
                                          tooltip: 'Editar aviso',
                                          icon: const Icon(Icons.edit_outlined,
                                              color: poliedroBlue, size: 20),
                                          onPressed: () =>
                                              _adicionarOuEditarAviso(
                                                  aviso: aviso),
                                        ),
                                        IconButton(
                                          tooltip: 'Excluir aviso',
                                          icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 20),
                                          onPressed: () => _removerAviso(
                                              aviso.id, aviso.titulo),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

  class _MultiSelectDialog<T> extends StatefulWidget {
    final String title;
    final List<T> allItems;
    final Set<String> selectedIds;
    final String Function(T) display;
    final String Function(T) id;
    final String? Function(T)? subtitle;

    const _MultiSelectDialog({
      required this.title,
      required this.allItems,
      required this.selectedIds,
      required this.display,
      required this.id,
      this.subtitle,
    });

    @override
    State<_MultiSelectDialog<T>> createState() => _MultiSelectDialogState<T>();
  }

  class _MultiSelectDialogState<T> extends State<_MultiSelectDialog<T>> {
    late final Set<String> _currentSelectedIds;
    late List<T> _filteredItems;
    final _searchController = TextEditingController();

    @override
    void initState() {
      super.initState();
      _currentSelectedIds = {...widget.selectedIds};
      _filteredItems = widget.allItems;
      _searchController.addListener(_filterItems);
    }

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    void _filterItems() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredItems = widget.allItems.where((item) {
          return widget.display(item).toLowerCase().contains(query);
        }).toList();
      });
    }

    void _onItemTapped(String itemId) {
      setState(() {
        if (_currentSelectedIds.contains(itemId)) {
          _currentSelectedIds.remove(itemId);
        } else {
          _currentSelectedIds.add(itemId);
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      return AlertDialog(
        title: Text(widget.title),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    final itemId = widget.id(item);
                    return CheckboxListTile(
                      title: Text(widget.display(item)),
                      subtitle: widget.subtitle != null
                          ? Text(widget.subtitle!(item) ?? '')
                          : null,
                      value: _currentSelectedIds.contains(itemId),
                      onChanged: (_) => _onItemTapped(itemId),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
              style: TextButton.styleFrom(foregroundColor: poliedroBlue),
              onPressed: () => Navigator.pop(context, _currentSelectedIds),
              child: const Text('Confirmar')),
        ],
      );
    }
  }