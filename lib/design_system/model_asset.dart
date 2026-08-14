import 'package:flutter/foundation.dart' show kIsWeb;

/// `model_viewer_plus` resuelve el `src` distinto según plataforma: en
/// móvil usa `rootBundle` con la ruta del asset tal cual aparece en
/// `pubspec.yaml`; en Flutter Web inyecta el HTML directamente en la
/// página, así que la ruta debe ser la URL real donde el build sirve el
/// asset — que en Flutter Web es `/assets/<ruta del asset>` (el asset key
/// ya incluye el prefijo `assets/`, de ahí el doble segmento).
String modelAssetSrc(String assetPath) =>
    kIsWeb ? 'assets/$assetPath' : assetPath;
