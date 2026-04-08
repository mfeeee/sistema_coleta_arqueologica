import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/recover_password_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/coleta/pages/coletas_page.dart';
import '../../features/menu/pages/menu_page.dart';
import '../navigation/main_page.dart';

/// Configuração centralizada de rotas para o app
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/recover-password',
      builder: (BuildContext context, GoRouterState state) => const RecoverPasswordPage(),
    ),
    // StatefulShellRoute preserva o estado de cada aba na BottomNavigationBar
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return MainPage(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              builder: (BuildContext context, GoRouterState state) => const InicioPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/coletas',
              builder: (BuildContext context, GoRouterState state) => const ColetasPage(),
            ),
          ],
        ),
        // Futuras StatefulShellBranch ficam aqui
      ],
    ),
  ],
);