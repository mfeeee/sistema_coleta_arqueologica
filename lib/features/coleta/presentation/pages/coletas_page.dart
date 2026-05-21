import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coletas_viewmodel.dart';

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
                const _SyncProgressBar(),
                TabBar(
                  isScrollable: true,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: const Color(0xFF64748B),
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
                        onRefresh: _viewModel.atualizar,
                        onVerDetalhes: _verDetalhes,
                      ),
                      _ListaColetasFiltrada(
                        coletas: _viewModel.pendentes,
                        carregando: carregando,
                        erro: erro,
                        onRefresh: _viewModel.atualizar,
                        onVerDetalhes: _verDetalhes,
                      ),
                      _ListaColetasFiltrada(
                        coletas: _viewModel.sincronizadas,
                        carregando: carregando,
                        erro: erro,
                        onRefresh: _viewModel.atualizar,
                        onVerDetalhes: _verDetalhes,
                      ),
                      _ListaColetasFiltrada(
                        coletas: _viewModel.conflitos,
                        carregando: carregando,
                        erro: erro,
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
          child: const Icon(Icons.add, color: Colors.white),
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
    required this.onRefresh,
    required this.onVerDetalhes,
  });

  final List<ColetaEntity> coletas;
  final bool carregando;
  final String? erro;
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
        children: const [_EstadoVazio()],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 96),
      itemCount: coletas.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _ColetaItem(
          coleta: coletas[index],
          onVerDetalhes: () => onVerDetalhes(coletas[index].id),
        ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio();

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
            'Nenhuma coleta encontrada',
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Registre sua primeira coleta arqueológica.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/nova-coleta'),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Nova Coleta',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
          ),
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
              color: const Color(0xFF64748B),
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

class _ColetaItem extends StatelessWidget {
  const _ColetaItem({required this.coleta, required this.onVerDetalhes});

  final ColetaEntity coleta;
  final VoidCallback onVerDetalhes;

  @override
  Widget build(BuildContext context) {
    final (statusText, statusColor, statusBgColor) = _statusInfo();
    final localizacao =
        coleta.uf ??
        '${coleta.latitude.toStringAsFixed(4)}, '
            '${coleta.longitude.toStringAsFixed(4)}';
    final data = _formatarData(coleta.dataColeta);

    return _ColetaCard(
      statusText: statusText,
      statusColor: statusColor,
      statusBgColor: statusBgColor,
      title: coleta.nomeBem,
      location: localizacao,
      date: data,
      imageUrl: coleta.fotosUrls.firstOrNull,
      onTap: onVerDetalhes,
      actionsRow: _AcoesColeta(coleta: coleta, onVerDetalhes: onVerDetalhes),
    );
  }

  (String, Color, Color) _statusInfo() => switch (coleta.syncStatus) {
    StatusColeta.pendente => (
      'Não Sincronizado',
      const Color(0xFF475569),
      const Color(0xFFF1F5F9),
    ),
    StatusColeta.sincronizado => (
      'Sincronizado',
      const Color(0xFF15803D),
      const Color(0xFFDCFCE7),
    ),
    StatusColeta.conflito => (
      'Conflito',
      const Color(0xFFB91C1C),
      const Color(0xFFFEE2E2),
    ),
  };

  String _formatarData(DateTime data) {
    final d = data.day.toString().padLeft(2, '0');
    final m = data.month.toString().padLeft(2, '0');
    return '$d/$m/${data.year}';
  }
}

class _AcoesColeta extends StatelessWidget {
  const _AcoesColeta({required this.coleta, required this.onVerDetalhes});

  final ColetaEntity coleta;
  final VoidCallback onVerDetalhes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return switch (coleta.syncStatus) {
      StatusColeta.pendente => _acoesPendente(theme),
      StatusColeta.sincronizado => _botaoVerDetalhes(theme),
      StatusColeta.conflito => _botaoConflito(theme),
    };
  }

  Widget _acoesPendente(ThemeData theme) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.edit_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            label: Text(
              'Editar',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sync, size: 16, color: Colors.white),
            label: const Text(
              'Sincronizar Agora',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _botaoVerDetalhes(ThemeData theme) {
    return ElevatedButton(
      onPressed: onVerDetalhes,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        elevation: 0,
        minimumSize: const Size(double.infinity, 40),
      ),
      child: Text(
        'Ver Detalhes',
        style: TextStyle(color: theme.colorScheme.primary),
      ),
    );
  }

  Widget _botaoConflito(ThemeData theme) {
    return ElevatedButton(
      onPressed: onVerDetalhes,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFEF2F2),
        side: const BorderSide(color: Color(0xFFFECACA)),
        elevation: 0,
        minimumSize: const Size(double.infinity, 40),
      ),
      child: const Text(
        'Ver Detalhes',
        style: TextStyle(color: Color(0xFFDC2626)),
      ),
    );
  }
}

class _SyncProgressBar extends StatelessWidget {
  const _SyncProgressBar();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'SINCRONIZANDO DADOS...',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                '65%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: <Widget>[
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.65,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
        ? const Color(0xFF22C55E)
        : const Color(0xFF94A3B8);
    final Color corHalo = online
        ? const Color(0xFF4ADE80)
        : const Color(0xFFCBD5E1);
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
            color: online ? theme.colorScheme.primary : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _ColetaCard extends StatelessWidget {
  const _ColetaCard({
    required this.statusText,
    required this.statusColor,
    required this.statusBgColor,
    required this.title,
    required this.location,
    required this.date,
    required this.actionsRow,
    this.imageUrl,
    this.onTap,
  });

  final String statusText;
  final Color statusColor;
  final Color statusBgColor;
  final String title;
  final String location;
  final String date;
  final String? imageUrl;
  final Widget actionsRow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final card = Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 10,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Coletado em: $date',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _ImagemColeta(imageUrl: imageUrl, theme: theme),
            ],
          ),
          const SizedBox(height: 16),
          actionsRow,
        ],
      ),
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}

class _ImagemColeta extends StatelessWidget {
  const _ImagemColeta({required this.imageUrl, required this.theme});

  final String? imageUrl;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image_outlined,
        color: theme.colorScheme.primary.withValues(alpha: 0.4),
        size: 32,
      ),
    );
  }
}
