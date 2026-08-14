import 'package:flutter/material.dart';

import '../colors.dart';
import '../tokens.dart';

/// El "barrido antes/después" del paso de mejora automática: una línea
/// arrastrable revela el resultado sobre el original, para que el usuario
/// "descubra" la mejora con el dedo en vez de leerla en un texto.
class BeforeAfterSlider extends StatefulWidget {
  const BeforeAfterSlider({
    super.key,
    required this.before,
    required this.after,
    this.height = 220,
  });

  final Widget before;
  final Widget after;
  final double height;

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  double _pos = 0.5;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(VRadius.md),
      child: SizedBox(
        height: widget.height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            void updateFromDx(double dx) {
              setState(() => _pos = (dx / w).clamp(0.0, 1.0));
            }

            return GestureDetector(
              onHorizontalDragUpdate: (d) => updateFromDx(d.localPosition.dx),
              onTapDown: (d) => updateFromDx(d.localPosition.dx),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // "Después" de fondo completo; "Antes" se recorta encima
                  // desde la izquierda, así el área 0..pos (donde está la
                  // etiqueta "Antes") realmente muestra la foto original.
                  widget.after,
                  ClipRect(
                    clipper: _RevealClipper(_pos),
                    child: widget.before,
                  ),
                  Positioned(
                    left: (w * _pos - 1).clamp(0.0, w - 2),
                    top: 0,
                    bottom: 0,
                    child: Container(width: 2, color: c.teal),
                  ),
                  Positioned(
                    left: (w * _pos - 16).clamp(0.0, w - 32),
                    top: widget.height / 2 - 16,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c.teal,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.drag_indicator_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 10,
                    bottom: 10,
                    child: _Tag(text: 'Antes'),
                  ),
                  const Positioned(
                    right: 10,
                    bottom: 10,
                    child: _Tag(text: 'Después'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(VRadius.sm),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RevealClipper extends CustomClipper<Rect> {
  _RevealClipper(this.pos);
  final double pos;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * pos, size.height);

  @override
  bool shouldReclip(covariant _RevealClipper oldClipper) =>
      oldClipper.pos != pos;
}
