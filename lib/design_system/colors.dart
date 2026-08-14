import 'package:flutter/material.dart';

/// Paleta de Vitrina como [ThemeExtension].
///
/// El teal es el único acento activo de la app: aparece exclusivamente
/// cuando algo está "en 3D" (switch encendido, visor, badge AR). El ámbar
/// es una etiqueta semántica menor para "todavía en 2D" y nunca compite
/// con el teal como acento principal — ver sección "Sistema de diseño"
/// del spec.
class VColors extends ThemeExtension<VColors> {
  const VColors({
    required this.paper,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.inkSoft,
    required this.inkFaint,
    required this.line,
    required this.lineSoft,
    required this.teal,
    required this.tealStrong,
    required this.tealInk,
    required this.tealTint,
    required this.tealTintStrong,
    required this.amber,
    required this.amberTint,
    required this.danger,
    required this.dangerTint,
  });

  final Color paper;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color inkSoft;
  final Color inkFaint;
  final Color line;
  final Color lineSoft;
  final Color teal;
  final Color tealStrong;
  final Color tealInk;
  final Color tealTint;
  final Color tealTintStrong;
  final Color amber;
  final Color amberTint;
  final Color danger;
  final Color dangerTint;

  static const light = VColors(
    paper: Color(0xFFE7E9E7),
    surface: Color(0xFFF7F8F7),
    surface2: Color(0xFFEFF1EF),
    ink: Color(0xFF14181A),
    inkSoft: Color(0xFF4B5457),
    inkFaint: Color(0xFF7A8180),
    line: Color(0xFFC7CCC9),
    lineSoft: Color(0xFFDBDEDC),
    teal: Color(0xFF0E9B8F),
    tealStrong: Color(0xFF0B857B),
    tealInk: Color(0xFF053C37),
    tealTint: Color(0x1F0E9B8F),
    tealTintStrong: Color(0x380E9B8F),
    amber: Color(0xFFB8672E),
    amberTint: Color(0x24B8672E),
    danger: Color(0xFFB23B3B),
    dangerTint: Color(0x1FB23B3B),
  );

  static const dark = VColors(
    paper: Color(0xFF101314),
    surface: Color(0xFF171B1C),
    surface2: Color(0xFF1D2122),
    ink: Color(0xFFE8EBEA),
    inkSoft: Color(0xFF9DA5A4),
    inkFaint: Color(0xFF616B6A),
    line: Color(0xFF2B3132),
    lineSoft: Color(0xFF1F2425),
    teal: Color(0xFF3AD2C3),
    tealStrong: Color(0xFF5EE0D3),
    tealInk: Color(0xFFDFFBF6),
    tealTint: Color(0x243AD2C3),
    tealTintStrong: Color(0x3D3AD2C3),
    amber: Color(0xFFE39A55),
    amberTint: Color(0x29E39A55),
    danger: Color(0xFFD9776F),
    dangerTint: Color(0x24D9776F),
  );

  @override
  VColors copyWith({
    Color? paper,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? inkSoft,
    Color? inkFaint,
    Color? line,
    Color? lineSoft,
    Color? teal,
    Color? tealStrong,
    Color? tealInk,
    Color? tealTint,
    Color? tealTintStrong,
    Color? amber,
    Color? amberTint,
    Color? danger,
    Color? dangerTint,
  }) {
    return VColors(
      paper: paper ?? this.paper,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      inkFaint: inkFaint ?? this.inkFaint,
      line: line ?? this.line,
      lineSoft: lineSoft ?? this.lineSoft,
      teal: teal ?? this.teal,
      tealStrong: tealStrong ?? this.tealStrong,
      tealInk: tealInk ?? this.tealInk,
      tealTint: tealTint ?? this.tealTint,
      tealTintStrong: tealTintStrong ?? this.tealTintStrong,
      amber: amber ?? this.amber,
      amberTint: amberTint ?? this.amberTint,
      danger: danger ?? this.danger,
      dangerTint: dangerTint ?? this.dangerTint,
    );
  }

  @override
  VColors lerp(ThemeExtension<VColors>? other, double t) {
    if (other is! VColors) return this;
    return VColors(
      paper: Color.lerp(paper, other.paper, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineSoft: Color.lerp(lineSoft, other.lineSoft, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      tealStrong: Color.lerp(tealStrong, other.tealStrong, t)!,
      tealInk: Color.lerp(tealInk, other.tealInk, t)!,
      tealTint: Color.lerp(tealTint, other.tealTint, t)!,
      tealTintStrong: Color.lerp(tealTintStrong, other.tealTintStrong, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      amberTint: Color.lerp(amberTint, other.amberTint, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerTint: Color.lerp(dangerTint, other.dangerTint, t)!,
    );
  }
}

extension VColorsContext on BuildContext {
  VColors get vColors => Theme.of(this).extension<VColors>()!;
}
