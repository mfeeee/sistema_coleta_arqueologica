import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
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
  final int initialPage;

  const ColetaWizardWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.formNotifier,
    required this.onFinalizar,
    required this.onCancelar,
    this.initialPage = 0,
  });

  @override
  State<ColetaWizardWidget> createState() => _ColetaWizardWidgetState();
}

class _ColetaWizardWidgetState extends State<ColetaWizardWidget> {
  late final PageController _pageController;

  final GlobalKey<FormState> _formKeyPasso1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPasso3 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    widget.formNotifier.setPassoAtual(widget.initialPage);
  }

  void _irParaPagina(int index) {
    FocusScope.of(context).unfocus();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    widget.formNotifier.setPassoAtual(index);
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
        SnackBar(content: Text(context.l10n.coletaArtifactRequired)),
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
      onPageChanged: _onPageChanged,
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
