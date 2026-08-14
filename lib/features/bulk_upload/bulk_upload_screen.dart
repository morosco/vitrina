import 'dart:async';

import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets/status_chip.dart';
import '../../design_system/widgets/studio_switch.dart';

class _BatchRow {
  _BatchRow(this.file, this.sku, {this.hasPhoto = true});
  final String file;
  final String sku;
  final bool hasPhoto;
  VProductStatus? status; // null hasta procesar
}

/// Alta masiva — mapeo simulado + tabla de lote. La decisión 2D/3D se toma
/// una vez a nivel de lote con el control global, no producto por producto.
class BulkUploadScreen extends StatefulWidget {
  const BulkUploadScreen({super.key});

  @override
  State<BulkUploadScreen> createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  bool _applyAllTo3D = true;
  bool _processing = false;
  bool _done = false;
  double _progress = 0;
  Timer? _timer;

  late final List<_BatchRow> _rows = [
    _BatchRow('SLL-014.jpg', 'SLL-014'),
    _BatchRow('SLL-015.jpg', 'SLL-015'),
    _BatchRow('MSA-002.jpg', 'MSA-002'),
    _BatchRow('LMP-031.jpg', 'LMP-031'),
    _BatchRow('CLG-009.jpg', 'CLG-009'),
    _BatchRow('CER-017.jpg', 'CER-017', hasPhoto: false),
    _BatchRow('CER-018.jpg', 'CER-018', hasPhoto: false),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _markedCount => _applyAllTo3D
      ? _rows.where((r) => r.hasPhoto).length
      : 0;

  void _process() {
    setState(() {
      _processing = true;
      _done = false;
      _progress = 0;
      for (final r in _rows) {
        r.status = null;
      }
    });
    const totalTicks = 20;
    var tick = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      tick++;
      setState(() {
        _progress = tick / totalTicks;
        final rowsRevealed = (tick / totalTicks * _rows.length).ceil();
        for (var i = 0; i < rowsRevealed && i < _rows.length; i++) {
          final r = _rows[i];
          r.status ??= !r.hasPhoto
              ? VProductStatus.error
              : (_applyAllTo3D
                    ? VProductStatus.threeD
                    : VProductStatus.twoD);
        }
      });
      if (tick >= totalTicks) {
        t.cancel();
        setState(() {
          _processing = false;
          _done = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    final errorCount = _rows.where((r) => !r.hasPhoto).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Carga masiva')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(VSpace.lg),
            children: [
              Text(
                'catalogo_verano.xlsx',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${_rows.length} filas · mapeo automático de columnas listo',
                style: TextStyle(color: c.inkSoft, fontSize: 13),
              ),
              const SizedBox(height: VSpace.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(VSpace.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MAPEO DE COLUMNAS',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: VSpace.sm),
                      Wrap(
                        spacing: VSpace.sm,
                        runSpacing: VSpace.sm,
                        children: const [
                          _MapChip(from: 'nombre_producto', to: 'Nombre'),
                          _MapChip(from: 'codigo', to: 'SKU'),
                          _MapChip(from: 'categoria', to: 'Categoría'),
                          _MapChip(from: 'precio_venta', to: 'Precio'),
                          _MapChip(from: 'existencias', to: 'Stock'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: VSpace.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(VSpace.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aplicar 3D a todo el lote',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: c.ink,
                              ),
                            ),
                            Text(
                              'Marcados: $_markedCount / ${_rows.length}',
                              style: TextStyle(
                                fontSize: 12,
                                color: c.inkFaint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StudioSwitch(
                        label: '',
                        value: _applyAllTo3D,
                        onChanged: _processing
                            ? (_) {}
                            : (v) => setState(() => _applyAllTo3D = v),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: VSpace.md),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (final r in _rows) _RowTile(row: r),
                  ],
                ),
              ),
              const SizedBox(height: VSpace.lg),
              if (_processing || _done) ...[
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(VRadius.pill),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 6,
                          backgroundColor: c.surface2,
                          color: c.teal,
                        ),
                      ),
                    ),
                    const SizedBox(width: VSpace.sm),
                    Text(
                      '${(_progress * 100).round()}%',
                      style: TextStyle(fontSize: 12, color: c.inkFaint),
                    ),
                  ],
                ),
                const SizedBox(height: VSpace.md),
              ],
              if (_done && errorCount > 0)
                Container(
                  padding: const EdgeInsets.all(VSpace.md),
                  margin: const EdgeInsets.only(bottom: VSpace.md),
                  decoration: BoxDecoration(
                    color: c.dangerTint,
                    borderRadius: BorderRadius.circular(VRadius.md),
                    border: Border.all(color: c.danger.withValues(alpha: .4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded, color: c.danger, size: 18),
                      const SizedBox(width: VSpace.sm),
                      Expanded(
                        child: Text(
                          '$errorCount fila(s) sin foto vinculada — revisa el reporte de incidencias.',
                          style: TextStyle(fontSize: 13, color: c.ink),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _done
                          ? () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'incidencias_catalogo_verano.csv descargado',
                                ),
                              ),
                            )
                          : null,
                      icon: const Icon(Icons.download_outlined, size: 18),
                      label: const Text('Descargar reporte'),
                    ),
                  ),
                  const SizedBox(width: VSpace.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _processing ? null : _process,
                      child: Text(
                        _processing
                            ? 'Procesando…'
                            : (_done
                                  ? 'Volver a procesar'
                                  : 'Procesar lote'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VSpace.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapChip extends StatelessWidget {
  const _MapChip({required this.from, required this.to});
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: BorderRadius.circular(VRadius.sm),
        border: Border.all(color: c.lineSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(from, style: TextStyle(fontSize: 12, color: c.inkFaint)),
          Icon(Icons.arrow_forward_rounded, size: 12, color: c.inkFaint),
          Text(
            to,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: c.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.row});
  final _BatchRow row;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VSpace.md,
        vertical: VSpace.sm,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.lineSoft)),
      ),
      child: Row(
        children: [
          Icon(
            row.hasPhoto ? Icons.image_outlined : Icons.image_not_supported_outlined,
            size: 16,
            color: row.hasPhoto ? c.inkFaint : c.danger,
          ),
          const SizedBox(width: VSpace.sm),
          Expanded(
            child: Text(
              '${row.file}  ·  ${row.sku}',
              style: TextStyle(fontSize: 13, color: c.ink),
            ),
          ),
          AnimatedSwitcher(
            duration: VDuration.fast,
            child: row.status == null
                ? Text(
                    'Pendiente',
                    key: const ValueKey('pending'),
                    style: TextStyle(fontSize: 11, color: c.inkFaint),
                  )
                : StatusChip(key: ValueKey(row.status), status: row.status!),
          ),
        ],
      ),
    );
  }
}
