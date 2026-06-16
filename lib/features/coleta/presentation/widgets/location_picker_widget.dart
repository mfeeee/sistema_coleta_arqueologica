import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/services/reverse_geocoding_service.dart';
import 'package:uuid/uuid.dart';

class LocationPickerWidget extends StatefulWidget {
  final LocalizacaoModel? initialValue;
  final ValueChanged<LocalizacaoModel> onChanged;
  final Color borderColor;
  final double? latitude;
  final double? longitude;

  const LocationPickerWidget({
    super.key,
    this.initialValue,
    required this.onChanged,
    required this.borderColor,
    this.latitude,
    this.longitude,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  late TextEditingController _cepController;
  late TextEditingController _logradouroController;
  late TextEditingController _municipioController;
  late TextEditingController _ufController;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _cepController = TextEditingController(text: widget.initialValue?.cep);
    _logradouroController = TextEditingController(
      text: widget.initialValue?.logradouro,
    );
    _municipioController = TextEditingController(
      text: widget.initialValue?.municipio,
    );
    _ufController = TextEditingController(text: widget.initialValue?.uf);

    if (widget.initialValue == null &&
        widget.latitude != null &&
        widget.longitude != null) {
      _autoPreencherDeCoords();
    }
  }

  Future<void> _autoPreencherDeCoords() async {
    setState(() => _carregando = true);

    final service = ReverseGeocodingService();
    final result = await service.fromCoords(
      widget.latitude!,
      widget.longitude!,
    );

    if (result != null) {
      _cepController.text = result.cep ?? '';
      _logradouroController.text = result.logradouro ?? '';
      _municipioController.text = result.municipio ?? '';
      _ufController.text = result.uf ?? '';
      _notifyChange();
    }

    if (mounted) {
      setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    _cepController.dispose();
    _logradouroController.dispose();
    _municipioController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged(
      LocalizacaoModel(
        id: widget.initialValue?.id ?? const Uuid().v4(),
        cep: _cepController.text.trim(),
        logradouro: _logradouroController.text.trim(),
        municipio: _municipioController.text.trim(),
        uf: _ufController.text.trim().toUpperCase(),
        lat: widget.initialValue?.lat ?? widget.latitude,
        lng: widget.initialValue?.lng ?? widget.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_carregando) ...[
          const LinearProgressIndicator(minHeight: 2),
          const SizedBox(height: 14),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _Field(
                label: 'CEP',
                controller: _cepController,
                hintText: '00000-000',
                borderColor: widget.borderColor,
                onChanged: (_) => _notifyChange(),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _Field(
                label: 'UF',
                controller: _ufController,
                hintText: 'EX: PI',
                borderColor: widget.borderColor,
                onChanged: (_) => _notifyChange(),
                maxLength: 2,
                textCapitalization: TextCapitalization.characters,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'MUNICÍPIO',
          controller: _municipioController,
          hintText: 'Ex: Parnaíba',
          borderColor: widget.borderColor,
          onChanged: (_) => _notifyChange(),
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'LOGRADOURO',
          controller: _logradouroController,
          hintText: 'Ex: Rua, Estrada, Sítio...',
          borderColor: widget.borderColor,
          onChanged: (_) => _notifyChange(),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final Color borderColor;
  final ValueChanged<String> onChanged;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;

  const _Field({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.borderColor,
    required this.onChanged,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: cs.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
