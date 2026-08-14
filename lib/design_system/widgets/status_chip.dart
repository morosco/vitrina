import 'package:flutter/material.dart';

import '../colors.dart';
import '../tokens.dart';

enum VProductStatus { threeD, twoD, needsReview, error }

/// Chip de estado usado en la tabla de carga masiva y en el dashboard.
/// El teal queda reservado a `threeD` — el mismo código de color que el
/// [StudioSwitch] y el visor, para que el usuario aprenda un único
/// significado en toda la app.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.label});

  final VProductStatus status;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    late final Color fg;
    late final Color bg;
    late final String text;
    late final IconData icon;

    switch (status) {
      case VProductStatus.threeD:
        fg = c.tealStrong;
        bg = c.tealTint;
        text = label ?? '3D';
        icon = Icons.view_in_ar_rounded;
      case VProductStatus.twoD:
        fg = c.amber;
        bg = c.amberTint;
        text = label ?? '2D';
        icon = Icons.image_outlined;
      case VProductStatus.needsReview:
        fg = c.inkSoft;
        bg = c.surface2;
        text = label ?? 'Revisar';
        icon = Icons.flag_outlined;
      case VProductStatus.error:
        fg = c.danger;
        bg = c.dangerTint;
        text = label ?? 'Error';
        icon = Icons.error_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(VRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
