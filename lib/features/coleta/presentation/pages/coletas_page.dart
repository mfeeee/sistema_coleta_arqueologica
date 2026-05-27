import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coletas_viewmodel.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/widgets/coleta_list_item.dart';

class ColetasPage extends StatefulWidget {
  const ColetasPage({super.key});

  @override
  State<ColetasPage> createState() => _ColetasPageState();
}

class _ColetasPageState extends State<ColetasPage> {
  late final ColetasViewModel _viewModel;
  bool _initialized = false;
  bool _temRascunho = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final scope = AppScope.of(context);
      _viewModel = ColetasViewModel(scope.coletaRepository);
      _viewModel.carregarColetas();
      _temRascunho = scope.prefs.containsKey('rascunho_coleta');
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _verDetalhes(String id) => context.push('/detalhes-coleta', extra: id);

  Future<void> _continuarRascunho() async {
    await context.push('/nova-coleta');
    if (mounted) {
      setState(() {
        _temRascunho = AppScope.of(
          context,
        ).prefs.containsKey('rascunho_coleta');
      });
      _viewModel.atualizar();
    }
  }

  Future<void> _descartarRascunho() async {
    await AppScope.of(context).prefs.remove('rascunho_coleta');
    if (mounted) setState(() => _temRascunho = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 16.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Minhas Coletas',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 18,
                  height: 1.2,
                ),
              ),
              const _OnlineIndicator(),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Column(
              children: <Widget>[
                _BarraProgressoSync(viewModel: _viewModel),
                TabBar(
                  isScrollable: true,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                  indicatorColor: theme.colorScheme.primary,
                  indicatorWeight: 2.0,
                  tabs: const <Widget>[
                    Tab(text: 'TODOS'),
                    Tab(text: 'PENDENTES'),
                    Tab(text: 'APROVADOS'),
                    Tab(text: 'REJEITADOS'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            if (_temRascunho)
              _BannerRascunho(
                onContinuar: _continuarRascunho,
                onDescartar: _descartarRascunho,
              ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  _viewModel.coletas,
                  _viewModel.carregando,
                  _viewModel.erro,
                ]),
                builder: (context, _) {
                  final carregando = _viewModel.carregando.value;
                  final erro = _viewModel.erro.value;

                  return TabBarView(
                    children: <Widget>[
                      _ListaColetasFiltrada(
                        coletas: _viewModel.coletas.value,
                        carregando: carregando,
                        erro: erro,
                        mensagemVazia:
                            'Registre sua primeira coleta arqueológica.',
                        exibirBotaoNovaColeta: _viewModel.coletas.value.isEmpty,
                        onRefresh: _viewModel.atualizar,
                        onVerDetalhes: _verDetalhes,
                      ),
                      _ListaColetasFiltrada(
                        coletas: _viewModel.pendentes,
                        carregando: carregando,
                        erro: erro,
                        mensagemVazia: 'Nenhuma coleta pendente.',
                        exibirBotaoNovaColeta: _viewModel.coletas.value.isEmpty,
                        onRefresh: _viewModel.atualizar,
                        onVerDetalhes: _verDetalhes,
                      ),
                      _ListaColetasFiltrada(
                        coletas: _viewModel.sincronizadas,
                        carregando: carregando,
                        erro: erro,
                        mensagemVazia: 'Nenhuma coleta aprovada.',
                        exibirBotaoNovaColeta: _viewModel.coletas.value.isEmpty,
                        onRefresh: _viewModel.atualizar,
                        onVerDetalhes: _verDetalhes,
                      ),
                      _ListaColetasFiltrada(
                        coletas: _viewModel.conflitos,
                        carregando: carregando,
                        erro: erro,
                        mensagemVazia: 'Nenhuma coleta rejeitada.',
                        exibirBotaoNovaColeta: _viewModel.coletas.value.isEmpty,
                        onRefresh: _viewModel.atualizar,
                        onVerDetalhes: _verDetalhes,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await context.push('/nova-coleta');
            if (mounted) {
              setState(() {
                _temRascunho = AppScope.of(
                  context,
                ).prefs.containsKey('rascunho_coleta');
              });
              _viewModel.atualizar();
            }
          },
          backgroundColor: theme.colorScheme.primary,
          child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}

class _BannerRascunho extends StatelessWidget {
  const _BannerRascunho({required this.onContinuar, required this.onDescartar});

  final VoidCallback onContinuar;
  final VoidCallback onDescartar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: theme.colorScheme.primaryContainer,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.edit_note_outlined,
            color: theme.colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Você tem um rascunho salvo. Continuar?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          TextButton(
            onPressed: onDescartar,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Descartar',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onContinuar,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Continuar',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListaColetasFiltrada extends StatelessWidget {
  const _ListaColetasFiltrada({
    required this.coletas,
    required this.carregando,
    required this.erro,
    required this.mensagemVazia,
    required this.exibirBotaoNovaColeta,
    required this.onRefresh,
    required this.onVerDetalhes,
  });

  final List<ColetaEntity> coletas;
  final bool carregando;
  final String? erro;
  final String mensagemVazia;
  final bool exibirBotaoNovaColeta;
  final Future<void> Function() onRefresh;
  final void Function(String id) onVerDetalhes;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: onRefresh, child: _conteudo(context));
  }

  Widget _conteudo(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (erro != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_EstadoErro(mensagem: erro!, onTentarNovamente: onRefresh)],
      );
    }
    if (coletas.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _EstadoVazio(
            mensagem: mensagemVazia,
            exibirBotaoNovaColeta: exibirBotaoNovaColeta,
          ),
        ],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 96),
      itemCount: coletas.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ColetaListItem(
          coleta: coletas[index],
          onVerDetalhes: () => onVerDetalhes(coletas[index].id),
        ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio({
    required this.mensagem,
    required this.exibirBotaoNovaColeta,
  });

  final String mensagem;
  final bool exibirBotaoNovaColeta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.layers_outlined,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            mensagem,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (exibirBotaoNovaColeta) ...<Widget>[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/nova-coleta'),
              icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
              label: Text(
                'Nova Coleta',
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EstadoErro extends StatelessWidget {
  const _EstadoErro({required this.mensagem, required this.onTentarNovamente});

  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            mensagem,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onTentarNovamente,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

class _BarraProgressoSync extends StatelessWidget {
  const _BarraProgressoSync({required this.viewModel});

  final ColetasViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel.coletas,
      builder: (context, _) {
        final total = viewModel.totalColetas;
        final progresso = viewModel.progressoSync;
        final todas = viewModel.todasSincronizadas;
        final sincronizadas = viewModel.coletasSincronizadas;
        final theme = Theme.of(context);

        final String rotulo;
        if (total == 0) {
          rotulo = 'Nenhuma coleta registrada';
        } else if (todas) {
          rotulo = 'Dados Sincronizados';
        } else {
          rotulo = '$sincronizadas de $total sincronizadas';
        }

        final Color corBarra = todas
            ? AppColors.success
            : theme.colorScheme.primary;
        final String porcentagem = '${(progresso * 100).round()}%';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    rotulo.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: todas
                          ? AppColors.success
                          : theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    porcentagem,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: corBarra,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progresso),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                builder: (context, valor, _) => Stack(
                  children: <Widget>[
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: corBarra.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: valor,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: corBarra,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OnlineIndicator extends StatelessWidget {
  const _OnlineIndicator();

  @override
  Widget build(BuildContext context) {
    final estaOnline = AppScope.of(context).conectividadeService.estaOnline;

    return ValueListenableBuilder<bool>(
      valueListenable: estaOnline,
      builder: (context, online, _) => _IndicadorConexao(online: online),
    );
  }
}

class _IndicadorConexao extends StatelessWidget {
  const _IndicadorConexao({required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color cor = online
        ? AppColors.successBright
        : theme.colorScheme.outline;
    final Color corHalo = online
        ? AppColors.successHalo
        : theme.colorScheme.outlineVariant;
    final String rotulo = online ? 'Online' : 'Offline';

    return Row(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: corHalo.withValues(alpha: 0.75),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          rotulo,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: online
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
