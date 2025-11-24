import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_colors.dart';

class CriarMateriaScreen extends StatefulWidget {
  const CriarMateriaScreen({super.key});

  @override
  State<CriarMateriaScreen> createState() => _CriarMateriaScreenState();
}

class _CriarMateriaScreenState extends State<CriarMateriaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _pesoProvaController = TextEditingController();
  final _pesoTrabalhoController = TextEditingController();
  final _mediaParaPassarController = TextEditingController(text: '6');
  final _notaMaximaController = TextEditingController(text: '10');

  @override
  void dispose() {
    _nomeController.dispose();
    _pesoProvaController.dispose();
    _pesoTrabalhoController.dispose();
    _mediaParaPassarController.dispose();
    _notaMaximaController.dispose();
    super.dispose();
  }

  void _criarMateria() {
    if (_formKey.currentState!.validate()) {
      final materia = {
        'nome': _nomeController.text,
        'pesoProva': double.tryParse(_pesoProvaController.text),
        'pesoTrabalho': double.tryParse(_pesoTrabalhoController.text),
        'mediaParaPassar': double.tryParse(_mediaParaPassarController.text),
        'notaMaxima': double.tryParse(_notaMaximaController.text),
      };

      // TODO: Implementar a chamada à API para criar a matéria no backend.
      // Por enquanto, apenas exibimos os dados no console e um snackbar.
      print('Nova matéria criada (simulação): $materia');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Matéria criada com sucesso! (Simulação)'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Nova Matéria'),
        backgroundColor: poliedroBlue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextFormField(
                    controller: _nomeController,
                    label: 'Nome da Matéria',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'O nome é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _pesoProvaController,
                    label: 'Peso da Prova (Ex: 0.6)',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (value) => _validaPeso(value, 'prova'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _pesoTrabalhoController,
                    label: 'Peso do Trabalho (Ex: 0.4)',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                     inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (value) => _validaPeso(value, 'trabalho'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _mediaParaPassarController,
                    label: 'Média para Passar',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A média é obrigatória.';
                      }
                      final nota = int.tryParse(value);
                      if (nota == null || nota < 0 || nota > 10) {
                        return 'Insira um valor entre 0 e 10.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _notaMaximaController,
                    label: 'Nota Máxima',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A nota máxima é obrigatória.';
                      }
                      final nota = int.tryParse(value);
                      if (nota == null || nota <= 0) {
                        return 'A nota deve ser maior que zero.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _criarMateria,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: poliedroBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Salvar Matéria', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validaPeso(String? value, String tipo) {
    if (value == null || value.isEmpty) {
      return 'O peso do $tipo é obrigatório.';
    }
    final peso = double.tryParse(value);
    if (peso == null || peso < 0 || peso > 1) {
      return 'O peso deve ser um valor entre 0 e 1.';
    }
    return null;
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
