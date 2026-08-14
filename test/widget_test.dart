// Pruebas de humo del prototipo Vitrina: que las 5 pantallas rendericen y
// que el switch 3D del wizard cambie de estado — la verificación mínima
// que pide la Fase 4 del plan de implementación.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vitrina/design_system/widgets/studio_switch.dart';
import 'package:vitrina/main.dart';

void main() {
  // Viewport amplio: evita que el contenido largo del dashboard quede
  // fuera del cache extent del ListView y no se materialice en el árbol.
  Future<void> pumpWide(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: VitrinaApp()));
  }

  testWidgets('Alta manual: navega los 6 pasos y el switch 3D cambia de estado', (
    tester,
  ) async {
    await pumpWide(tester);
    await tester.pumpAndSettle();

    expect(find.text('Nuevo producto'), findsOneWidget);

    // Paso 1 -> 2 (datos base ya vienen precargados)
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    // Paso 2: elegir la foto de ejemplo
    expect(find.text('Sube la foto tal como la tienes'), findsOneWidget);
    await tester.tap(find.text('Silla Nórdica Roble').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    // Paso 3: mejora automática (antes/después)
    expect(find.text('Mejora automática'), findsWidgets);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    // Paso 4: switch 3D, apagado por defecto
    expect(find.text('Apagado — se publica en 2D mejorado'), findsOneWidget);
    await tester.tap(find.byType(StudioSwitch));
    await tester.pumpAndSettle();
    expect(find.text('Encendido — se genera el modelo 3D'), findsOneWidget);
  });

  testWidgets('Alta masiva renderiza el lote y el control global', (
    tester,
  ) async {
    await pumpWide(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Alta masiva'));
    await tester.pumpAndSettle();

    expect(find.text('Carga masiva'), findsOneWidget);
    expect(find.text('Aplicar 3D a todo el lote'), findsOneWidget);
  });

  testWidgets('Categorías muestra el árbol y el showroom', (tester) async {
    await pumpWide(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Categorías'));
    await tester.pumpAndSettle();

    expect(find.text('ÁRBOL DE CATEGORÍAS'), findsOneWidget);
    expect(find.textContaining('Showroom virtual'), findsOneWidget);
  });

  testWidgets('Dashboard muestra métricas y productos a revisar', (
    tester,
  ) async {
    await pumpWide(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('INTERACCIÓN POR CATEGORÍA'), findsOneWidget);
    expect(find.textContaining('REQUIEREN REVISIÓN'), findsOneWidget);
  });
}
