import 'package:flutter/material.dart';
import 'passo_1_identificacao_widget.dart';
import 'passo_2_detalhes_widget.dart';
import '../../viewmodels/coleta_form_notifier.dart';

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
  // TODO: Instanciar PageController
  final PageController _pageController = PageController(initialPage: 0);

  // TODO: Criar GlobalKeys para os formulários
  final GlobalKey<FormState> _formKeyPasso1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPasso2 = GlobalKey<FormState>();

  // TODO: Criar TextEditingControllers
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _nomesPopularesController =
      TextEditingController();
  final TextEditingController _sinteseController = TextEditingController();

  String? _naturezaSelecionada;
  String? _tipoSelecionado;
  String? _estadoConservacao = 'Bom';

  @override
  void dispose() {
    _pageController.dispose();
    _nomeController.dispose();
    _nomesPopularesController.dispose();
    _sinteseController.dispose();
    super.dispose();
  }

  void _avancarParaPasso2() {
    // TODO: Validar form do Passo 1 e mover o PageController para a próxima página
    if (_formKeyPasso1.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      _pageController.nextPage(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void _voltarParaPasso1() {
    // TODO: Mover o PageController para a página anterior
    FocusScope.of(context).unfocus();
    _pageController.previousPage(
      curve: Curves.easeInOut,
      duration: const Duration(microseconds: 300),
    );
  }

  void _finalizarColeta() {
    // TODO: Validar form do Passo 2 e chamar widget.onFinalizar()
    if (_formKeyPasso2.currentState?.validate() ?? false) {
      // TODO: salvar no bd local
      widget.onFinalizar();
    }
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
          nomeController: _nomeController,
          nomesPopularesController: _nomesPopularesController,
          naturezaSelecionada: _naturezaSelecionada,
          onNaturezaChanged: (val) {
            setState(() => _naturezaSelecionada = val);
          },
          tipoSelecionado: _tipoSelecionado,
          onTipoSelecionadoChanged: (val) {
            setState(() => _tipoSelecionado = val);
          },
          estadoConservacao: _estadoConservacao,
          onEstadoConservacaoChanged: (val) {
            setState(() => _estadoConservacao = val);
          },
          onAvancar: _avancarParaPasso2,
          onCancelar: widget.onCancelar,
        ),

        Passo2DetalhesWidget(
          formKey: _formKeyPasso2,
          sinteseController: _sinteseController,
          formNotifier: widget.formNotifier,
          onVoltar: _voltarParaPasso1,
          onFinalizar: _finalizarColeta,
        ),
      ],
    );
  }
}
