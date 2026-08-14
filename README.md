# Vitrina — prototipo (Fase 1 del roadmap)

Módulo de catálogos 3D de Mind Core ERP. Este repo contiene el **prototipo clickeable en Flutter Web** descrito en el plan de implementación aprobado — no el backend, ni las apps nativas iOS/Android definitivas.

La especificación completa de producto/UX (flujos, wireframes, sistema de diseño, modelo de negocio) vive como artifact publicado — ver memoria del proyecto para el enlace.

## Correr el prototipo

Este equipo no tenía Flutter instalado; el SDK se clonó en `C:\Users\Usuario\flutter` (canal stable). Si el PATH no lo incluye en una sesión nueva:

```
export PATH="$PATH:/c/Users/Usuario/flutter/bin"   # bash
```

Luego:

```
flutter pub get
flutter run -d chrome        # modo desarrollo
# o
flutter build web && cd build/web && python -m http.server 8765
```

No hay Android SDK ni Xcode en esta máquina — el target de desarrollo/demo es **Flutter Web** (por eso `model_viewer_plus` requiere el `<script>` agregado a mano en `web/index.html`, ver comentario ahí).

## Qué es real y qué es placeholder

- **Fotos "tal cual" y flujo de mejora**: reales, generadas para esta demo (`assets/demo/README.md` tiene el detalle y los job_ids).
- **"Mejora automática" (antes/después)**: el `remove_background` real de Higgsfield no aisló bien el producto y la cuenta llegó a 0 créditos antes de poder reintentar. Las imágenes `*_enhanced.png` actuales son un **placeholder local sin IA** (recorte + nitidez + viñeta). Pendiente reprocesar con créditos reales — ver `assets/demo/README.md`.
- **Modelos 3D** (`silla.glb`, `lampara.glb`): **placeholders** de la librería pública glTF-Sample-Assets de Khronos (por la misma falta de créditos al llamar `generate_3d`). Pendiente reemplazar por la salida real del pipeline.
- **AR**: el botón "Ver en AR" es una referencia informativa (hoja inferior) — la integración real con ARKit/ARCore es trabajo de la app nativa, fuera de alcance de este prototipo web.
- **Backend**: no existe. Todo el catálogo (`lib/data/product.dart`, `lib/data/category.dart`) es data mock en memoria.

## Estructura

```
lib/
  design_system/   tokens, tema claro/oscuro, componentes (switch 3D, chips, etc.)
  features/        una carpeta por pantalla (wizard, carga masiva, categorías, visor 3D, dashboard)
  data/            modelos + repositorio mock + providers de Riverpod
  router.dart      rutas con go_router
assets/demo/       fotos e imágenes .glb usadas en la demo (ver README ahí)
test/widget_test.dart   pruebas de humo de las 5 pantallas
```

## Verificación

```
flutter analyze   # sin issues
flutter test      # 4/4 passing
```

## Próximos pasos (fuera de esta fase)

Ver Fase 2/3 del roadmap guardado en memoria: backend real, AR nativo, generación 3D en vivo, marketplace de plantillas, white-label, modo offline, integración con inventario del ERP.
