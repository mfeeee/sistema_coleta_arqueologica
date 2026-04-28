import 'package:flutter/material.dart';
import 'passo_1_identificacao_widget.dart';
import 'passo_3_detalhes_widget.dart';
import '../../viewmodels/coleta_form_notifier.dart';
import 'passo_2_artefatos_widget.dart';

class ColetaWizardWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final ColetaFormNotifier formNotifier;
  final VoidCallback onFinalizar;
  final VoidCallback onCancelar;

  const ColetaWizardWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.formNotifier,
    required this.onFinalizar,
    required this.onCancelar,
  });

  @override
  State<ColetaWizardWidget> createState() => _ColetaWizardWidgetState();
}

class _ColetaWizardWidgetState extends State<ColetaWizardWidget> {
  final PageController _pageController = PageController(initialPage: 0);

  final GlobalKey<FormState> _formKeyPasso1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPasso3 = GlobalKey<FormState>();

  void _irParaPagina(int index) {
    FocusScope.of(context).unfocus();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _avancarParaPasso2() {
    if (_formKeyPasso1.currentState?.validate() ?? false) {
      _irParaPagina(1);
    }
  }

  void _avancarParaPasso3() {
    if (widget.formNotifier.passo2Valido) {
      _irParaPagina(2);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione ao menos um tipo de artefato.'),
        ),
      );
    }
  }

  void _finalizarColeta() {
    if (_formKeyPasso3.currentState?.validate() ?? false) {
      widget.onFinalizar();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Passo1IdentificacaoWidget(
          formKey: _formKeyPasso1,
          latitude: widget.latitude,
          longitude: widget.longitude,
          formNotifier: widget.formNotifier,
          onAvancar: _avancarParaPasso2,
          onCancelar: widget.onCancelar,
        ),

        Passo2ArtefatosWidget(
          formNotifier: widget.formNotifier,
          onVoltar: () => _irParaPagina(0),
          onAvancar: _avancarParaPasso3,
        ),

        Passo3DetalhesWidget(
          formKey: _formKeyPasso3,
          formNotifier: widget.formNotifier,
          onVoltar: () => _irParaPagina(1),
          onFinalizar: _finalizarColeta,
        ),
      ],
    );
  }
}
