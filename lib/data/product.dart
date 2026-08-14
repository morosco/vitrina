import '../design_system/widgets/status_chip.dart';

class Product {
  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.stock,
    required this.description,
    required this.tags,
    required this.status,
    this.enhancedImageAsset,
    this.rawImageAsset,
    this.modelAsset,
  });

  final String id;
  final String sku;
  final String name;
  final String category;
  final String subcategory;
  final double price;
  final int stock;
  final String description;
  final List<String> tags;
  final VProductStatus status;

  /// Foto ya mejorada (fondo limpio, luz corregida). Presente siempre que
  /// el producto pasó por el pipeline — el 100% de los productos.
  final String? enhancedImageAsset;

  /// Foto "tal cual" original, usada solo en el paso de comparación.
  final String? rawImageAsset;

  /// Modelo 3D (.glb), presente solo si `status == threeD`.
  final String? modelAsset;

  bool get is3D => status == VProductStatus.threeD;
}

final List<Product> demoProducts = [
  Product(
    id: 'p1',
    sku: 'SLL-014',
    name: 'Silla Nórdica Roble',
    category: 'Mobiliario',
    subcategory: 'Sillas',
    price: 349,
    stock: 18,
    description:
        'Silla de comedor en madera de roble con asiento tapizado. '
        'Estructura robusta, ideal para uso diario en espacios comerciales.',
    tags: const ['madera', 'comedor', 'nórdico'],
    status: VProductStatus.threeD,
    rawImageAsset: 'assets/demo/silla_raw.png',
    enhancedImageAsset: 'assets/demo/silla_enhanced.png',
    modelAsset: 'assets/demo/silla.glb',
  ),
  Product(
    id: 'p2',
    sku: 'LMP-031',
    name: 'Lámpara de Mesa Cerámica',
    category: 'Iluminación',
    subcategory: 'Lámparas de mesa',
    price: 129,
    stock: 34,
    description:
        'Lámpara de mesa con base de cerámica esmaltada y pantalla de lino. '
        'Luz cálida, apta para sala o dormitorio.',
    tags: const ['cerámica', 'luz cálida'],
    status: VProductStatus.threeD,
    rawImageAsset: 'assets/demo/lampara_raw.png',
    enhancedImageAsset: 'assets/demo/lampara_enhanced.png',
    modelAsset: 'assets/demo/lampara.glb',
  ),
  Product(
    id: 'p3',
    sku: 'MSA-002',
    name: 'Mesa Auxiliar Roble',
    category: 'Mobiliario',
    subcategory: 'Mesas',
    price: 189,
    stock: 22,
    description: 'Mesa auxiliar redonda, madera maciza, acabado natural.',
    tags: const ['madera', 'sala'],
    status: VProductStatus.twoD,
  ),
  Product(
    id: 'p4',
    sku: 'CLG-009',
    name: 'Colgante Lino Trenzado',
    category: 'Iluminación',
    subcategory: 'Colgantes',
    price: 98,
    stock: 40,
    description: 'Pantalla colgante tejida a mano en fibra natural.',
    tags: const ['fibra natural', 'artesanal'],
    status: VProductStatus.twoD,
  ),
  Product(
    id: 'p5',
    sku: 'CER-017',
    name: 'Jarrón Cerámica Arena',
    category: 'Decoración',
    subcategory: 'Cerámica',
    price: 64,
    stock: 51,
    description: 'Jarrón decorativo de cerámica, tono arena mate.',
    tags: const ['cerámica', 'decoración'],
    status: VProductStatus.needsReview,
  ),
  Product(
    id: 'p6',
    sku: 'SLL-015',
    name: 'Silla Nórdica Roble — Negro',
    category: 'Mobiliario',
    subcategory: 'Sillas',
    price: 349,
    stock: 9,
    description: 'Misma silla nórdica, variante de tapizado negro.',
    tags: const ['madera', 'comedor'],
    status: VProductStatus.error,
  ),
];
