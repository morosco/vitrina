import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../design_system/colors.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets/status_chip.dart';

/// Dashboard — qué se rota, qué convierte, y qué modelo 3D necesita
/// revisión manual. El valor de negocio medible del catálogo, no solo
/// el efecto visual.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.vColors;
    final products = ref.watch(productsProvider);
    final needsReview = products
        .where(
          (p) =>
              p.status.name == 'needsReview' || p.status.name == 'error',
        )
        .toList();
    final threeDCount = products.where((p) => p.is3D).length;

    final byCategory = <String, int>{};
    for (final p in products) {
      byCategory.update(p.category, (v) => v + 1, ifAbsent: () => 1);
    }
    final maxCount = byCategory.values.isEmpty
        ? 1
        : byCategory.values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(VSpace.lg),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '1,204',
                      label: 'vistas 3D · 7 días',
                    ),
                  ),
                  const SizedBox(width: VSpace.md),
                  Expanded(
                    child: _StatCard(
                      value: '38%',
                      label: 'vistas → cotización',
                    ),
                  ),
                  const SizedBox(width: VSpace.md),
                  Expanded(
                    child: _StatCard(
                      value: '$threeDCount',
                      label: 'productos en 3D',
                      accent: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VSpace.xl),
              Text(
                'INTERACCIÓN POR CATEGORÍA',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: VSpace.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(VSpace.lg),
                  child: Column(
                    children: byCategory.entries.map((e) {
                      final ratio = e.value / maxCount;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: VSpace.md),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              child: Text(
                                e.key,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: c.inkSoft,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  VRadius.pill,
                                ),
                                child: LinearProgressIndicator(
                                  value: ratio,
                                  minHeight: 10,
                                  backgroundColor: c.surface2,
                                  color: c.teal,
                                ),
                              ),
                            ),
                            const SizedBox(width: VSpace.sm),
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${e.value}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: c.inkFaint,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: VSpace.xl),
              Row(
                children: [
                  Text(
                    'REQUIEREN REVISIÓN DE 3D',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(width: VSpace.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: c.dangerTint,
                      borderRadius: BorderRadius.circular(VRadius.pill),
                    ),
                    child: Text(
                      '${needsReview.length}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: c.danger,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VSpace.md),
              if (needsReview.isEmpty)
                Text(
                  'Todo al día — ningún producto pendiente.',
                  style: TextStyle(color: c.inkFaint),
                )
              else
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: needsReview
                        .map(
                          (p) => ListTile(
                            onTap: () => context.push('/viewer/${p.id}'),
                            leading: Icon(
                              Icons.flag_outlined,
                              color: c.danger,
                            ),
                            title: Text(p.name),
                            subtitle: Text('SKU ${p.sku} · ${p.category}'),
                            trailing: StatusChip(status: p.status),
                          ),
                        )
                        .toList(),
                  ),
                ),
              const SizedBox(height: VSpace.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.accent = false,
  });
  final String value;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(VSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: accent ? c.tealStrong : c.ink,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: c.inkFaint)),
          ],
        ),
      ),
    );
  }
}
