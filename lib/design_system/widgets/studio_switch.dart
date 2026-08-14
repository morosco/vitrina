import 'package:flutter/material.dart';

import '../colors.dart';
import '../tokens.dart';

/// El switch "Convertir a 3D": la única decisión técnica que el spec
/// permite exponer como control simple, en vez de un formulario.
///
/// Microinteracción "encendido de estudio": al activarse, un pulso de luz
/// teal recorre el borde antes de asentarse — la metáfora es literal, se
/// "enciende" la dimensión.
class StudioSwitch extends StatefulWidget {
  const StudioSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Convertir a 3D',
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  State<StudioSwitch> createState() => _StudioSwitchState();
}

class _StudioSwitchState extends State<StudioSwitch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _toggle() {
    final next = !widget.value;
    widget.onChanged(next);
    if (next) {
      _pulse.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    final on = widget.value;

    return Semantics(
      toggled: on,
      label: widget.label,
      child: GestureDetector(
        onTap: _toggle,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) {
            final glow = on ? (1 - _pulse.value).clamp(0.0, 1.0) : 0.0;
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: VSpace.md,
                vertical: VSpace.sm + 2,
              ),
              decoration: BoxDecoration(
                color: on ? c.tealTint : c.surface,
                borderRadius: BorderRadius.circular(VRadius.md),
                border: Border.all(color: on ? c.teal : c.line),
                boxShadow: glow > 0
                    ? [
                        BoxShadow(
                          color: c.teal.withValues(alpha: 0.35 * glow),
                          blurRadius: 18 * glow + 2,
                          spreadRadius: 1 * glow,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    on ? Icons.view_in_ar_rounded : Icons.image_outlined,
                    size: 18,
                    color: on ? c.tealStrong : c.inkFaint,
                  ),
                  const SizedBox(width: VSpace.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: on ? c.tealInk : c.ink,
                        ),
                      ),
                      Text(
                        on
                            ? 'Encendido — se genera el modelo 3D'
                            : 'Apagado — se publica en 2D mejorado',
                        style: TextStyle(fontSize: 11, color: c.inkFaint),
                      ),
                    ],
                  ),
                  const SizedBox(width: VSpace.md),
                  AnimatedContainer(
                    duration: VDuration.standard,
                    curve: Curves.easeOutCubic,
                    width: 44,
                    height: 26,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: on ? c.teal : c.surface2,
                      borderRadius: BorderRadius.circular(VRadius.pill),
                      border: Border.all(color: on ? c.teal : c.line),
                    ),
                    alignment: on
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
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
