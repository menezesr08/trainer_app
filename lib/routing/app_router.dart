import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/authentication/presentation/sign_in_screen.dart';
import 'package:trainer_app/features/chat/presentation/chat.dart';
import 'package:trainer_app/features/insights/presentation/individual_workout_insights.dart';
import 'package:trainer_app/features/insights/presentation/individual_workout_options.dart';
import 'package:trainer_app/features/onboarding/data/onboarding_repository.dart';
import 'package:trainer_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/features/plans/presentation/create_plan.dart';
import 'package:trainer_app/features/plans/presentation/plan_details.dart';
import 'package:trainer_app/features/plans/presentation/plans.dart';
import 'package:trainer_app/features/profile/presentation/completed_workouts_list.dart';
import 'package:trainer_app/features/profile/presentation/update_profile.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/features/workouts/presentation/completed_a_workout.dart';
import 'package:trainer_app/features/insights/presentation/insights.dart';

import 'package:trainer_app/features/profile/presentation/profile.dart';
import 'package:trainer_app/providers/auth_providers.dart';
import 'package:trainer_app/routing/app_startup.dart';
import 'package:trainer_app/routing/go_router_refresh_stream.dart';
import 'package:trainer_app/routing/not_found_screen.dart';
import 'package:trainer_app/routing/scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _plansNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'plans');
final _insightsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'insights');
final _leaderboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'leaderboard');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');
final _programmeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'programme');

enum AppRoute {
  onboarding,
  signIn,
  inputWorkouts,
  programmes,
  addProgramme,
  insights,
  leaderboard,
  profile,
  plans,
  createPlan,
  detail,
  completeWorkout,
  completedWorkouts,
  updateProfile,
  individualWorkoutOptions,
  individualWorkoutInsights,
  chat
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final appStartupState = ref.watch(appStartupProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/signIn',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    extraCodec: const MyExtraCodec(),
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
      print('Path is: ');
      print(path);
      if (isLoggedIn) {
        if (path.startsWith('/startup') || path.startsWith('/signIn')) {
          return '/plans';
        }
      } else {
        if (path.startsWith('/startup') ||
            path.startsWith('/plans') ||
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
          child: SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/completeWorkout',
        name: AppRoute.completeWorkout.name,
        builder: (context, state) {
          Plan plan = state.extra as Plan;
          return CompleteAWorkout(plan: plan);
        },
      ),
      GoRoute(
        path: '/chat/:flowString',
        name: AppRoute.chat.name,
        pageBuilder: (context, state) {
          final flow = state.pathParameters['flowString'];
          return NoTransitionPage(
            child: ChatPage(
              flowString: flow!,
            ),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, navigationShell) {
            return NoTransitionPage(
              child: ScaffoldWithNestedNavigation(
                  navigationShell: navigationShell),
            );
          },
          branches: [
            StatefulShellBranch(navigatorKey: _plansNavigatorKey, routes: [
              GoRoute(
                  path: '/plans',
                  name: AppRoute.plans.name,
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: Plans(),
                      ),
                  routes: [
                    GoRoute(
                      path: 'createPlan',
                      name: AppRoute.createPlan.name,
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: CreatePlan(),
                      ),
                    ),
                    GoRoute(
                      path: 'detail',
                      name: AppRoute.detail.name,
                      pageBuilder: (context, state) {
                        final plan = state.extra as Plan;
                        return NoTransitionPage(
                          child: PlanDetails(
                            plan: plan,
                          ),
                        );
                      },
                    ),
                  ]),
            ]),
            StatefulShellBranch(navigatorKey: _insightsNavigatorKey, routes: [
              GoRoute(
                  path: '/insights',
                  name: AppRoute.insights.name,
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: Insights(),
                      ),
                  routes: [
                    GoRoute(
                      path: 'individualWorkoutOptions',
                      name: AppRoute.individualWorkoutOptions.name,
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: IndividualWorkoutOptions(),
                      ),
                    ),
                    GoRoute(
                      path: 'individualWorkoutInsights',
                      name: AppRoute.individualWorkoutInsights.name,
                      pageBuilder: (context, state) {
                        final baseWorkout = state.extra as BaseWorkout?;
                        return NoTransitionPage(
                            child: IndividualWorkoutInsights(w: baseWorkout!));
                      },
                    ),
                  ]),
            ]),
            StatefulShellBranch(
                navigatorKey: _leaderboardNavigatorKey,
                routes: [
                  GoRoute(
                    path: '/leaderboard',
                    name: AppRoute.leaderboard.name,
                    pageBuilder: (context, state) => NoTransitionPage(
                      child: Container(),
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
                  routes: [
                    GoRoute(
                      path: 'completedWorkouts',
                      name: AppRoute.completedWorkouts.name,
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: CompletedWorkoutsList(),
                      ),
                    ),
                    GoRoute(
                      path: 'updateProfile',
                      name: AppRoute.updateProfile.name,
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: UpdateProfile(),
                      ),
                    ),
                  ]),
            ]),
            StatefulShellBranch(navigatorKey: _programmeNavigatorKey, routes: [
              GoRoute(
                  path: '/programmes',
                  name: AppRoute.programmes.name,
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: Profile(),
                      ),
                  routes: [
                    GoRoute(
                      path: 'add',
                      name: AppRoute.addProgramme.name,
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: Profile(),
                      ),
                    ),
                  ]),
            ]),
          ]),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}

class MyExtraCodec extends Codec<Object?, Object?> {
  const MyExtraCodec();

  @override
  Converter<Object?, Object?> get decoder => const _MyExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _MyExtraEncoder();
}

class _MyExtraDecoder extends Converter<Object?, Object?> {
  const _MyExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    final List<Object?> inputAsList = input as List<Object?>;
    if (inputAsList[0] == 'Plan') {
      return Plan.fromMap(inputAsList[1] as Map<String, dynamic>);
    }
    throw FormatException('Unable to parse input: $input');
  }
}

class _MyExtraEncoder extends Converter<Object?, Object?> {
  const _MyExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    if (input is Plan) {
      return <Object?>['Plan', input.toMap()];
    }

    if (input is BaseWorkout) {
      return <Object?>['BaseWorkout', input.toMap()];
    }
    throw FormatException('Cannot encode type ${input.runtimeType}');
  }
}
