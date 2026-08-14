import 'package:flutter/material.dart';

import '../colors.dart';
import '../tokens.dart';

/// Indicador de progreso del wizard — un punto por paso, coherente con el
/// wireframe de alta manual.
class StepDots extends StatelessWidget {
  const StepDots({super.key, required this.total, required this.current});

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return Row(
      children: List.generate(total, (i) {
        final done = i <= current;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : VSpace.xs),
            height: 4,
            decoration: BoxDecoration(
              color: done ? c.teal : c.lineSoft,
              borderRadius: BorderRadius.circular(VRadius.pill),
            ),
          ),
        );
      }),
    );
  }
}
