import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

import '../../constants/app_colors.dart';
import '../../services/avaliacao_service.dart';
import '../../services/materia_service.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';

class ProfessorAtividadesScreen extends StatefulWidget {
  const ProfessorAtividadesScreen({super.key});

  @override
  State<ProfessorAtividadesScreen> createState() =>
      _ProfessorAtividadesScreenState();
}

class _ProfessorAtividadesScreenState extends State<ProfessorAtividadesScreen> {
  final AvaliacaoService _avaliacaoService = AvaliacaoService();
  List<Map<String, dynamic>> _avaliacoes = [];
  bool _isLoading = true;

  // Cache para os nomes das matérias
  Map<String, String> _mapaNomesMaterias = {};

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    try {
      // Carrega matérias primeiro para ter os nomes
      final materias = await MateriaService().getMaterias();
      _mapaNomesMaterias = { for (var m in materias) m['_id']: m['nome'] };
      
      final avaliacoesFetched = await _avaliacaoService.getAvaliacoes();

      if (mounted) {
        setState(() {
          _avaliacoes = avaliacoesFetched;
          _isLoading = false;
        });
      }
    } catch (e) {
      developer.log('Erro ao carregar dados: $e', name: 'ProfessorAtividadesScreen');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados da página: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _mostrarFormulario([int? index]) async {
    final bool? sucesso = await showDialog<bool>(
      context: context,
      builder: (_) => _AvaliacaoFormDialog(
        avaliacao: index != null ? _avaliacoes[index] : null,
      ),
    );

    if (sucesso == true) {
      _carregarDados();
    }
  }
  
  Future<void> _removerAvaliacao(int index) async {
     final avaliacao = _avaliacoes[index];
     final id = avaliacao['_id'] as String;
     final nome = avaliacao['nome'] as String;

     final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Avaliação'),
        content: Text('Deseja realmente excluir a avaliação "$nome"?'),
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
      try {
        await _avaliacaoService.deleteAvaliacao(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Avaliação excluída com sucesso!'),
            backgroundColor: Colors.green,
          ));
        }
        _carregarDados();
      } catch (e) {
        developer.log('Erro ao excluir: $e', name: 'ProfessorAtividadesScreen');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erro ao excluir avaliação: $e'),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        title: const Text('Gerenciar Avaliações', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
        onPressed: () => _mostrarFormulario(),
        backgroundColor: poliedroBlue,
        icon: const Icon(Icons.add),
        label: const Text('Nova avaliação'),
      ),
      floatingActionButtonLocation: isMobile
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _carregarDados,
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 10 : 16),
              child: _avaliacoes.isEmpty
                  ? const Center(
                      child: Text('Nenhuma avaliação cadastrada.',
                          style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      itemCount: _avaliacoes.length,
                      itemBuilder: (context, index) {
                        final a = _avaliacoes[index];
                        final nome = a['nome']?.toString() ?? 'Sem nome';
                        final tipo = a['tipo']?.toString() ?? '-';
                        final materiaId = a['materia']?.toString() ?? '';
                        final nomeMateria = _mapaNomesMaterias[materiaId] ?? 'Matéria não encontrada';

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: isMobile ? 6 : 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: ExpansionTile(
                            title: Text(nome,
                                style: TextStyle(
                                    fontSize: isMobile ? 13.5 : 15,
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text('Tipo: $tipo • Matéria: $nomeMateria',
                                style: TextStyle(
                                    fontSize: isMobile ? 10.5 : 11.5,
                                    color: Colors.grey[700])),
                            childrenPadding:
                                EdgeInsets.all(isMobile ? 10 : 16),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Peso: ${a['peso']?.toString() ?? 'N/A'}',
                                    style: TextStyle(
                                        fontSize: isMobile ? 11.5 : 12.5,
                                        color: Colors.grey[800])),
                                  Expanded(
                                    child: Text('ID: ${a['_id']?.toString() ?? 'N/A'}',
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: isMobile ? 11.5 : 12.5,
                                          color: Colors.grey[800])),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                alignment: WrapAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _mostrarFormulario(index),
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Editar'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _removerAvaliacao(index),
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
        ),
    );
  }
}


// Widget separado para o formulário, para gerenciar seu próprio estado
class _AvaliacaoFormDialog extends StatefulWidget {
  final Map<String, dynamic>? avaliacao;
  const _AvaliacaoFormDialog({this.avaliacao});

  @override
  State<_AvaliacaoFormDialog> createState() => _AvaliacaoFormDialogState();
}

class _AvaliacaoFormDialogState extends State<_AvaliacaoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _avaliacaoService = AvaliacaoService();

  late final TextEditingController _nomeController;
  late final TextEditingController _pesoController;

  final List<String> _tipos = ['prova', 'trabalho'];
  late String _tipoSelecionado;
  
  List<Map<String, dynamic>> _materias = [];
  String? _materiaSelecionadaId;
  bool _isLoadingMaterias = true;

  @override
  void initState() {
    super.initState();
    final a = widget.avaliacao;
    _nomeController = TextEditingController(text: a?['nome']);
    _pesoController = TextEditingController(text: a?['peso']?.toString() ?? '1.0');
    _tipoSelecionado = a?['tipo'] ?? _tipos.first;
    _materiaSelecionadaId = a?['materia'];
    
    _carregarMaterias();
  }

  Future<void> _carregarMaterias() async {
    try {
      final materiasFetched = await MateriaService().getMaterias();
      if (mounted) {
        setState(() {
          _materias = materiasFetched;
          _isLoadingMaterias = false;
        });
      }
    } catch (e) {
       developer.log('Erro ao carregar matérias no form: $e', name: 'AvaliacaoForm');
       if (mounted) {
        setState(() => _isLoadingMaterias = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar matérias: $e'), backgroundColor: Colors.red),
        );
       }
    }
  }

  Future<void> _salvar() async {
    if (_formKey.currentState?.validate() != true) return;

    final data = {
      'nome': _nomeController.text,
      'tipo': _tipoSelecionado,
      'peso': double.tryParse(_pesoController.text.replaceAll(',', '.')) ?? 1.0,
      'materia': _materiaSelecionadaId,
    };

    try {
      if (widget.avaliacao != null) {
        await _avaliacaoService.updateAvaliacao(widget.avaliacao!['_id'], data);
      } else {
        await _avaliacaoService.createAvaliacao(data);
      }
      
      if (mounted) {
        Navigator.pop(context, true); // Retorna 'true' para indicar sucesso
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Avaliação ${widget.avaliacao != null ? 'atualizada' : 'criada'} com sucesso!'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      developer.log('Erro ao salvar: $e', name: 'AvaliacaoForm');
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao salvar avaliação: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.avaliacao != null ? 'Editar avaliação' : 'Nova avaliação'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da avaliação'),
                validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 10),
              
              // Dropdown de Matérias
              _isLoadingMaterias
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ))
                : DropdownButtonFormField<String>(
                    value: _materiaSelecionadaId,
                    isExpanded: true,
                    items: _materias.map((m) {
                      return DropdownMenuItem(
                        value: m['_id'] as String,
                        child: Text(m['nome'] as String),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _materiaSelecionadaId = v),
                    decoration: InputDecoration(
                      labelText: 'Matéria',
                      hintText: _materias.isEmpty ? 'Nenhuma matéria encontrada' : 'Selecione uma matéria',
                    ),
                    validator: (v) => (v == null) ? 'Selecione uma matéria' : null,
                  ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                items: _tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => setState(() => _tipoSelecionado = value ?? _tipos.first),
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(labelText: 'Peso'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obrigatório';
                  if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Número inválido';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
          onPressed: _salvar,
          child: Text(widget.avaliacao != null ? 'Salvar' : 'Criar'),
        ),
      ],
    );
  }
}
