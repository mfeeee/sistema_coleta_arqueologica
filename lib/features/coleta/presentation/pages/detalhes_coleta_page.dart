import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';

class DetalhesColetaPage extends StatelessWidget {
  const DetalhesColetaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Coleta')),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusColeta(),
              SizedBox(height: 16),
              _SecaoIdentificacao(),
              SizedBox(height: 16),
              _SecaoDadosTecnicos(),
              SizedBox(height: 16),
              _SecaoDescricao(),
              SizedBox(height: 16),
              _SecaoGaleria(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusColeta extends StatelessWidget {
  const _StatusColeta();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            children: [
              const Icon(Icons.circle, color: AppColors.success, size: 9),
              const SizedBox(width: 6),
              Text(
                'Aprovado',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
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
  const _SecaoIdentificacao();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TituloSecao(titulo: 'IDENTIFICAÇÃO', theme: theme),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              _LinhaInfo(rotulo: 'Nome', valor: 'Lapa do Sol', theme: theme),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              _LinhaInfo(
                rotulo: 'Localização',
                valor: 'Iraquara - BA',
                theme: theme,
                destaque: true,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              _LinhaInfo(rotulo: 'Data', valor: '05/10/2023', theme: theme),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecaoDadosTecnicos extends StatelessWidget {
  const _SecaoDadosTecnicos();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TituloSecao(titulo: 'DADOS TÉCNICOS', theme: theme),
        const SizedBox(height: 8),
        Row(
          children: [
            _CartaoDadoTecnico(
              rotulo: 'NATUREZA',
              valor: 'Bem\nArqueológico',
              theme: theme,
            ),
            const SizedBox(width: 8),
            _CartaoDadoTecnico(rotulo: 'TIPO', valor: 'Sítio', theme: theme),
            const SizedBox(width: 8),
            _CartaoDadoTecnico(
              rotulo: 'CONSERVAÇÃO',
              valor: 'Excelente',
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }
}

class _SecaoDescricao extends StatelessWidget {
  const _SecaoDescricao();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            'Sítio com painéis de gravuras rupestres de grande porte, '
            'associado a fontes de água. Apresenta excelente preservação '
            'das camadas estratigráficas e vestígios líticos em superfície.',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ),
      ],
    );
  }
}

class _SecaoGaleria extends StatelessWidget {
  const _SecaoGaleria();

  static const int _fotosVisiveis = 4;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _fotosVisiveis,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (BuildContext context, int index) {
            final bool isUltima = index == _fotosVisiveis - 1;

            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: theme.colorScheme.surfaceContainerHighest),
                  if (isUltima)
                    const ColoredBox(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          '+5',
                          style: TextStyle(
                            color: Colors.white,
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
        children: [
          Text(
            rotulo,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
          ),
          Text(
            valor,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              fontWeight: destaque ? FontWeight.w600 : FontWeight.w400,
              color: destaque ? theme.colorScheme.primary : null,
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
          children: [
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
