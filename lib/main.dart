import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'design_system/theme.dart';
import 'router.dart';

void main() {
  runApp(const ProviderScope(child: VitrinaApp()));
}

class VitrinaApp extends StatelessWidget {
  const VitrinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vitrina · Mind Core ERP',
      debugShowCheckedModeBanner: false,
      theme: VTheme.light(),
      darkTheme: VTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
