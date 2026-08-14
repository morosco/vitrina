import 'package:flutter/material.dart';

import 'colors.dart';
import 'tokens.dart';

/// Construye los `ThemeData` claro/oscuro de Vitrina a partir de [VColors].
///
/// Elevación deliberadamente plana (estética de estudio fotográfico): se
/// evitan sombras pesadas para que el contraste visual lo den las fotos
/// de producto, no los contenedores.
class VTheme {
  VTheme._();

  static ThemeData light() => _build(VColors.light, Brightness.light);
  static ThemeData dark() => _build(VColors.dark, Brightness.dark);

  static ThemeData _build(VColors c, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.teal,
      onPrimary: brightness == Brightness.light ? Colors.white : c.tealInk,
      secondary: c.amber,
      onSecondary: Colors.white,
      error: c.danger,
      onError: Colors.white,
      surface: c.surface,
      onSurface: c.ink,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.paper,
      extensions: [c],
      dividerColor: c.line,
      splashFactory: InkRipple.splashFactory,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, c),
      appBarTheme: AppBarTheme(
        backgroundColor: c.paper,
        foregroundColor: c.ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: c.ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VRadius.md),
          side: BorderSide(color: c.line),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surface2,
        side: BorderSide(color: c.lineSoft),
        labelStyle: TextStyle(fontSize: 12, color: c.inkSoft),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VRadius.pill),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.ink,
          foregroundColor: c.paper,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: VSpace.lg,
            vertical: VSpace.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VRadius.sm),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.inkSoft,
          side: BorderSide(color: c.line),
          padding: const EdgeInsets.symmetric(
            horizontal: VSpace.lg,
            vertical: VSpace.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VRadius.sm),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: VSpace.md,
          vertical: VSpace.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VRadius.sm),
          borderSide: BorderSide(color: c.lineSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VRadius.sm),
          borderSide: BorderSide(color: c.lineSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VRadius.sm),
          borderSide: BorderSide(color: c.teal, width: 1.5),
        ),
        labelStyle: TextStyle(color: c.inkFaint, fontSize: 12),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? c.teal
              : c.surface2,
        ),
        thumbColor: const WidgetStatePropertyAll(Colors.white),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base, VColors c) {
    return base
        .copyWith(
          displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.02,
            color: c.ink,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: c.ink,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: c.ink,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: c.ink,
          ),
          bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: c.ink),
          bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: c.inkSoft),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: c.inkFaint,
          ),
        )
        .apply(fontFamily: base.bodyMedium?.fontFamily);
  }
}

/// Estilo "de ficha técnica": números tabulares, como en las tarjetas de
/// SKU/precio de los wireframes. No se persigue una fuente monoespaciada
/// embebida (el CSP/costo no lo justifica en un prototipo Flutter Web);
/// el efecto de precisión se logra con `tabularFigures` + tracking.
TextStyle dataTextStyle(VColors c, {double size = 13, Color? color}) {
  return TextStyle(
    fontSize: size,
    color: color ?? c.inkSoft,
    fontFeatures: const [FontFeature.tabularFigures()],
    letterSpacing: 0.1,
  );
}
