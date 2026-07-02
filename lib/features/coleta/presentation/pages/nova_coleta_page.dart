import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/core/services/conectividade_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coleta_form_notifier.dart';
import '../../../../core/di/app_scope.dart';
import '../../../../core/utils/geolocator_helper.dart';
import '../../domain/services/proximidade_service.dart';
import '../viewmodels/coleta_viewmodel.dart';
import '../widgets/alerta_proximidade_widget.dart';
import '../widgets/wizard/coleta_wizard_widget.dart';

class NovaColetaPage extends StatefulWidget {
  final String? id;
  const NovaColetaPage({super.key, this.id});

  @override
  State<NovaColetaPage> createState() => _NovaColetaPageState();
}

class _NovaColetaPageState extends State<NovaColetaPage> {
  late final ColetaViewModel _viewModel;
  late final ColetaFormNotifier _formNotifier;
  late final ConectividadeService _conectividadeService;
  bool _initialized = false;
  bool _saving = false;
  bool _salvouComSucesso = false;
  bool _descartouRascunho = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final scope = AppScope.of(context);

    final proximidadeService = ProximidadeService(scope.coletaRepository);
    final geolocatorHelper = GeolocatorHelper();

    _formNotifier = ColetaFormNotifier(
      id: widget.id,
      mediaService: scope.mediaService,
      uploadMidiaUseCase: scope.uploadMidiaUseCase,
    );

    if (widget.id != null) {
      _carregarColetaExistente(widget.id!);
    }

    _conectividadeService = scope.conectividadeService;

    _viewModel = ColetaViewModel(
      proximidadeService: proximidadeService,
      geolocatorHelper: geolocatorHelper,
    );
    _viewModel.iniciarMapeamento();
  }

  Future<void> _carregarColetaExistente(String id) async {
    setState(() => _saving = true);
    try {
      final scope = AppScope.of(context);
      final coleta = await scope.coletaRepository.getById(id);
      if (coleta != null) {
        _formNotifier.restaurarDeEntity(coleta);
      }
    } catch (e, st) {
      log('Erro ao carregar coleta existente', error: e, stackTrace: st);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    if (!_salvouComSucesso &&
        !_descartouRascunho &&
        _initialized &&
        _formNotifier.modificado) {
      _salvarRascunhoSilencioso();
    }
    _viewModel.dispose();
    _formNotifier.dispose();
    super.dispose();
  }

  Future<void> _salvarRascunhoSilencioso() async {
    try {
      log(
        'Salvamento automático em dispose desativado para SQLite, utilize o botão Salvar Rascunho ou a interceptação de pop.',
        name: 'NovaColetaPage',
      );
    } catch (e) {
      log('Erro no salvamento silencioso', error: e);
    }
  }

  Future<void> _onWillPop() async {
    if (_saving) return;

    if (!_formNotifier.modificado) {
      Navigator.of(context).pop();
      return;
    }

    final l10n = context.l10n;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.coletaExitTitle),
        content: Text(l10n.coletaExitContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text(l10n.coletaActionContinueEditing.toUpperCase()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: Text(
              l10n.coletaActionDiscard.toUpperCase(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: Text(l10n.coletaActionSaveDraft.toUpperCase()),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (result == 'save') {
      await _salvarRascunho();
    } else if (result == 'discard') {
      _descartouRascunho = true;
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(height: 1.0),
          ),
          title: AnimatedBuilder(
            animation: _formNotifier,
            builder: (context, _) {
              return ValueListenableBuilder<ColetaStep>(
                valueListenable: _viewModel.stepNotifier,
                builder: (context, step, _) {
                  final String titulo;
                  if (widget.id != null) {
                    titulo = l10n.coletaRetakeTitle;
                  } else if (step == ColetaStep.fillingForm) {
                    titulo = l10n.coletaStepPrefix(
                      _formNotifier.passoAtual + 1,
                      3,
                    );
                  } else {
                    titulo = l10n.coletaNewTitle;
                  }
                  return Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.45,
                    ),
                  );
                },
              );
            },
          ),
          actions: [
            if (_saving)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: l10n.coletaActionSaveDraft,
                onPressed: _salvarRascunho,
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
      ),
    );
  }

  Widget _buildBody(ColetaStep step) {
    final l10n = context.l10n;
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
        initialPage: _formNotifier.passoRestauracao,
        onCancelar: () => Navigator.maybePop(context),
        onFinalizar: _saving ? () {} : () => _salvarColeta(),
      ),

      ColetaStep.error => _PainelErroGps(
        icone: Icons.error_outline,
        mensagem: _viewModel.errorMessage.value ?? l10n.commonError,
        labelPrimario: l10n.coletaRetryGps,
        onPrimario: _viewModel.tentarNovamente,
      ),

      ColetaStep.permissaoNegada => _PainelErroGps(
        icone: Icons.location_off_outlined,
        mensagem: _viewModel.errorMessage.value ?? '',
        labelPrimario: l10n.coletaGrantPermission,
        onPrimario: _viewModel.tentarNovamente,
      ),

      ColetaStep.permissaoNegadaPermanentemente => _PainelErroGps(
        icone: Icons.lock_outlined,
        mensagem: _viewModel.errorMessage.value ?? '',
        labelPrimario: l10n.coletaOpenAppSettings,
        onPrimario: _viewModel.abrirConfiguracoes,
      ),

      ColetaStep.gpsDesativado => _PainelErroGps(
        icone: Icons.gps_off,
        mensagem: _viewModel.errorMessage.value ?? '',
        labelPrimario: l10n.coletaEnableLocation,
        onPrimario: _viewModel.abrirConfiguracoesLocalizacao,
        labelSecundario: l10n.coletaRetryGps,
        onSecundario: _viewModel.tentarNovamente,
      ),
    };
  }

  Future<void> _salvarRascunho() async {
    final l10n = context.l10n;
    if (!_formNotifier.modificado && _formNotifier.temDadosRascunho) {
      Navigator.of(context).pop();
      return;
    }

    if (!_formNotifier.temDadosRascunho) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _saving = true);

    try {
      final messenger = ScaffoldMessenger.of(context);
      final scope = AppScope.of(context);

      final rascunho = await _formNotifier.toRascunho(
        usuarioId: scope.authNotifier.userId ?? '',
      );
      await scope.coletaRepository.salvar(rascunho);
      _formNotifier.resetModificado();
      _salvouComSucesso = true;

      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.coletaDraftSuccess)));
      Navigator.of(context).pop();
    } catch (e, st) {
      log('Erro ao salvar rascunho', error: e, stackTrace: st);
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.coletaDraftError)));
      }
    }
  }

  Future<void> _salvarColeta() async {
    final l10n = context.l10n;
    final scope = AppScope.of(context);

    final usuarioId = scope.authNotifier.userId;

    if (usuarioId == null || usuarioId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.syncExpiredSession)));
      return;
    }

    final coord = _viewModel.coordenadaAtual;
    if (coord == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.coletaCoordsUnavailable)));
      return;
    }

    setState(() => _saving = true);

    try {
      final resultado = await _formNotifier.toResult(usuarioId: usuarioId);

      await scope.coletaRepository.salvar(resultado.coleta);
      await scope.bemMaterialRepository.salvar(resultado.bemMaterial);
      _salvouComSucesso = true;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.coletaFinishSuccess),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      log(
        'Erro ao salvar coleta',
        error: e,
        stackTrace: stackTrace,
        name: 'NovaColetaPage',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.coletaFinishError),
          backgroundColor: Theme.of(context).colorScheme.error,
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
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      color: AppColors.warningBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: <Widget>[
          const Icon(Icons.wifi_off, size: 16, color: AppColors.warningText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.coletaOfflineBanner,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.warningText,
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
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            l10n.coletaLoadingGps,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
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
            Icon(icone, size: 64, color: AppColors.warning),
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
