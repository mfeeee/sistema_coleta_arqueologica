import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:uuid/uuid.dart';
import '../../viewmodels/coleta_form_notifier.dart';
import '../location_picker_widget.dart';

class Passo1IdentificacaoWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final double latitude;
  final double longitude;
  final ColetaFormNotifier formNotifier;
  final VoidCallback onAvancar;
  final VoidCallback onCancelar;

  const Passo1IdentificacaoWidget({
    super.key,
    required this.formKey,
    required this.latitude,
    required this.longitude,
    required this.formNotifier,
    required this.onAvancar,
    required this.onCancelar,
  });

  @override
  State<Passo1IdentificacaoWidget> createState() =>
      _Passo1IdentificacaoWidgetState();
}

class _Passo1IdentificacaoWidgetState extends State<Passo1IdentificacaoWidget> {
  VoidCallback? _formListener;

  @override
  void initState() {
    super.initState();

    _formListener = () {
      if (mounted) {
        setState(() {});
      }
    };
    widget.formNotifier.addListener(_formListener!);

    // Inicializa localização com coordenadas do GPS se ainda não existir
    if (widget.formNotifier.localizacao == null) {
      widget.formNotifier.setLocalizacao(
        LocalizacaoModel(
          id: const Uuid().v4(),
          lat: widget.latitude,
          lng: widget.longitude,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_formListener != null) {
      widget.formNotifier.removeListener(_formListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor = cs.primaryContainer.withValues(alpha: 0.2);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          // Barra de Progresso (Passos)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProgressStep(isActive: true, color: cs.primaryContainer),
                const SizedBox(width: 12),
                _ProgressStep(
                  isActive: false,
                  color: cs.primaryContainer.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 12),
                _ProgressStep(
                  isActive: false,
                  color: cs.primaryContainer.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),

          // Corpo do Formulário
          Expanded(
            child: Form(
              key: widget.formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 48.0),
                children: [
                  // --- COORDENADAS GPS (Informativo) ---
                  _SectionLabel(l10n.coletaGpsCoords, textColor: cs.onSurface),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _GpsBox(
                          label: l10n.coletaLatitude,
                          value: '${widget.latitude.toStringAsFixed(5)}° S',
                          borderColor: borderColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _GpsBox(
                          label: l10n.coletaLongitude,
                          value: '${widget.longitude.toStringAsFixed(5)}° W',
                          borderColor: borderColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- LOCALIZAÇÃO ---
                  _SectionLabel(
                    l10n.coletaAssetLocation,
                    textColor: cs.onSurface,
                  ),
                  const SizedBox(height: 12),
                  LocationPickerWidget(
                    initialValue: widget.formNotifier.localizacao,
                    borderColor: borderColor,
                    onChanged: widget.formNotifier.setLocalizacao,
                  ),
                  const SizedBox(height: 24),

                  // --- NOME DO BEM ---
                  _SectionLabel(l10n.coletaAssetName, textColor: cs.onSurface),
                  const SizedBox(height: 8),
                  _CustomTextField(
                    initialValue: widget.formNotifier.nome,
                    onChanged: widget.formNotifier.setNome,
                    borderColor: borderColor,
                    textColor: cs.onSurface,
                    hintText: l10n.coletaNameHint,
                  ),
                  const SizedBox(height: 24),

                  // --- NOMES POPULARES ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      _SectionLabel(
                        l10n.coletaPopularNames,
                        textColor: cs.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.coletaOptional,
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _CustomTextField(
                    initialValue: widget.formNotifier.nomesPopulares.join(', '),
                    onChanged: widget.formNotifier.setNomesPopulares,
                    borderColor: borderColor,
                    textColor: cs.onSurface,
                    hintText: l10n.coletaPopularNameHint,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),

                  // --- NATUREZA ---
                  _SectionLabel(l10n.coletaNature, textColor: cs.onSurface),
                  const SizedBox(height: 8),
                  _CustomDropdown<NaturezaBem>(
                    value: widget.formNotifier.natureza,
                    items: NaturezaBem.values,
                    labelBuilder: (e) => e.label,
                    borderColor: borderColor,
                    textColor: cs.onSurface,
                    onChanged: widget.formNotifier.setNatureza,
                  ),
                  const SizedBox(height: 24),

                  // --- TIPO ---
                  _SectionLabel(l10n.coletaType, textColor: cs.onSurface),
                  const SizedBox(height: 8),
                  _CustomDropdown<TipoBem>(
                    value: widget.formNotifier.tipo,
                    items: TipoBem.values,
                    labelBuilder: (e) => e.label,
                    borderColor: borderColor,
                    textColor: cs.onSurface,
                    onChanged: widget.formNotifier.setTipo,
                  ),

                  const SizedBox(height: 48),

                  // --- BOTÕES DE AÇÃO ---
                  ElevatedButton(
                    onPressed: widget.onAvancar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primaryContainer,
                      foregroundColor: cs.onPrimaryContainer,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: cs.primaryContainer.withValues(alpha: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.coletaActionNextStep,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: cs.onPrimaryContainer,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: widget.onCancelar,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Semantics(
                      label: 'Cancelar preenchimento e sair',
                      child: Text(
                        l10n.coletaActionCancel,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- COMPONENTES AUXILIARES PRIVADOS ---

class _ProgressStep extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _ProgressStep({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color textColor;

  const _SectionLabel(this.text, {required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.7,
      ),
    );
  }
}

class _GpsBox extends StatelessWidget {
  final String label;
  final String value;
  final Color borderColor;

  const _GpsBox({
    required this.label,
    required this.value,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primaryContainer,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontFamily: 'Liberation Mono',
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final Color borderColor;
  final Color textColor;
  final String hintText;
  final int maxLines;

  const _CustomTextField({
    required this.initialValue,
    required this.onChanged,
    required this.borderColor,
    required this.textColor,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      maxLines: maxLines,
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
      ),
    );
  }
}

class _CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final Color borderColor;
  final Color textColor;
  final ValueChanged<T?> onChanged;

  const _CustomDropdown({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.borderColor,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      dropdownColor: Theme.of(context).colorScheme.surfaceContainer,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(labelBuilder(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

List<TipoBem> tiposPermitidosPorNatureza(NaturezaBem? natureza) {
  if (natureza == null) return const [];

  switch (natureza) {
    case NaturezaBem.bemPaleontologico:
      return const [TipoBem.colecao, TipoBem.sitio];
    case NaturezaBem.bemArqueologico:
      return const [
        TipoBem.acervoOuColecao,
        TipoBem.colecao,
        TipoBem.bemOuConjunto,
        TipoBem.sitio,
      ];
  }
}
