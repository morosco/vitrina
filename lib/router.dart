import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import 'features/bulk_upload/bulk_upload_screen.dart';
import 'features/categories_showroom/categories_showroom_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/onboarding_wizard/manual_wizard_screen.dart';
import 'features/viewer_3d/viewer_3d_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/manual',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.matchedLocation, child: child),
      routes: [
        GoRoute(
          path: '/manual',
          builder: (context, state) => const ManualWizardScreen(),
        ),
        GoRoute(
          path: '/bulk',
          builder: (context, state) => const BulkUploadScreen(),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesShowroomScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/viewer/:productId',
      builder: (context, state) =>
          Viewer3DScreen(productId: state.pathParameters['productId']!),
    ),
  ],
);
