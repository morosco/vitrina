/// Escala de espaciado y radios de Vitrina.
///
/// Espejo directo de los tokens definidos en la especificación de producto
/// (ver artifact "Vitrina — Especificación de Producto & UX").
library;

class VSpace {
  VSpace._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 48;
  static const double xxl = 96;
}

class VRadius {
  VRadius._();

  static const double sm = 6; // inputs
  static const double md = 12; // tarjetas
  static const double lg = 20; // hojas / modales
  static const double xl = 30; // frames destacados
  static const double pill = 999; // switches, chips
}

class VDuration {
  VDuration._();

  static const Duration fast = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 220);
  static const Duration settle = Duration(milliseconds: 420);
}
