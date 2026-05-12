import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/sync_notifier.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppScope.of(context).syncNotifier.carregarPendentes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final syncNotifier = AppScope.of(context).syncNotifier;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        titleSpacing: 16.0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
        title: Text(
          'Sincronizar',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 18,
            letterSpacing: -0.45,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              // TODO: Abrir ajuda ou FAQ sobre sincronização
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: syncNotifier,
        builder: (context, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _NetworkStatusCard(),
                  const SizedBox(height: 16),
                  _SyncProgressCard(notifier: syncNotifier),
                  const SizedBox(height: 24),
                  _DetailedBreakdownSection(notifier: syncNotifier),
                  const SizedBox(height: 32),
                  _ActionSection(notifier: syncNotifier),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NetworkStatusCard extends StatelessWidget {
  const _NetworkStatusCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const Color successColor = Color(0xFF16A34A);
    const Color successBgColor = Color(0xFFDCFCE7);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
      child: Row(
        children: <Widget>[
          // Ícone de Wifi
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: successBgColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wifi, color: successColor, size: 24),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Status da Conexão',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  'Você está Online',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncProgressCard extends StatelessWidget {
  const _SyncProgressCard({required this.notifier});

  final SyncNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final resumo = notifier.ultimoResumo;
    final total = resumo?.total ?? 0;
    final sucessos = resumo?.sucessos ?? 0;
    final progresso = total > 0 ? (sucessos / total).clamp(0.0, 1.0) : 0.0;
    final porcentagem = (progresso * 100).toInt();

    final label = resumo != null
        ? '$porcentagem% sincronizado'
        : '${notifier.pendentes} pendente(s)';

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Progresso Geral',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Text(
                resumo != null ? '$porcentagem%' : '--',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progresso),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return Stack(
                children: <Widget>[
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.65,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailedBreakdownSection extends StatelessWidget {
  const _DetailedBreakdownSection({required this.notifier});

  final SyncNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final resumo = notifier.ultimoResumo;

    const okColor = Color(0xFF16A34A);
    const okBgColor = Color(0xFFF0FDF4);
    final pendColor = theme.colorScheme.primary;
    final pendBgColor = theme.colorScheme.primary.withValues(alpha: 0.1);
    const conflictColor = Color(0xFFDC2626);
    const conflictBgColor = Color(0xFFFEF2F2);

    Widget pendentesChip() {
      final count = notifier.pendentes;
      if (count == 0) {
        return const _StatusChip(
          text: 'OK',
          textColor: okColor,
          bgColor: okBgColor,
        );
      }
      return _StatusChip(
        text: '$count pendente(s)',
        textColor: pendColor,
        bgColor: pendBgColor,
      );
    }

    Widget conflitosChip() {
      final count = resumo?.conflitos ?? 0;
      if (count == 0) {
        return const _StatusChip(
          text: 'OK',
          textColor: okColor,
          bgColor: okBgColor,
        );
      }
      return _StatusChip(
        text: '$count conflito(s)',
        textColor: conflictColor,
        bgColor: conflictBgColor,
      );
    }

    Widget errosChip() {
      final count = resumo?.erros ?? 0;
      if (count == 0) {
        return const _StatusChip(
          text: 'OK',
          textColor: okColor,
          bgColor: okBgColor,
        );
      }
      return _StatusChip(
        text: '$count erro(s)',
        textColor: conflictColor,
        bgColor: conflictBgColor,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'DETALHAMENTO',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              const _BreakdownTile(
                icon: Icons.location_on_outlined,
                iconColor: okColor,
                title: 'Dados de GPS',
                // Chip verde
                trailingChip: _StatusChip(
                  text: 'OK',
                  textColor: okColor,
                  bgColor: okBgColor,
                ),
              ),
              const Divider(height: 1, indent: 48),
              _BreakdownTile(
                icon: Icons.description_outlined,
                iconColor: theme.colorScheme.primary,
                title: 'Formulários Pendentes',
                trailingChip: pendentesChip(),
              ),
              const Divider(height: 1, indent: 48),
              _BreakdownTile(
                icon: Icons.warning_amber_outlined,
                iconColor: conflictColor,
                title: 'Conflitos',
                trailingChip: conflitosChip(),
              ),
              const Divider(height: 1, indent: 48),
              _BreakdownTile(
                icon: Icons.cloud_off_outlined,
                iconColor: conflictColor,
                title: 'Erros de Envio',
                trailingChip: errosChip(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({required this.notifier});

  final SyncNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final sincronizando = notifier.sincronizando;
    final resumo = notifier.ultimoResumo;

    String? feedbackMsg;
    Color feedbackColor = const Color(0xFF64748B);

    switch (notifier.state) {
      case SyncState.concluido:
        if (resumo != null && resumo.totalOk) {
          feedbackMsg = 'Tudo sincronizado com sucesso!';
          feedbackColor = const Color(0xFF16A34A);
        } else {
          feedbackMsg =
              '${resumo?.conflitos ?? 0} conflito(s) precisam de revisão.';
          feedbackColor = const Color(0xFFDC2626);
        }
      case SyncState.semToken:
        feedbackMsg = 'Sessão expirada. Faça login novamente.';
        feedbackColor = const Color(0xFFDC2626);
      case SyncState.semConexao:
        feedbackMsg =
            notifier.mensagemErro ??
            'Sem conexão. Conecte-se à internet para sincronizar.';
        feedbackColor = const Color(0xFFD97706);
      case SyncState.erro:
        feedbackMsg = notifier.mensagemErro ?? 'Erro inesperado.';
        feedbackColor = const Color(0xFFDC2626);
      default:
        feedbackMsg = 'Última sincronização: --';
    }

    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: sincronizando ? null : () => notifier.sincronizar(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
          child: sincronizando
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.sync, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Iniciar Sincronização Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 16),
        Text(
          feedbackMsg,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: feedbackColor,
          ),
        ),
      ],
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailingChip,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget trailingChip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          trailingChip,
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.text,
    required this.textColor,
    required this.bgColor,
  });

  final String text;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
