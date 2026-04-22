import 'package:flutter/material.dart';

class Passo1IdentificacaoWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final double latitude;
  final double longitude;
  final TextEditingController nomeController;
  final TextEditingController nomesPopularesController;
  final String? naturezaSelecionada;
  final ValueChanged<String?> onNaturezaChanged;
  final String? tipoSelecionado;
  final ValueChanged<String?> onTipoSelecionadoChanged;
  final String? estadoConservacao;
  final ValueChanged<String?> onEstadoConservacaoChanged;
  final VoidCallback onAvancar;
  final VoidCallback onCancelar;

  const Passo1IdentificacaoWidget({
    super.key,
    required this.formKey,
    required this.latitude,
    required this.longitude,
    required this.nomeController,
    required this.nomesPopularesController,
    required this.naturezaSelecionada,
    required this.onNaturezaChanged,
    required this.tipoSelecionado,
    required this.onTipoSelecionadoChanged,
    required this.estadoConservacao,
    required this.onEstadoConservacaoChanged,
    required this.onAvancar,
    required this.onCancelar,
  });

  @override
  State<Passo1IdentificacaoWidget> createState() =>
      _Passo1IdentificacaoWidgetState();
}

class _Passo1IdentificacaoWidgetState extends State<Passo1IdentificacaoWidget> {
  // Controle local para os novos campos do design
  // Valor inicial simulando o design

  // Cores do Design (Figma)
  final Color bgColor = const Color(0xFF1C1916);
  final Color primaryBrown = const Color(0xFF493627);
  final Color borderColor = const Color(0xFF493627).withValues(alpha: 0.2);
  final Color textLight = const Color(0xFFF1F5F9);
  final Color textMuted = const Color(0xFF94A3B8);
  final Color inputText = const Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Barra de Progresso (Passos)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProgressStep(isActive: true, color: primaryBrown),
                const SizedBox(width: 12),
                _ProgressStep(
                  isActive: false,
                  color: primaryBrown.withValues(alpha: 0.2),
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
                  // --- COORDENADAS GPS ---
                  _SectionLabel('COORDENADAS GPS', textColor: textLight),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _GpsBox(
                          label: 'LATITUDE',
                          value: '${widget.latitude.toStringAsFixed(4)}° S',
                          borderColor: borderColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _GpsBox(
                          label: 'LONGITUDE',
                          value: '${widget.longitude.toStringAsFixed(4)}° W',
                          borderColor: borderColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- NOME DO BEM ---
                  _SectionLabel('NOME DO BEM', textColor: textLight),
                  const SizedBox(height: 8),
                  _CustomTextField(
                    controller: widget.nomeController,
                    borderColor: borderColor,
                    textColor: inputText,
                    hintText: 'Ex: Muro de Arrimo - Setor A',
                  ),
                  const SizedBox(height: 24),

                  // --- NOMES POPULARES ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      _SectionLabel('NOMES POPULARES', textColor: textLight),
                      const SizedBox(width: 8),
                      Text(
                        '(opcional)',
                        style: TextStyle(
                          color: textLight.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _CustomTextField(
                    controller: widget.nomesPopularesController,
                    borderColor: borderColor,
                    textColor: inputText,
                    hintText: 'Como a comunidade local se refere a este bem?',
                    maxLines: 2, // Altura maior conforme o Figma (68px)
                  ),
                  const SizedBox(height: 24),

                  // --- NATUREZA ---
                  _SectionLabel('NATUREZA', textColor: textLight),
                  const SizedBox(height: 8),
                  _CustomDropdown(
                    value: widget.naturezaSelecionada,
                    items: const [
                      'Arqueológico',
                      'Paleontológico',
                      'Histórico',
                    ],
                    borderColor: borderColor,
                    textColor: inputText,
                    onChanged: widget.onNaturezaChanged,
                  ),
                  const SizedBox(height: 24),

                  // --- TIPO ---
                  _SectionLabel('TIPO', textColor: textLight),
                  const SizedBox(height: 8),
                  _CustomDropdown(
                    value: widget.tipoSelecionado,
                    items: const ['Estrutura', 'Fragmento', 'Sítio Completo'],
                    borderColor: borderColor,
                    textColor: inputText,
                    onChanged: widget.onTipoSelecionadoChanged,
                  ),
                  const SizedBox(height: 24),

                  // --- ESTADO DE CONSERVAÇÃO ---
                  _SectionLabel('ESTADO DE CONSERVAÇÃO', textColor: textLight),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _ConservationButton(
                          label: 'BOM',
                          isSelected: widget.estadoConservacao == 'BOM',
                          activeColor: primaryBrown,
                          borderColor: borderColor,
                          textMuted: textMuted,
                          onTap: () => widget.onEstadoConservacaoChanged('BOM'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ConservationButton(
                          label: 'REGULAR',
                          isSelected: widget.estadoConservacao == 'REGULAR',
                          activeColor: primaryBrown,
                          borderColor: borderColor,
                          textMuted: textMuted,
                          onTap: () =>
                              widget.onEstadoConservacaoChanged('REGULAR'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ConservationButton(
                          label: 'RUIM',
                          isSelected: widget.estadoConservacao == 'RUIM',
                          activeColor: primaryBrown,
                          borderColor: borderColor,
                          textMuted: textMuted,
                          onTap: () =>
                              widget.onEstadoConservacaoChanged('RUIM'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // --- BOTÕES DE AÇÃO ---
                  ElevatedButton(
                    onPressed: widget.onAvancar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBrown,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: primaryBrown.withValues(alpha: 0.2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Próximo Passo: Documentação',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
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
                    child: Text(
                      'CANCELAR COLETA',
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
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
            style: const TextStyle(
              color: Color(
                0xFF493627,
              ), // Cor pedida no Figma para a label do GPS
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 14,
              fontFamily:
                  'Liberation Mono', // Fonte monoespaçada para coordenadas
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Color borderColor;
  final Color textColor;
  final String hintText;
  final int maxLines;

  const _CustomTextField({
    required this.controller,
    required this.borderColor,
    required this.textColor,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
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

class _CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final Color borderColor;
  final Color textColor;
  final ValueChanged<String?> onChanged;

  const _CustomDropdown({
    required this.value,
    required this.items,
    required this.borderColor,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: const Color(0xFF1C1916), // Fundo do menu aberto
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
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
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class _ConservationButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color borderColor;
  final Color textMuted;
  final VoidCallback onTap;

  const _ConservationButton({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.borderColor,
    required this.textMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          border: Border.all(color: isSelected ? activeColor : borderColor),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textMuted,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
