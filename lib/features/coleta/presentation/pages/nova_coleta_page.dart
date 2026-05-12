import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/services/conectividade_service.dart';
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
  late final ColetaFormNotifier _formNotifier;
  late final ConectividadeService _conectividadeService;
  bool _initialized = false;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final scope = AppScope.of(context);
    final proximidadeService = ProximidadeService(scope.coletaRepository);
    final geolocatorHelper = GeolocatorHelper();

    _formNotifier = ColetaFormNotifier(mediaService: scope.mediaService);
    _conectividadeService = scope.conectividadeService;

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
        child: Column(
          children: <Widget>[
            ValueListenableBuilder<bool>(
              valueListenable: _conectividadeService.estaOnline,
              builder: (context, online, _) {
                if (online) return const SizedBox.shrink();
                return const _BannerOffline();
              },
            ),
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ColetaStep step) {
    return switch (step) {
      ColetaStep.initial ||
      ColetaStep.gettingLocation ||
      ColetaStep.checkingProximity => const _CarregandoLocalizacaoBody(),

      ColetaStep.proximityAlert => AlertaProximidadeWidget(
        sitios: _viewModel.sitiosConflitantes,
        latAtual: _viewModel.coordenadaAtual?.latitude ?? 0.0,
        lonAtual: _viewModel.coordenadaAtual?.longitude ?? 0.0,
        onProsseguir: _viewModel.prosseguirParaFormularioIgnorandoAlerta,
      ),

      ColetaStep.fillingForm => ColetaWizardWidget(
        latitude: _viewModel.coordenadaAtual?.latitude ?? 0.0,
        longitude: _viewModel.coordenadaAtual?.longitude ?? 0.0,
        formNotifier: _formNotifier,
        onCancelar: () => Navigator.pop(context),
        onFinalizar: _saving ? () {} : () => _salvarColeta(),
      ),

      ColetaStep.error => _PainelErroGps(
        icone: Icons.error_outline,
        mensagem: _viewModel.errorMessage.value ?? 'Erro desconhecido.',
        labelPrimario: 'Tentar Novamente',
        onPrimario: _viewModel.tentarNovamente,
      ),

      ColetaStep.permissaoNegada => _PainelErroGps(
        icone: Icons.location_off_outlined,
        mensagem: _viewModel.errorMessage.value ?? '',
        labelPrimario: 'Conceder Permissão',
        onPrimario: _viewModel.tentarNovamente,
      ),

      ColetaStep.permissaoNegadaPermanentemente => _PainelErroGps(
        icone: Icons.lock_outlined,
        mensagem: _viewModel.errorMessage.value ?? '',
        labelPrimario: 'Abrir Configurações do App',
        onPrimario: _viewModel.abrirConfiguracoes,
      ),

      ColetaStep.gpsDesativado => _PainelErroGps(
        icone: Icons.gps_off,
        mensagem: _viewModel.errorMessage.value ?? '',
        labelPrimario: 'Ativar Localização',
        onPrimario: _viewModel.abrirConfiguracoesLocalizacao,
        labelSecundario: 'Tentar Novamente',
        onSecundario: _viewModel.tentarNovamente,
      ),
    };
  }

  Future<void> _salvarColeta() async {
    final scope = AppScope.of(context);

    final usuarioId = scope.authNotifier.userId;

    if (usuarioId == null || usuarioId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sessão expirada. Faça login novamente.')),
      );
      return;
    }

    final coord = _viewModel.coordenadaAtual;
    if (coord == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coordenadas não disponíveis.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final resultado = _formNotifier.toResult(
        lat: coord.latitude,
        lng: coord.longitude,
        usuarioId: usuarioId,
      );

      await scope.coletaRepository.salvar(resultado.coleta);
      await scope.bemMaterialRepository.salvar(resultado.bemMaterial);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coleta salva com sucesso!'),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
      Navigator.pop(context);
    } catch (e, stackTrace) {
      log(
        'Erro ao salvar coleta',
        error: e,
        stackTrace: stackTrace,
        name: 'NovaColetaPage',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar. Tente novamente.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _BannerOffline extends StatelessWidget {
  const _BannerOffline();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFEF3C7),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Row(
        children: <Widget>[
          Icon(Icons.wifi_off, size: 16, color: Color(0xFF92400E)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Você está offline. A coleta será salva localmente.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF92400E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarregandoLocalizacaoBody extends StatelessWidget {
  const _CarregandoLocalizacaoBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text('Sincronizando coordenadas e verificando radar...'),
        ],
      ),
    );
  }
}

class _PainelErroGps extends StatelessWidget {
  const _PainelErroGps({
    required this.icone,
    required this.mensagem,
    required this.labelPrimario,
    required this.onPrimario,
    this.labelSecundario,
    this.onSecundario,
  });

  final IconData icone;
  final String mensagem;
  final String labelPrimario;
  final VoidCallback onPrimario;
  final String? labelSecundario;
  final VoidCallback? onSecundario;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(onPressed: onPrimario, child: Text(labelPrimario)),
            if (labelSecundario != null && onSecundario != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onSecundario,
                child: Text(labelSecundario!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
