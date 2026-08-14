import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'category.dart';
import 'product.dart';

/// Catálogo de productos de la demo. En el prototipo es de solo lectura;
/// el backend real (fuera de alcance de esta fase) sería quien lo alimente.
final productsProvider = Provider<List<Product>>((ref) => demoProducts);

final categoryTreeProvider = Provider<List<VCategory>>(
  (ref) => demoCategoryTree,
);

final productByIdProvider = Provider.family<Product?, String>((ref, id) {
  final products = ref.watch(productsProvider);
  for (final p in products) {
    if (p.id == id) return p;
  }
  return null;
});
