import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';

class ColetaListItem extends StatelessWidget {
  const ColetaListItem({
    super.key,
    required this.coleta,
    required this.onVerDetalhes,
  });

  final ColetaEntity coleta;
  final VoidCallback onVerDetalhes;

  @override
  Widget build(BuildContext context) {
    final localizacao =
        coleta.uf ??
        (coleta.localizacao?.lat != null && coleta.localizacao?.lng != null
            ? '${coleta.localizacao!.lat!.toStringAsFixed(4)}, '
                  '${coleta.localizacao!.lng!.toStringAsFixed(4)}'
            : '—');
    final data = _formatarData(coleta.dataColeta);

    return _ColetaCard(
      barraBadges: _BadgesRow(coleta: coleta),
      title: coleta.nomeBem,
      location: localizacao,
      date: data,
      imageUrl: coleta.fotosUrls.firstOrNull,
      onTap: onVerDetalhes,
      actionsRow: _AcoesColeta(coleta: coleta, onVerDetalhes: onVerDetalhes),
    );
  }

  String _formatarData(DateTime data) {
    final d = data.day.toString().padLeft(2, '0');
    final m = data.month.toString().padLeft(2, '0');
    return '$d/$m/${data.year}';
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.coleta});

  final ColetaEntity coleta;

  bool get _estaSincronizado =>
      coleta.syncStatus == StatusColeta.sincronizado ||
      coleta.syncStatus == StatusColeta.conflito;

  @override
  Widget build(BuildContext context) {
    final (rotuloSync, textoSync, fundoSync) = _estaSincronizado
        ? ('Sincronizado', AppColors.successText, AppColors.successBg)
        : ('Não sincronizado', AppColors.warningText, AppColors.warningBg);

    final (
      rotuloStatus,
      textoStatus,
      fundoStatus,
    ) = switch (coleta.syncStatus) {
      StatusColeta.sincronizado => (
        'Aprovado',
        AppColors.successText,
        AppColors.successBg,
      ),
      StatusColeta.conflito => (
        'Rejeitado',
        AppColors.errorText,
        AppColors.errorBg,
      ),
      _ => ('Pendente', AppColors.warningText, AppColors.warningBg),
    };

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: <Widget>[
        _ColetaBadge(
          rotulo: rotuloSync,
          corTexto: textoSync,
          corFundo: fundoSync,
        ),
        _ColetaBadge(
          rotulo: rotuloStatus,
          corTexto: textoStatus,
          corFundo: fundoStatus,
        ),
      ],
    );
  }
}

class _ColetaBadge extends StatelessWidget {
  const _ColetaBadge({
    required this.rotulo,
    required this.corTexto,
    required this.corFundo,
  });

  final String rotulo;
  final Color corTexto;
  final Color corFundo;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: rotulo,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          rotulo,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: corTexto,
          ),
        ),
      ),
    );
  }
}

class _ColetaCard extends StatelessWidget {
  const _ColetaCard({
    required this.barraBadges,
    required this.title,
    required this.location,
    required this.date,
    required this.actionsRow,
    this.imageUrl,
    this.onTap,
  });

  final Widget barraBadges;
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
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
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
                    barraBadges,
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 10,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Coletado em: $date',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.outline,
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
      StatusColeta.rascunho => _botaoVerDetalhes(theme),
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
            icon: Icon(
              Icons.sync,
              size: 16,
              color: theme.colorScheme.onPrimary,
            ),
            label: Text(
              'Sincronizar Agora',
              style: TextStyle(color: theme.colorScheme.onPrimary),
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
        backgroundColor: theme.colorScheme.errorContainer,
        side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.3)),
        elevation: 0,
        minimumSize: const Size(double.infinity, 40),
      ),
      child: Text(
        'Ver Detalhes',
        style: TextStyle(color: theme.colorScheme.error),
      ),
    );
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
