import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/recover_password_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/pages/reset_password_page.dart';
import '../../features/coleta/presentation/pages/coletas_page.dart';
import '../../features/home/presentation/pages/inicio_page.dart';
import '../../features/sync/presentation/pages/sync_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/preferencias_notificacao_page.dart';
import '../../features/coleta/presentation/pages/nova_coleta_page.dart';
import '../../features/coleta/presentation/pages/detalhes_coleta_page.dart';
import '../../features/coleta/presentation/pages/motivo_rejeicao_page.dart';

import '../navigation/main_page.dart';

const _publicRoutes = {
  '/login',
  '/register',
  '/recover-password',
  '/reset-password',
};

GoRouter createAppRouter(AuthNotifier authNotifier) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier,
    redirect: (_, GoRouterState state) {
      final isPublic = _publicRoutes.contains(state.matchedLocation);
      final isAuthenticated = authNotifier.status == AuthStatus.authenticated;

      if (!isAuthenticated && !isPublic) return '/login';

      if (isAuthenticated && isPublic) return '/home';

      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(
        path: '/recover-password',
        builder: (_, __) => const RecoverPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (_, GoRouterState state) {
          final extra = state.extra as Map<String, String>?;
          return ResetPasswordPage(
            token: extra?['token'],
            email: extra?['email'],
          );
        },
      ),

      GoRoute(
        path: '/notificacoes',
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(path: '/perfil', builder: (_, __) => const ProfilePage()),
      GoRoute(
        path: '/perfil/preferencias-notificacao',
        builder: (_, __) => const PreferenciasNotificacaoPage(),
      ),
      GoRoute(path: '/nova-coleta', builder: (_, __) => const NovaColetaPage()),
      GoRoute(
        path: '/detalhes-coleta',
        builder: (_, GoRouterState state) =>
            DetalhesColetaPage(id: state.extra as String?),
      ),
      GoRoute(
        path: '/motivo-rejeicao',
        builder: (_, __) => const MotivoRejeicaoPage(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            MainPage(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(path: '/home', builder: (_, __) => const InicioPage()),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/coletas',
                builder: (_, __) => const ColetasPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/sincronizar',
                builder: (_, __) => const SyncPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
