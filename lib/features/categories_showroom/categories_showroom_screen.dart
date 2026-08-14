import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/category.dart';
import '../../data/product.dart';
import '../../data/providers.dart';
import '../../design_system/colors.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets/status_chip.dart';

/// Árbol de categorías (drag & drop) + showroom navegable. Tocar una
/// categoría filtra el showroom; tocar un producto abre el visor 3D/AR.
class CategoriesShowroomScreen extends ConsumerStatefulWidget {
  const CategoriesShowroomScreen({super.key});

  @override
  ConsumerState<CategoriesShowroomScreen> createState() =>
      _CategoriesShowroomScreenState();
}

class _CategoriesShowroomScreenState
    extends ConsumerState<CategoriesShowroomScreen> {
  late List<VCategory> _tree;
  String? _selectedCategory;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _tree = List.of(ref.read(categoryTreeProvider));
      _initialized = true;
    }
    final c = context.vColors;
    final products = ref.watch(productsProvider);
    final visible = _selectedCategory == null
        ? products
        : products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                child: ListView(
                  padding: const EdgeInsets.all(VSpace.lg),
                  children: [
                    Text(
                      'ÁRBOL DE CATEGORÍAS',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mantén presionado y arrastra para reordenar.',
                      style: TextStyle(fontSize: 12, color: c.inkFaint),
                    ),
                    const SizedBox(height: VSpace.md),
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorderItem: (oldIndex, newIndex) {
                        setState(() {
                          final item = _tree.removeAt(oldIndex);
                          _tree.insert(newIndex, item);
                        });
                      },
                      children: [
                        for (final cat in _tree)
                          _CategoryGroup(
                            key: ValueKey(cat.id),
                            category: cat,
                            selected: _selectedCategory == cat.name,
                            onTap: () => setState(
                              () => _selectedCategory =
                                  _selectedCategory == cat.name
                                  ? null
                                  : cat.name,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              VerticalDivider(width: 1, color: c.line),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        VSpace.lg,
                        VSpace.lg,
                        VSpace.lg,
                        0,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.view_in_ar_outlined, color: c.tealStrong, size: 18),
                          const SizedBox(width: VSpace.sm),
                          Expanded(
                            child: Text(
                              _selectedCategory == null
                                  ? 'Showroom virtual · todas las categorías'
                                  : 'Showroom virtual · $_selectedCategory',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(VSpace.lg),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisSpacing: VSpace.md,
                              crossAxisSpacing: VSpace.md,
                              childAspectRatio: 0.82,
                            ),
                        itemCount: visible.length,
                        itemBuilder: (context, i) =>
                            _ProductTile(product: visible[i]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryGroup extends StatelessWidget {
  const _CategoryGroup({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });
  final VCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return Container(
      margin: const EdgeInsets.only(bottom: VSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(VRadius.sm),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: VSpace.sm,
                vertical: VSpace.sm,
              ),
              decoration: BoxDecoration(
                color: selected ? c.tealTint : c.surface2,
                borderRadius: BorderRadius.circular(VRadius.sm),
                border: selected ? Border.all(color: c.teal) : null,
              ),
              child: Row(
                children: [
                  Icon(Icons.drag_indicator_rounded, size: 16, color: c.inkFaint),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: selected ? c.tealInk : c.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (final child in category.children)
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      child.name,
                      style: TextStyle(fontSize: 13, color: c.inkSoft),
                    ),
                  ),
                  Text(
                    '${child.productCount}',
                    style: TextStyle(fontSize: 12, color: c.inkFaint),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return InkWell(
      borderRadius: BorderRadius.circular(VRadius.md),
      onTap: () => context.push('/viewer/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(VRadius.md),
          border: Border.all(color: product.is3D ? c.teal : c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: product.enhancedImageAsset != null
                    ? Image.asset(
                        product.enhancedImageAsset!,
                        fit: BoxFit.contain,
                      )
                    : Icon(Icons.image_outlined, color: c.inkFaint, size: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(VSpace.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'S/ ${product.price.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 12, color: c.inkSoft),
                        ),
                      ),
                      StatusChip(status: product.status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
