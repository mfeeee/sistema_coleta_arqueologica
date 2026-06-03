import 'dart:developer';
import '../../../bem_material/domain/repositories/bem_material_repository.dart';
import '../../../coleta/domain/services/pull_service.dart';
import '../../../coleta/domain/usecases/obter_coletas_pendentes_use_case.dart';
import '../../../../core/services/background_sync_service.dart';

class ExecutarSyncPosLoginUseCase {
  ExecutarSyncPosLoginUseCase({
    required PullService pullService,
    required BemMaterialRepository bemMaterialRepository,
    required ObterColetasPendentesUseCase obterColetasPendentesUseCase,
    Future<void> Function() agendarSync = BackgroundSyncService.agendar,
    void Function() onSyncColetasConcluido = _noop,
    void Function() onSyncBensConcluido = _noop,
    void Function(String) onAviso = _noopAviso,
  }) : _pullService = pullService,
       _bemMaterialRepository = bemMaterialRepository,
       _obterColetasPendentesUseCase = obterColetasPendentesUseCase,
       _agendarSync = agendarSync,
       _onSyncColetasConcluido = onSyncColetasConcluido,
       _onSyncBensConcluido = onSyncBensConcluido,
       _onAviso = onAviso;

  final PullService _pullService;
  final BemMaterialRepository _bemMaterialRepository;
  final ObterColetasPendentesUseCase _obterColetasPendentesUseCase;
  final Future<void> Function() _agendarSync;
  final void Function() _onSyncColetasConcluido;
  final void Function() _onSyncBensConcluido;
  final void Function(String) _onAviso;

  Future<void> call(String usuarioId) async {
    _pullService
        .sincronizarPull(usuarioId)
        .then(
          (_) => _onSyncColetasConcluido(),
          onError: (Object e, StackTrace st) {
            log(
              'Pull pós-login falhou',
              error: e,
              stackTrace: st,
              name: 'ExecutarSyncPosLoginUseCase',
            );
            _onAviso('Dados recentes não carregados. Verifique sua conexão.');
          },
        );

    _bemMaterialRepository
        .sincronizarBens()
        .then((_) => _onSyncBensConcluido())
        .catchError((Object e, StackTrace st) {
          log(
            'Sync bens pós-login falhou',
            error: e,
            stackTrace: st,
            name: 'ExecutarSyncPosLoginUseCase',
          );
          _onSyncBensConcluido();
        });

    _pushPendentes();

    BackgroundSyncService.agendar().then(
      (_) {},
      onError: (Object e, StackTrace st) => log(
        'Agendamento background falhou',
        error: e,
        stackTrace: st,
        name: 'ExecutarSyncPosLoginUseCase',
      ),
    );
  }

  Future<bool> podeDeslogar() async {
    final pendentes = await _obterColetasPendentesUseCase.call();
    return pendentes.isEmpty;
  }

  void _pushPendentes() {
    _obterColetasPendentesUseCase.call().then(
      (pendentes) {
        if (pendentes.isEmpty) return;
        log(
          '${pendentes.length} coleta(s) pendente(s) encontrada(s) pós-login',
          name: 'ExecutarSyncPosLoginUseCase',
        );
        _agendarSync().then(
          (_) {},
          onError: (Object e, StackTrace st) => log(
            'Agendamento background falhou (push pendentes)',
            error: e,
            stackTrace: st,
            name: 'ExecutarSyncPosLoginUseCase',
          ),
        );
      },
      onError: (Object e, StackTrace st) {
        log(
          'Erro ao verificar pendentes pós-login',
          error: e,
          stackTrace: st,
          name: 'ExecutarSyncPosLoginUseCase',
        );
      },
    );
  }
}

void _noop() {}
void _noopAviso(String _) {}
