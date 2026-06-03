import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';

class DetalhesItemPage extends StatelessWidget {
  const DetalhesItemPage({super.key, required this.bem});

  final BemMaterialEntity bem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(bem.nomeBem),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SecaoDados(
                titulo: 'IDENTIFICAÇÃO',
                linhas: [
                  _Linha('Nome', bem.nomeBem),
                  if (bem.codigoIphan != null)
                    _Linha('Código IPHAN', bem.codigoIphan!),
                  if (bem.natureza != null) _Linha('Natureza', bem.natureza!),
                  if (bem.tipo != null) _Linha('Tipo', bem.tipo!),
                  if (bem.anoRegistro != null)
                    _Linha('Ano de Registro', '${bem.anoRegistro}'),
                ],
              ),
              if (bem.latitude != null && bem.longitude != null) ...[
                const SizedBox(height: 16),
                _SecaoDados(
                  titulo: 'COORDENADAS',
                  linhas: [
                    _Linha('Latitude', bem.latitude!.toStringAsFixed(6)),
                    _Linha('Longitude', bem.longitude!.toStringAsFixed(6)),
                  ],
                ),
              ],
              if (_temEndereco(bem)) ...[
                const SizedBox(height: 16),
                _SecaoDados(
                  titulo: 'ENDEREÇO',
                  linhas: [
                    if (bem.endereco != null)
                      _Linha('Logradouro', bem.endereco!),
                    if (bem.municipio != null)
                      _Linha('Município', bem.municipio!),
                    if (bem.uf != null) _Linha('UF', bem.uf!),
                    if (bem.cep != null) _Linha('CEP', bem.cep!),
                  ],
                ),
              ],
              if (bem.artefatos.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SecaoArtefatos(
                  artefatos: bem.artefatos.map((a) => a.label).toList(),
                ),
              ],
              if (bem.meiosAcesso != null && bem.meiosAcesso!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SecaoTexto(titulo: 'MEIOS DE ACESSO', texto: bem.meiosAcesso!),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  bool _temEndereco(BemMaterialEntity b) =>
      b.endereco != null ||
      b.municipio != null ||
      b.uf != null ||
      b.cep != null;
}

class _SecaoDados extends StatelessWidget {
  const _SecaoDados({required this.titulo, required this.linhas});

  final String titulo;
  final List<_Linha> linhas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              for (var i = 0; i < linhas.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        linhas[i].rotulo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          linhas[i].valor,
                          textAlign: TextAlign.end,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < linhas.length - 1)
                  Divider(height: 1, color: theme.colorScheme.outlineVariant),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Linha {
  const _Linha(this.rotulo, this.valor);
  final String rotulo;
  final String valor;
}

class _SecaoArtefatos extends StatelessWidget {
  const _SecaoArtefatos({required this.artefatos});

  final List<String> artefatos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ARTEFATOS',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: artefatos
              .map(
                (a) => Chip(
                  label: Text(a, style: const TextStyle(fontSize: 12)),
                  visualDensity: VisualDensity.compact,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SecaoTexto extends StatelessWidget {
  const _SecaoTexto({required this.titulo, required this.texto});

  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
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
