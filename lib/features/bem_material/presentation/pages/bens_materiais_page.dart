import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/presentation/pages/detalhes_item_page.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/presentation/viewmodels/bens_materiais_viewmodel.dart';

class BensMateriaisPage extends StatefulWidget {
  const BensMateriaisPage({super.key, required this.coletaId});

  final String coletaId;

  @override
  State<BensMateriaisPage> createState() => _BensMateriaisPageState();
}

class _BensMateriaisPageState extends State<BensMateriaisPage> {
  late final BensMateriaisViewModel _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _viewModel = BensMateriaisViewModel(
        AppScope.of(context).bemMaterialRepository,
      );
      _viewModel.carregar(widget.coletaId);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _abrirDetalhes(BemMaterialEntity bem) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => DetalhesItemPage(bem: bem)));
  }

  Future<void> _adicionarBem() async {
    await context.push('/novo-bem-material/${widget.coletaId}');
    if (mounted) _viewModel.carregar(widget.coletaId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bens Materiais'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarBem,
        tooltip: 'Adicionar bem material',
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _viewModel.carregando,
          _viewModel.bens,
          _viewModel.erro,
        ]),
        builder: (context, _) {
          if (_viewModel.carregando.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.erro.value != null) {
            return _ErroView(
              mensagem: _viewModel.erro.value!,
              onTentar: () => _viewModel.carregar(widget.coletaId),
            );
          }

          final bens = _viewModel.bens.value;

          if (bens.isEmpty) {
            return _EstadoVazio(onAdicionar: _adicionarBem);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: bens.length,
            itemBuilder: (context, index) => _CartaoBem(
              bem: bens[index],
              onTap: () => _abrirDetalhes(bens[index]),
            ),
          );
        },
      ),
    );
  }
}

class _CartaoBem extends StatelessWidget {
  const _CartaoBem({required this.bem, required this.onTap});

  final BemMaterialEntity bem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.category_outlined,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bem.nomeBem,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (bem.natureza != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        bem.natureza!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (bem.codigoIphan != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'IPHAN: ${bem.codigoIphan}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio({required this.onAdicionar});

  final VoidCallback onAdicionar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum bem material registrado',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque em + para registrar o primeiro bem desta coleta.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdicionar,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Bem'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErroView extends StatelessWidget {
  const _ErroView({required this.mensagem, required this.onTentar});

  final String mensagem;
  final VoidCallback onTentar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onTentar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
