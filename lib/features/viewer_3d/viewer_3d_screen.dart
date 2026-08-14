import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../data/providers.dart';
import '../../design_system/colors.dart';
import '../../design_system/model_asset.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets/status_chip.dart';

/// Visor 3D/AR de un producto — rotar/zoom vienen del propio modelo GLB;
/// "Ver en AR" y "Pedir cotización" nunca están a más de un tap, tal como
/// pide el spec para cerrar el ciclo de exploración → venta.
class Viewer3DScreen extends ConsumerWidget {
  const Viewer3DScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.vColors;
    final product = ref.watch(productByIdProvider(productId));

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Producto no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(VSpace.lg),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(VRadius.lg),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: product.is3D ? c.teal : c.line,
                        ),
                        color: c.surface2,
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: product.is3D && product.modelAsset != null
                                ? ModelViewer(
                                    key: ValueKey(product.modelAsset),
                                    backgroundColor: c.surface2,
                                    src: modelAssetSrc(product.modelAsset!),
                                    alt: product.description,
                                    autoRotate: true,
                                    autoRotateDelay: 800,
                                    rotationPerSecond: '18deg',
                                    cameraControls: true,
                                    disableZoom: false,
                                  )
                                : Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(VSpace.xl),
                                    child: product.enhancedImageAsset != null
                                        ? Image.asset(
                                            product.enhancedImageAsset!,
                                            fit: BoxFit.contain,
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 48,
                                              color: c.inkFaint,
                                            ),
                                          ),
                                  ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: product.is3D ? c.teal : c.surface,
                                borderRadius: BorderRadius.circular(
                                  VRadius.pill,
                                ),
                                border: product.is3D
                                    ? null
                                    : Border.all(color: c.line),
                              ),
                              child: Text(
                                product.is3D
                                    ? 'Interactivo · 360°'
                                    : '2D mejorado',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: product.is3D
                                      ? Colors.white
                                      : c.inkSoft,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: VSpace.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'SKU ${product.sku} · S/ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    StatusChip(status: product.status),
                  ],
                ),
              ),
              const SizedBox(height: VSpace.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: VSpace.lg),
                child: Text(product.description, style: TextStyle(color: c.inkSoft)),
              ),
              Padding(
                padding: const EdgeInsets.all(VSpace.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showAr(context),
                        icon: const Icon(Icons.view_in_ar_outlined, size: 18),
                        label: const Text('Ver en AR'),
                      ),
                    ),
                    const SizedBox(width: VSpace.md),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => _requestQuote(context, product.name),
                        icon: const Icon(
                          Icons.request_quote_outlined,
                          size: 18,
                        ),
                        label: const Text('Pedir cotización'),
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

  void _showAr(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final c = context.vColors;
        return Padding(
          padding: const EdgeInsets.all(VSpace.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.view_in_ar_rounded, color: c.tealStrong, size: 28),
              const SizedBox(height: VSpace.sm),
              const Text(
                'AR disponible en la app móvil',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                'En iOS/Android, este botón abre ARKit/ARCore para colocar '
                'el producto en tu espacio real con la cámara. En este '
                'prototipo web se deja como acción de referencia.',
                style: TextStyle(color: c.inkSoft),
              ),
            ],
          ),
        );
      },
    );
  }

  void _requestQuote(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cotización de "$productName" enviada al equipo de ventas',
        ),
      ),
    );
  }
}
