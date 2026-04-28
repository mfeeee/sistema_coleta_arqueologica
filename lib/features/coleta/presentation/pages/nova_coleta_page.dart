import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coleta_form_notifier.dart';
import '../../../../core/di/app_scope.dart';
import '../../../../core/utils/geolocator_helper.dart';
import '../../domain/services/proximidade_service.dart';
import '../viewmodels/coleta_viewmodel.dart';
import '../widgets/alerta_proximidade_widget.dart';
import '../widgets/wizard/coleta_wizard_widget.dart';

class NovaColetaPage extends StatefulWidget {
  const NovaColetaPage({super.key});

  @override
  State<NovaColetaPage> createState() => _NovaColetaPageState();
}

class _NovaColetaPageState extends State<NovaColetaPage> {
  late final ColetaViewModel _viewModel;
  bool _initialized = false;
  late final ColetaFormNotifier _formNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final repository = AppScope.of(context).coletaRepository;
    final proximidadeService = ProximidadeService(repository);
    final geolocatorHelper = GeolocatorHelper();
    final mediaService = AppScope.of(context).mediaService;

    _formNotifier = ColetaFormNotifier(mediaService: mediaService);

    _viewModel = ColetaViewModel(
      proximidadeService: proximidadeService,
      geolocatorHelper: geolocatorHelper,
    );
    _viewModel.iniciarMapeamento();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _formNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1.0),
        ),
        title: const Text(
          'Nova Coleta - Passo 1/3',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.45,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {
              // TODO: Salvar rascunho
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<ColetaStep>(
          valueListenable: _viewModel.stepNotifier,
          builder: (context, step, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildBody(step),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(ColetaStep step) {
    return switch (step) {
      ColetaStep.initial ||
      ColetaStep.gettingLocation ||
      ColetaStep.checkingProximity => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text('Sincronizando coordenadas e verificando radar...'),
          ],
        ),
      ),

      ColetaStep.proximityAlert => AlertaProximidadeWidget(
        sitios: _viewModel.sitiosConflitantes,
        onProsseguir: _viewModel.prosseguirParaFormularioIgnorandoAlerta,
      ),

      // ESTADO DE FORMULÁRIO (Área limpa ou alerta ignorado)
      ColetaStep.fillingForm => ColetaWizardWidget(
        latitude: _viewModel.coordenadaAtual?.latitude ?? 0.0,
        longitude: _viewModel.coordenadaAtual?.longitude ?? 0.0,
        formNotifier: _formNotifier,
        onCancelar: () => Navigator.pop(context),
        onFinalizar: () {
          // TODO: No futuro, aqui chamaremos a gravação final no SQLite
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sítio registado com sucesso no cache offline!'),
            ),
          );
          Navigator.pop(context);
        },
      ),

      // ESTADO DE ERRO (GPS desligado ou sem permissão)
      ColetaStep.error => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_viewModel.errorMessage.value ?? 'Erro desconhecido'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _viewModel.tentarNovamente,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      ),
    };
  }
}
