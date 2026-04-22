import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';

class MotivoRejeicaoPage extends StatelessWidget {
  const MotivoRejeicaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motivo da Rejeição')),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CartaoColeta(),
              SizedBox(height: 20),
              _CabecalhoFeedback(),
              SizedBox(height: 12),
              _CitacaoFeedback(),
              SizedBox(height: 20),
              _OrientacaoCorrecao(),
              SizedBox(height: 16),
              _BotaoEditarColeta(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartaoColeta extends StatelessWidget {
  const _CartaoColeta();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COLETADO EM 15/10/2023',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Toca do Boi',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Januária - MG',
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 80,
              height: 70,
              color: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _CabecalhoFeedback extends StatelessWidget {
  const _CabecalhoFeedback();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        const Icon(Icons.assignment_outlined, size: 22),
        const SizedBox(width: 8),
        Text(
          'Feedback do Curador',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CitacaoFeedback extends StatelessWidget {
  const _CitacaoFeedback();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        '"As fotos anexadas estão com baixa resolução e não permitem a '
        'identificação clara das pinturas rupestres. Além disso, a descrição '
        'da síntese histórica está incompleta, faltando referências sobre o '
        'período cronológico estimado."',
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.6, fontSize: 14),
      ),
    );
  }
}

class _OrientacaoCorrecao extends StatelessWidget {
  const _OrientacaoCorrecao();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        'Para corrigir, clique no botão abaixo para editar a coleta e '
        'reenvie para nova análise.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
      ),
    );
  }
}

class _BotaoEditarColeta extends StatelessWidget {
  const _BotaoEditarColeta();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.edit, size: 18),
        label: const Text(
          'EDITAR COLETA',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
