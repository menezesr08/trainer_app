import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/authentication/presentation/custom_sign_in_screen.dart';
import 'package:trainer_app/features/onboarding/data/onboarding_repository.dart';
import 'package:trainer_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:trainer_app/pages/input_workouts.dart';
import 'package:trainer_app/routing/app_startup.dart';
import 'package:trainer_app/routing/go_router_refresh_stream.dart';
import 'package:trainer_app/routing/not_found_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  onboarding,
  signIn,
  inputWorkouts,
  jobs,
  job,
  addJob,
  editJob,
  entry,
  addEntry,
  editEntry,
  entries,
  profile,
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
        final didCompleteOnboarding =
            onboardingRepository.isOnboardingComplete();
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
            return '/inputWorkouts';
          }
        } else {
          if (path.startsWith('/startup') ||
              path.startsWith('/onboarding') ||
              path.startsWith('/inputWorkouts') ||
              path.startsWith('/account')) {
            return '/signIn';
          }
        }
        return null;
      },
      refreshListenable:
          GoRouterRefreshStream(authRepository.authStateChanges()),
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

        GoRoute(
          path: '/inputWorkouts',
          name: AppRoute.inputWorkouts.name,
          pageBuilder: (context, state) =>  NoTransitionPage(
            child: InputWorkouts(),
          ),
        ),
      ],
      
      errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),);
}
