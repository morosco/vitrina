import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'design_system/colors.dart';
import 'design_system/tokens.dart';

/// Cascarón de navegación entre las 4 secciones principales del prototipo.
/// El visor 3D no vive aquí — se abre como pantalla de detalle desde un
/// producto (categorías, dashboard), como en el flujo real del comprador.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  static const _destinations = [
    (
      path: '/manual',
      icon: Icons.add_box_outlined,
      selectedIcon: Icons.add_box_rounded,
      label: 'Alta manual',
    ),
    (
      path: '/bulk',
      icon: Icons.upload_file_outlined,
      selectedIcon: Icons.upload_file_rounded,
      label: 'Alta masiva',
    ),
    (
      path: '/categories',
      icon: Icons.category_outlined,
      selectedIcon: Icons.category_rounded,
      label: 'Categorías',
    ),
    (
      path: '/dashboard',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
      label: 'Dashboard',
    ),
  ];

  int get _currentIndex {
    final i = _destinations.indexWhere((d) => location.startsWith(d.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    final wide = MediaQuery.sizeOf(context).width >= 900;

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: c.surface,
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) =>
                  _go(context, _destinations[i].path),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: VSpace.lg),
                child: _Brand(c: c),
              ),
              destinations: _destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
            ),
            VerticalDivider(width: 1, color: c.line),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: c.surface,
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => _go(context, _destinations[i].path),
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
            )
            .toList(),
      ),
    );
  }

  void _go(BuildContext context, String path) {
    if (path != location) context.go(path);
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.c});
  final VColors c;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c.teal, c.tealStrong],
            ),
          ),
          child: const Icon(
            Icons.change_history_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Vitrina',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: c.ink,
          ),
        ),
      ],
    );
  }
}
