import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/authentication/presentation/custom_sign_in_screen.dart';
import 'package:trainer_app/features/onboarding/data/onboarding_repository.dart';
import 'package:trainer_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:trainer_app/pages/workouts.dart';
import 'package:trainer_app/pages/insights.dart';
import 'package:trainer_app/pages/leaderboard.dart';
import 'package:trainer_app/pages/profile.dart';
import 'package:trainer_app/routing/app_startup.dart';
import 'package:trainer_app/routing/go_router_refresh_stream.dart';
import 'package:trainer_app/routing/not_found_screen.dart';
import 'package:trainer_app/routing/scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _workoutsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'workouts');
final _insightsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'insights');
final _leaderboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'leaderboard');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

enum AppRoute {
  onboarding,
  signIn,
  inputWorkouts,
  insights,
  leaderboard,
  profile
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final appStartupState = ref.watch(appStartupProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/signIn',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/startup';
      }

      final onboardingRepository =
          ref.read(onboardingRepositoryProvider).requireValue;
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      final path = state.uri.path;
      if (!didCompleteOnboarding) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (path != '/onboarding') {
          return '/onboarding';
        }
        return null;
      }

      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (path.startsWith('/startup') ||
            path.startsWith('/onboarding') ||
            path.startsWith('/signIn')) {
          return '/workouts';
        }
      } else {
        if (path.startsWith('/startup') ||
            path.startsWith('/onboarding') ||
            path.startsWith('/workouts') ||
            path.startsWith('/account')) {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/startup',
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(
            // * This is just a placeholder
            // * The loaded route will be managed by GoRouter on state change
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CustomSignInScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, navigationShell) => NoTransitionPage(
                child: ScaffoldWithNestedNavigation(
                    navigationShell: navigationShell),
              ),
          branches: [
            StatefulShellBranch(navigatorKey: _workoutsNavigatorKey, routes: [
              GoRoute(
                path: '/workouts',
                name: AppRoute.inputWorkouts.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: Workouts(),
                ),
              ),
            ]),
            StatefulShellBranch(navigatorKey: _insightsNavigatorKey, routes: [
              GoRoute(
                path: '/insights',
                name: AppRoute.insights.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Insights(),
                ),
              ),
            ]),
            StatefulShellBranch(
                navigatorKey: _leaderboardNavigatorKey,
                routes: [
                  GoRoute(
                    path: '/leaderboard',
                    name: AppRoute.leaderboard.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: Leaderboard(),
                    ),
                  ),
                ]),
            StatefulShellBranch(navigatorKey: _profileNavigatorKey, routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Profile(),
                ),
              ),
            ]),
          ]),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}
