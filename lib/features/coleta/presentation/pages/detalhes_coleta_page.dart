import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/entities/localizacao_entity.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/media/presentation/widgets/midia_viewer.dart';
import 'package:sistema_coleta_arqueologica/core/models/midia_model.dart';

import '../viewmodels/detalhes_coleta_viewmodel.dart';

class DetalhesColetaPage extends StatefulWidget {
  const DetalhesColetaPage({super.key, required this.id});

  final String? id;

  @override
  State<DetalhesColetaPage> createState() => _DetalhesColetaPageState();
}

class _DetalhesColetaPageState extends State<DetalhesColetaPage> {
  DetalhesColetaViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final id = widget.id;
      if (id != null) {
        final scope = AppScope.of(context);
        _viewModel = DetalhesColetaViewModel(
          coletaRepository: scope.coletaRepository,
          id: id,
        );
        _viewModel!.carregar();
      }
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = _viewModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Coleta'),
        leading: const BackButton(),
      ),
      body: vm == null
          ? const _ErroColeta(mensagem: 'Coleta não encontrada.')
          : ListenableBuilder(
              listenable: Listenable.merge([vm.carregando, vm.erro, vm.coleta]),
              builder: (context, _) {
                if (vm.carregando.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (vm.erro.value != null) {
                  return _ErroColeta(mensagem: vm.erro.value!);
                }
                final coleta = vm.coleta.value;
                if (coleta == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Convert list of entities to list of models for the viewer
                final midias = coleta.midias
                    .map(
                      (e) => MidiaModel(
                        id: e.id,
                        mediableType: e.mediableType,
                        mediableId: e.mediableId,
                        storagePath: e.storagePath,
                        mimeType: e.mimeType,
                        tipo: e.tipo,
                        url: e.url,
                        descricao: e.descricao,
                      ),
                    )
                    .toList();

                return SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _StatusColeta(status: coleta.syncStatus),
                        const SizedBox(height: 16),
                        _SecaoIdentificacao(coleta: coleta),
                        const SizedBox(height: 16),
                        if (coleta.localizacao != null) ...[
                          _SecaoLocalizacao(localizacao: coleta.localizacao!),
                          const SizedBox(height: 16),
                        ],
                        _SecaoDadosTecnicos(coleta: coleta),
                        const SizedBox(height: 16),
                        _SecaoDescricao(dadosColetados: coleta.dadosColetados),
                        const SizedBox(height: 16),
                        _SecaoGaleria(midias: midias),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _ErroColeta extends StatelessWidget {
  const _ErroColeta({required this.mensagem});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(mensagem, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _StatusColeta extends StatelessWidget {
  const _StatusColeta({required this.status});

  final StatusColeta status;

  Color _cor(ColorScheme cs) => switch (status) {
    StatusColeta.sincronizado => AppColors.success,
    StatusColeta.conflito => cs.error,
    StatusColeta.pendente => AppColors.warning,
    StatusColeta.rascunho => cs.onSurfaceVariant,
  };

  String _label() => switch (status) {
    StatusColeta.sincronizado => 'Sincronizado',
    StatusColeta.conflito => 'Conflito',
    StatusColeta.pendente => 'Pendente',
    StatusColeta.rascunho => 'Rascunho',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cor = _cor(theme.colorScheme);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
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
          Text(
            'STATUS DA COLETA',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.circle, color: cor, size: 9),
              const SizedBox(width: 6),
              Text(
                _label(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: cor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecaoIdentificacao extends StatelessWidget {
  const _SecaoIdentificacao({required this.coleta});

  final ColetaEntity coleta;

  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/'
      '${data.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = coleta.localizacao;
    final localizacao =
        [
          if (loc?.municipio?.isNotEmpty ?? false) loc!.municipio!,
          if (loc?.uf?.isNotEmpty ?? false) loc!.uf!,
        ].join(' / ').isNotEmpty
        ? [
            loc?.municipio,
            loc?.uf,
          ].whereType<String>().where((s) => s.isNotEmpty).join(' / ')
        : (loc?.lat != null
              ? '${loc!.lat!.toStringAsFixed(5)}, ${loc.lng!.toStringAsFixed(5)}'
              : '—');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TituloSecao(titulo: 'IDENTIFICAÇÃO', theme: theme),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: <Widget>[
              _LinhaInfo(
                rotulo: 'Nome',
                valor: coleta.nomeBem.isNotEmpty ? coleta.nomeBem : '—',
                theme: theme,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              _LinhaInfo(
                rotulo: 'Localização',
                valor: localizacao,
                theme: theme,
                destaque: true,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              _LinhaInfo(
                rotulo: 'Data',
                valor: _formatarData(coleta.dataColeta),
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecaoLocalizacao extends StatelessWidget {
  const _SecaoLocalizacao({required this.localizacao});

  final LocalizacaoEntity localizacao;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String val(String? s) => (s != null && s.isNotEmpty) ? s : '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TituloSecao(titulo: 'LOCALIZAÇÃO', theme: theme),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              _LinhaInfo(
                rotulo: 'Município',
                valor: val(localizacao.municipio),
                theme: theme,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              _LinhaInfo(
                rotulo: 'UF',
                valor: val(localizacao.uf),
                theme: theme,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              _LinhaInfo(
                rotulo: 'CEP',
                valor: val(localizacao.cep),
                theme: theme,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              _LinhaInfo(
                rotulo: 'Logradouro',
                valor: val(localizacao.logradouro),
                theme: theme,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              _LinhaInfo(
                rotulo: 'Coordenadas',
                valor: (localizacao.lat != null && localizacao.lng != null)
                    ? '${localizacao.lat!.toStringAsFixed(5)}, ${localizacao.lng!.toStringAsFixed(5)}'
                    : '—',
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecaoDadosTecnicos extends StatelessWidget {
  const _SecaoDadosTecnicos({required this.coleta});

  final ColetaEntity coleta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TituloSecao(titulo: 'DADOS TÉCNICOS', theme: theme),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            _CartaoDadoTecnico(
              rotulo: 'NATUREZA',
              valor: coleta.natureza?.label ?? '—',
              theme: theme,
            ),
            const SizedBox(width: 8),
            _CartaoDadoTecnico(
              rotulo: 'TIPO',
              valor: coleta.tipo?.label ?? '—',
              theme: theme,
            ),
            const SizedBox(width: 8),
            _CartaoDadoTecnico(
              rotulo: 'ARTEFATOS',
              valor: coleta.artefatoTipos.length.toString(),
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }
}

class _SecaoDescricao extends StatelessWidget {
  const _SecaoDescricao({required this.dadosColetados});

  final Map<String, dynamic> dadosColetados;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final descricao = dadosColetados['descricao'] as String?;
    final texto = (descricao != null && descricao.isNotEmpty)
        ? descricao
        : 'Sem descrição disponível.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TituloSecao(titulo: 'DESCRIÇÃO', theme: theme),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Text(
            texto,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ),
      ],
    );
  }
}

class _SecaoGaleria extends StatelessWidget {
  const _SecaoGaleria({required this.midias});

  final List<MidiaModel> midias;

  static const int _fotosVisiveis = 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = midias.length;
    final exibir = count.clamp(0, _fotosVisiveis);
    final extras = count > _fotosVisiveis ? count - _fotosVisiveis + 1 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _TituloSecao(titulo: 'GALERIA DE MÍDIA', theme: theme),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Ver todas',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (midias.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Sem fotos disponíveis.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exibir,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (BuildContext context, int index) {
              final isUltima = index == exibir - 1 && extras > 0;
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    MidiaViewer(midia: midias[index], fit: BoxFit.cover),
                    if (isUltima)
                      ColoredBox(
                        color: theme.colorScheme.scrim.withValues(alpha: 0.54),
                        child: Center(
                          child: Text(
                            '+$extras',
                            style: TextStyle(
                              color: theme.colorScheme.onInverseSurface,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _TituloSecao extends StatelessWidget {
  const _TituloSecao({required this.titulo, required this.theme});

  final String titulo;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  const _LinhaInfo({
    required this.rotulo,
    required this.valor,
    required this.theme,
    this.destaque = false,
  });

  final String rotulo;
  final String valor;
  final ThemeData theme;
  final bool destaque;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            rotulo,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
          ),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                fontWeight: destaque ? FontWeight.w600 : FontWeight.w400,
                color: destaque ? theme.colorScheme.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoDadoTecnico extends StatelessWidget {
  const _CartaoDadoTecnico({
    required this.rotulo,
    required this.valor,
    required this.theme,
  });

  final String rotulo;
  final String valor;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              rotulo,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              valor,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
