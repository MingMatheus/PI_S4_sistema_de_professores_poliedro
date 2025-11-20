// lib/screens/turmas_professor_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_colors.dart';
import '../home/professor_home_screen.dart';
import '../login/login_screen.dart';
import '../../utils/url.dart';

class ProfessorTurmasScreen extends StatefulWidget {
  const ProfessorTurmasScreen({super.key});

  @override
  State<ProfessorTurmasScreen> createState() => _ProfessorTurmasScreenState();
}

class _ProfessorTurmasScreenState extends State<ProfessorTurmasScreen> {
  // BASE URLs (ajuste se necessário)
  final String baseSeries = "http://localhost:8080/api/series";
  final String baseTurmas = "http://localhost:8080/api/turmas";
  final String baseAlunos = "http://localhost:8080/api/alunos";
  final String baseAuthCadastroAlunos = "http://localhost:8080/api/auth/cadastro/alunos";

  Map<String, String>? headers;

  List<dynamic> series = [];
  List<dynamic> turmas = [];
  List<dynamic> alunos = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _inicializaTudo();
  }

  Future<void> _inicializaTudo() async {
    await _configurarAutenticacao();
    carregarTudo();
  }

  Future<void> _configurarAutenticacao() async {
    // Busca o token
    final token = await getToken(); 

    // Verificação de segurança: Se a tela foi fechada antes do token chegar, para tudo.
    if (!mounted) return; 

    if(token == null)
    {
      // --- CASO: NÃO TEM TOKEN (Redireciona) ---
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen())
      );
    }
    else
    {
      // --- CASO: TEM TOKEN (Configura os headers) ---
      setState(() {
        headers = {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        };
      });
    }
  }

  // ----------------------
  // CARREGAMENTO
  // ----------------------
  Future<void> carregarTudo() async {
    setState(() => loading = true);
    await Future.wait([carregarSeries(), carregarTurmas(), carregarAlunos()]);
    setState(() => loading = false);
  }

  Future<void> carregarSeries() async {
    try {
      final res = await http.get(Uri.parse(baseSeries), headers: headers);
      if (res.statusCode == 200) {
        final map = jsonDecode(res.body);
        setState(() => series = map["series"] ?? []);
      } else {
        debugPrint("carregarSeries: ${res.statusCode} ${res.body}");
        _showSnack("Erro ao carregar séries (${res.statusCode})");
      }
    } catch (e) {
      debugPrint("Erro conexão séries: $e");
      _showSnack("Erro de conexão (séries)");
    }
  }

  Future<void> carregarTurmas() async {
    try {
      final res = await http.get(Uri.parse(baseTurmas), headers: headers);
      if (res.statusCode == 200) {
        final map = jsonDecode(res.body);
        setState(() => turmas = map["turmas"] ?? []);
      } else {
        debugPrint("carregarTurmas: ${res.statusCode} ${res.body}");
        _showSnack("Erro ao carregar turmas (${res.statusCode})");
      }
    } catch (e) {
      debugPrint("Erro conexão turmas: $e");
      _showSnack("Erro de conexão (turmas)");
    }
  }

  Future<void> carregarAlunos() async {
    try {
      final res = await http.get(Uri.parse(baseAlunos), headers: headers);
      if (res.statusCode == 200) {
        final map = jsonDecode(res.body);
        setState(() => alunos = map["alunos"] ?? []);
      } else {
        debugPrint("carregarAlunos: ${res.statusCode} ${res.body}");
        _showSnack("Erro ao carregar alunos (${res.statusCode})");
      }
    } catch (e) {
      debugPrint("Erro conexão alunos: $e");
      _showSnack("Erro de conexão (alunos)");
    }
  }

  // ----------------------
  // SÉRIE CRUD
  // ----------------------
  Future<void> adicionarSerie() async {
    final nomeCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova Série"),
        content: TextField(controller: nomeCtrl, decoration: const InputDecoration(hintText: "Nome da série")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () async {
              final nome = nomeCtrl.text.trim();
              if (nome.isEmpty) return;
              Navigator.pop(context);
              final res = await http.post(Uri.parse(baseSeries), headers: headers, body: jsonEncode({"nome": nome}));
              if (res.statusCode == 201) {
                await carregarSeries();
                _showSnack("Série criada");
              } else {
                debugPrint("adicionarSerie: ${res.statusCode} ${res.body}");
                _showSnack("Falha ao criar série (${res.statusCode})");
              }
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  Future<void> editarSerie(dynamic serie) async {
    final nomeCtrl = TextEditingController(text: serie["nome"]);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Série"),
        content: TextField(controller: nomeCtrl, decoration: const InputDecoration(hintText: "Novo nome")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () async {
              final novo = nomeCtrl.text.trim();
              if (novo.isEmpty) return;
              Navigator.pop(context);
              final res = await http.put(Uri.parse("$baseSeries/${serie['_id']}"), headers: headers, body: jsonEncode({"nome": novo}));
              if (res.statusCode == 200) {
                await carregarSeries();
                _showSnack("Série atualizada");
              } else {
                debugPrint("editarSerie: ${res.statusCode} ${res.body}");
                _showSnack("Falha ao atualizar série (${res.statusCode})");
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Future<void> removerSerie(dynamic serie) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir Série"),
        content: Text('Excluir "${serie["nome"]}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: () => Navigator.pop(context, true), child: const Text("Excluir")),
        ],
      ),
    );
    if (ok != true) return;
    final res = await http.delete(Uri.parse("$baseSeries/${serie['_id']}"), headers: headers);
    if (res.statusCode == 200) {
      await carregarSeries();
      _showSnack("Série excluída");
    } else {
      debugPrint("removerSerie: ${res.statusCode} ${res.body}");
      _showSnack("Falha ao excluir série (${res.statusCode})");
    }
  }

  // ----------------------
  // TURMA CRUD
  // ----------------------
  Future<void> adicionarTurma({String? presetSerieId}) async {
    final nomeCtrl = TextEditingController();
    String? serieId = presetSerieId ?? (series.isNotEmpty ? series.first["_id"] : null);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova Turma"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeCtrl, decoration: const InputDecoration(hintText: "Nome da turma")),
            const SizedBox(height: 8),
            if (series.isNotEmpty)
              DropdownButtonFormField<String>(
                value: serieId,
                items: series.map<DropdownMenuItem<String>>((s) => DropdownMenuItem(value: s["_id"], child: Text(s["nome"]))).toList(),
                onChanged: (v) => serieId = v,
                decoration: const InputDecoration(labelText: "Série"),
              )
            else
              const Text("Crie uma série primeiro."),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () async {
              final nome = nomeCtrl.text.trim();
              if (nome.isEmpty) return;
              Navigator.pop(context);
              final res = await http.post(Uri.parse(baseTurmas), headers: headers, body: jsonEncode({"nome": nome, "serie": serieId}));
              if (res.statusCode == 201) {
                await carregarTurmas();
                _showSnack("Turma criada");
              } else {
                debugPrint("adicionarTurma: ${res.statusCode} ${res.body}");
                _showSnack("Falha ao criar turma (${res.statusCode})");
              }
            },
            child: const Text("Adicionar"),
          )
        ],
      ),
    );
  }

  Future<void> editarTurma(dynamic turma) async {
    final nomeCtrl = TextEditingController(text: turma["nome"]);
    String? serieId = turma["serie"] is Map ? turma["serie"]["_id"] : turma["serie"];

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Turma"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeCtrl, decoration: const InputDecoration(hintText: "Nome da turma")),
            const SizedBox(height: 8),
            if (series.isNotEmpty)
              DropdownButtonFormField<String>(
                value: serieId,
                items: series.map<DropdownMenuItem<String>>((s) => DropdownMenuItem(value: s["_id"], child: Text(s["nome"]))).toList(),
                onChanged: (v) => serieId = v,
                decoration: const InputDecoration(labelText: "Série"),
              )
            else
              const Text("Nenhuma série cadastrada."),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () async {
              final nome = nomeCtrl.text.trim();
              if (nome.isEmpty) return;
              Navigator.pop(context);
              final res = await http.put(Uri.parse("$baseTurmas/${turma['_id']}"), headers: headers, body: jsonEncode({"nome": nome, "serie": serieId}));
              if (res.statusCode == 200) {
                await carregarTurmas();
                _showSnack("Turma atualizada");
              } else {
                debugPrint("editarTurma: ${res.statusCode} ${res.body}");
                _showSnack("Falha ao atualizar turma (${res.statusCode})");
              }
            },
            child: const Text("Salvar"),
          )
        ],
      ),
    );
  }

  Future<void> removerTurma(dynamic turma) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir Turma"),
        content: Text('Excluir "${turma["nome"]}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: () => Navigator.pop(context, true), child: const Text("Excluir")),
        ],
      ),
    );
    if (ok != true) return;
    final res = await http.delete(Uri.parse("$baseTurmas/${turma['_id']}"), headers: headers);
    if (res.statusCode == 200) {
      await carregarTurmas();
      await carregarAlunos();
      _showSnack("Turma excluída");
    } else {
      debugPrint("removerTurma: ${res.statusCode} ${res.body}");
      _showSnack("Falha ao excluir turma (${res.statusCode})");
    }
  }

  // ----------------------
  // ALUNO CRUD
  // ----------------------
  Future<void> adicionarAluno({String? turmaId}) async {
    final nomeCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final senhaCtrl = TextEditingController();
    final raCtrl = TextEditingController();
    String? selectedTurmaId = turmaId ?? (turmas.isNotEmpty ? turmas.first["_id"] : null);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Novo Aluno"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeCtrl, decoration: const InputDecoration(hintText: "Nome")),
              TextField(controller: emailCtrl, decoration: const InputDecoration(hintText: "Email")),
              TextField(controller: senhaCtrl, decoration: const InputDecoration(hintText: "Senha")),
              TextField(controller: raCtrl, decoration: const InputDecoration(hintText: "RA")),
              const SizedBox(height: 8),
              if (turmas.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: selectedTurmaId,
                  items: turmas.map<DropdownMenuItem<String>>((t) => DropdownMenuItem(value: t["_id"], child: Text(t["nome"]))).toList(),
                  onChanged: (v) => selectedTurmaId = v,
                  decoration: const InputDecoration(labelText: "Turma (opcional)"),
                )
              else
                const Text("Nenhuma turma cadastrada. Crie uma turma primeiro."),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () async {
              final nome = nomeCtrl.text.trim();
              final email = emailCtrl.text.trim();
              final senha = senhaCtrl.text;
              final ra = raCtrl.text.trim();
              if (nome.isEmpty || email.isEmpty || senha.isEmpty || ra.isEmpty) return;

              Navigator.pop(context);

              // 1) Criar via rota de cadastro (auth)
              final resCadastro = await http.post(
                Uri.parse(baseAuthCadastroAlunos),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({"nome": nome, "email": email, "senha": senha, "ra": ra}),
              );

              if (resCadastro.statusCode == 201 || resCadastro.statusCode == 200) {
                // 2) Recarrega alunos e vincula turma se necessário
                await carregarAlunos();
                final novo = alunos.firstWhere((a) => (a["ra"]?.toString() ?? "") == ra, orElse: () => null);
                if (novo != null && selectedTurmaId != null) {
                  final resUpd = await http.put(Uri.parse("$baseAlunos/${novo['_id']}"), headers: headers, body: jsonEncode({"turma": selectedTurmaId}));
                  if (resUpd.statusCode == 200) {
                    await carregarAlunos();
                    _showSnack("Aluno criado e vinculado");
                    return;
                  } else {
                    debugPrint("vincular turma: ${resUpd.statusCode} ${resUpd.body}");
                  }
                }
                _showSnack("Aluno criado");
              } else {
                debugPrint("adicionarAluno: ${resCadastro.statusCode} ${resCadastro.body}");
                _showSnack("Falha ao criar aluno (${resCadastro.statusCode})");
              }
            },
            child: const Text("Criar"),
          ),
        ],
      ),
    );
  }

  Future<void> editarAluno(dynamic aluno) async {
    final nomeCtrl = TextEditingController(text: aluno["nome"]);
    final emailCtrl = TextEditingController(text: aluno["email"]);
    final raCtrl = TextEditingController(text: aluno["ra"]);
    String? turmaId = aluno["turma"] is Map ? aluno["turma"]["_id"] : aluno["turma"];

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Aluno"),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nomeCtrl, decoration: const InputDecoration(hintText: "Nome")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(hintText: "Email")),
            TextField(controller: raCtrl, decoration: const InputDecoration(hintText: "RA")),
            const SizedBox(height: 8),
            if (turmas.isNotEmpty)
              DropdownButtonFormField<String>(
                value: turmaId,
                items: turmas.map<DropdownMenuItem<String>>((t) => DropdownMenuItem(value: t["_id"], child: Text(t["nome"]))).toList(),
                onChanged: (v) => turmaId = v,
                decoration: const InputDecoration(labelText: "Turma"),
              )
            else
              const Text("Nenhuma turma cadastrada."),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue),
            onPressed: () async {
              Navigator.pop(context);
              final body = {"nome": nomeCtrl.text.trim(), "email": emailCtrl.text.trim(), "ra": raCtrl.text.trim(), "turma": turmaId};
              final res = await http.put(Uri.parse("$baseAlunos/${aluno['_id']}"), headers: headers, body: jsonEncode(body));
              if (res.statusCode == 200) {
                await carregarAlunos();
                _showSnack("Aluno atualizado");
              } else {
                debugPrint("editarAluno: ${res.statusCode} ${res.body}");
                _showSnack("Falha ao atualizar aluno (${res.statusCode})");
              }
            },
            child: const Text("Salvar"),
          )
        ],
      ),
    );
  }

  Future<void> removerAluno(dynamic aluno) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir Aluno"),
        content: Text('Excluir "${aluno["nome"]}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: () => Navigator.pop(context, true), child: const Text("Excluir")),
        ],
      ),
    );
    if (ok != true) return;
    final res = await http.delete(Uri.parse("$baseAlunos/${aluno['_id']}"), headers: headers);
    if (res.statusCode == 200) {
      await carregarAlunos();
      _showSnack("Aluno excluído");
    } else {
      debugPrint("removerAluno: ${res.statusCode} ${res.body}");
      _showSnack("Falha ao excluir aluno (${res.statusCode})");
    }
  }

  // ----------------------
  // UTIL / UI
  // ----------------------
  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ----------------------
  // BUILD - tela única hierárquica
  // ----------------------
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
              MaterialPageRoute(builder: (_) => const ProfessorHomeScreen()),
            );
          },
        ),
        title: const Text('Gerenciar: Séries · Turmas · Alunos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),

      floatingActionButton: SizedBox(
        height: isMobile ? 44 : 46,
        child: FloatingActionButton.extended(
          onPressed: adicionarSerie,
          backgroundColor: poliedroBlue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add, size: 22),
          label: Text('Nova série', style: TextStyle(fontSize: isMobile ? 13 : 14, fontWeight: FontWeight.w600)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      floatingActionButtonLocation: isMobile ? FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat,

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: carregarTudo,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 10 : 16),
                child: series.isEmpty
                    ? Center(
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          const Text('Nenhuma série cadastrada.'),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(onPressed: adicionarSerie, icon: const Icon(Icons.add), label: const Text('Criar primeira série'), style: ElevatedButton.styleFrom(backgroundColor: poliedroBlue)),
                        ]),
                      )
                    : ListView.builder(
                        itemCount: series.length,
                        itemBuilder: (context, sIndex) {
                          final serie = series[sIndex];
                          final serieId = serie["_id"];
                          final turmasDaSerie = turmas.where((t) {
                            final s = t["serie"];
                            final id = s is Map ? s["_id"] : s;
                            return id == serieId;
                          }).toList();

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: isMobile ? 6 : 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 6),
                              leading: const Icon(Icons.school, color: poliedroBlue),
                              title: Text(serie["nome"], style: TextStyle(fontWeight: FontWeight.w600, fontSize: isMobile ? 14 : 16)),
                              childrenPadding: EdgeInsets.fromLTRB(isMobile ? 12 : 16, 8, isMobile ? 12 : 16, 10),
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text('Turmas (${turmasDaSerie.length})', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 13 : 14)),
                                  Row(children: [
                                    TextButton.icon(onPressed: () => adicionarTurma(presetSerieId: serieId), icon: Icon(Icons.class_outlined, color: poliedroBlue), label: Text('Nova turma', style: TextStyle(color: poliedroBlue))),
                                    const SizedBox(width: 8),
                                    TextButton.icon(onPressed: () => editarSerie(serie), icon: Icon(Icons.edit_outlined, color: poliedroBlue), label: Text('Editar série', style: TextStyle(color: poliedroBlue))),
                                    const SizedBox(width: 8),
                                    TextButton.icon(onPressed: () => removerSerie(serie), icon: Icon(Icons.delete_outline, color: Colors.redAccent), label: Text('Excluir série', style: TextStyle(color: Colors.redAccent))),
                                  ])
                                ]),
                                const SizedBox(height: 6),

                                if (turmasDaSerie.isEmpty)
                                  Padding(padding: EdgeInsets.only(bottom: isMobile ? 4 : 6), child: Text('Nenhuma turma nesta série.', style: TextStyle(fontSize: isMobile ? 11 : 12, color: Colors.grey)))
                                else
                                  ...turmasDaSerie.map((turma) {
                                    final turmaId = turma["_id"];
                                    final alunosDaTurma = alunos.where((a) {
                                      final t = a["turma"];
                                      final id = t is Map ? t["_id"] : t;
                                      return id == turmaId;
                                    }).toList();

                                    return Card(
                                      margin: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 6),
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 6),
                                        leading: const Icon(Icons.class_, color: poliedroBlue),
                                        title: Text(turma["nome"], style: TextStyle(fontWeight: FontWeight.w600, fontSize: isMobile ? 13 : 14)),
                                        childrenPadding: EdgeInsets.fromLTRB(isMobile ? 12 : 16, 8, isMobile ? 12 : 16, 10),
                                        children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text('Alunos (${alunosDaTurma.length})', style: TextStyle(fontWeight: FontWeight.bold)),
                                            Row(children: [
                                              TextButton.icon(onPressed: () => adicionarAluno(turmaId: turmaId), icon: Icon(Icons.person_add_alt_1_outlined, color: poliedroBlue), label: Text('Adicionar aluno', style: TextStyle(color: poliedroBlue))),
                                              const SizedBox(width: 8),
                                              TextButton.icon(onPressed: () => editarTurma(turma), icon: Icon(Icons.edit_outlined, color: poliedroBlue), label: Text('Editar turma', style: TextStyle(color: poliedroBlue))),
                                              const SizedBox(width: 8),
                                              TextButton.icon(onPressed: () => removerTurma(turma), icon: Icon(Icons.delete_outline, color: Colors.redAccent), label: Text('Excluir turma', style: TextStyle(color: Colors.redAccent))),
                                            ])
                                          ]),
                                          const SizedBox(height: 6),
                                          if (alunosDaTurma.isEmpty)
                                            const Padding(padding: EdgeInsets.all(12), child: Text('Nenhum aluno nesta turma.', style: TextStyle(color: Colors.grey)))
                                          else
                                            ...alunosDaTurma.map((al) {
                                              return ListTile(
                                                dense: true,
                                                title: Text(al["nome"] ?? al["email"] ?? "—"),
                                                subtitle: Text("RA: ${al["ra"] ?? '-'}"),
                                                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                                  IconButton(icon: const Icon(Icons.edit_outlined, color: poliedroBlue), onPressed: () => editarAluno(al)),
                                                  IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => removerAluno(al)),
                                                ]),
                                              );
                                            }).toList()
                                        ],
                                      ),
                                    );
                                  }).toList(),

                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(onPressed: () => adicionarTurma(presetSerieId: serieId), icon: const Icon(Icons.add, color: poliedroBlue), label: const Text('Adicionar Turma', style: TextStyle(color: poliedroBlue))),
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
