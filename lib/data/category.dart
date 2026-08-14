/// Nodo del árbol de categorías (editable con drag & drop en la UI).
class VCategory {
  VCategory({required this.id, required this.name, this.children = const []});

  final String id;
  final String name;
  final List<VCategory> children;

  int get productCount => _demoCounts[id] ?? 0;

  static const _demoCounts = <String, int>{
    'sillas': 42,
    'mesas': 18,
    'lamparas': 27,
    'colgantes': 11,
    'ceramica': 9,
  };
}

final List<VCategory> demoCategoryTree = [
  VCategory(
    id: 'mobiliario',
    name: 'Mobiliario',
    children: [
      VCategory(id: 'sillas', name: 'Sillas'),
      VCategory(id: 'mesas', name: 'Mesas'),
    ],
  ),
  VCategory(
    id: 'iluminacion',
    name: 'Iluminación',
    children: [
      VCategory(id: 'lamparas', name: 'Lámparas de mesa'),
      VCategory(id: 'colgantes', name: 'Colgantes'),
    ],
  ),
  VCategory(
    id: 'decoracion',
    name: 'Decoración',
    children: [VCategory(id: 'ceramica', name: 'Cerámica')],
  ),
];
