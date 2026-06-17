import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show InsertMode;
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';

class ArtefatoTipoPicker extends StatefulWidget {
  final List<ArtefatoTipoEntity> selectedTypes;
  final ValueChanged<List<ArtefatoTipoEntity>> onChanged;

  const ArtefatoTipoPicker({
    super.key,
    required this.selectedTypes,
    required this.onChanged,
  });

  @override
  State<ArtefatoTipoPicker> createState() => _ArtefatoTipoPickerState();
}

class _ArtefatoTipoPickerState extends State<ArtefatoTipoPicker> {
  List<ArtefatoTipoEntity> _availableTypes = [];
  bool _loading = true;
  bool _carregado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_carregado) return;
    _carregado = true;
    _carregarDoLocal();
  }

  Future<void> _carregarDoLocal() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final db = AppScope.of(context).database;
      final rows = await db.select(db.artefatoTipos).get();
      if (mounted) {
        setState(() {
          _availableTypes = rows
              .map(
                (r) => ArtefatoTipoEntity(
                  id: r.id,
                  nome: r.nome,
                  novoTipo: r.novoTipo,
                ),
              )
              .toList();
          _loading = false;
        });
      }
      // Sync em background — não bloqueia o usuário
      _sincronizarEmBackground();
    } catch (e, st) {
      log('Erro ao carregar artefato tipos local', error: e, stackTrace: st);
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sincronizarEmBackground() async {
    try {
      final scope = AppScope.of(context);
      if (!scope.conectividadeService.estaOnline.value) return;

      final response = await scope.dio.get('/v1/mobile/artefato-tipos');
      final data = response.data as List;
      final db = scope.database;

      await db.batch((b) {
        for (final e in data) {
          b.insert(
            db.artefatoTipos,
            ArtefatoTiposCompanion.insert(
              id: e['id'].toString(),
              nome: e['nome'] as String,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      // Atualiza a lista na tela silenciosamente
      final rows = await db.select(db.artefatoTipos).get();
      if (mounted) {
        setState(() {
          _availableTypes = rows
              .map(
                (r) => ArtefatoTipoEntity(
                  id: r.id,
                  nome: r.nome,
                  novoTipo: r.novoTipo,
                ),
              )
              .toList();
        });
      }
    } catch (e) {
      log('Sync artefato-tipos em background falhou (ignorado)', error: e);
      // Falha silenciosa — offline é aceitável
    }
  }

  void _toggleType(ArtefatoTipoEntity type) {
    final newSelection = List<ArtefatoTipoEntity>.from(widget.selectedTypes);
    final index = newSelection.indexWhere((e) => e.id == type.id);
    if (index != -1) {
      newSelection.removeAt(index);
    } else {
      newSelection.add(type);
    }
    widget.onChanged(newSelection);
  }

  void _addNewType() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Tipo de Artefato'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Descrição do tipo inédito',
            helperText: 'Ex: Material orgânico não identificado',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('ADICIONAR'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      final newType = ArtefatoTipoEntity(
        id: const Uuid().v4(),
        nome: result.trim(),
        novoTipo: true,
        descricaoNova: result.trim(),
      );
      widget.onChanged([...widget.selectedTypes, newType]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._availableTypes.map((type) {
              final isSelected = widget.selectedTypes.any(
                (e) => e.id == type.id,
              );
              return FilterChip(
                label: Text(type.nome),
                selected: isSelected,
                onSelected: (_) => _toggleType(type),
                backgroundColor: cs.surface,
                selectedColor: cs.primaryContainer,
                checkmarkColor: cs.onPrimaryContainer,
                labelStyle: TextStyle(
                  color: isSelected
                      ? cs.onPrimaryContainer
                      : cs.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: isSelected
                      ? cs.primaryContainer
                      : cs.primaryContainer.withValues(alpha: 0.2),
                ),
              );
            }),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('OUTRO TIPO'),
              onPressed: _addNewType,
              backgroundColor: cs.secondaryContainer.withValues(alpha: 0.3),
              labelStyle: TextStyle(
                color: cs.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide.none,
            ),
          ],
        ),
        if (widget.selectedTypes.any((e) => e.novoTipo)) ...[
          const SizedBox(height: 24),
          Text(
            'NOVOS TIPOS IDENTIFICADOS',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.selectedTypes
              .where((e) => e.novoTipo)
              .map(
                (e) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(e.nome),
                    leading: const Icon(Icons.new_releases_outlined),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _toggleType(e),
                    ),
                  ),
                ),
              ),
        ],
      ],
    );
  }
}
