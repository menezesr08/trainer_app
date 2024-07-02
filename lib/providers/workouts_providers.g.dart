// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workouts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$baseWorkoutsHash() => r'b99ee42eaaea8b58df15c60397e2ff5510883a15';

/// See also [baseWorkouts].
@ProviderFor(baseWorkouts)
final baseWorkoutsProvider = FutureProvider<List<BaseWorkout>>.internal(
  baseWorkouts,
  name: r'baseWorkoutsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$baseWorkoutsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BaseWorkoutsRef = FutureProviderRef<List<BaseWorkout>>;
String _$completedWorkoutsHash() => r'3e4f32a3839f32d1bf11790ebb3a2932dfe91b47';

/// See also [completedWorkouts].
@ProviderFor(completedWorkouts)
final completedWorkoutsProvider =
    StreamProvider<List<CompletedWorkout>>.internal(
  completedWorkouts,
  name: r'completedWorkoutsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedWorkoutsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompletedWorkoutsRef = StreamProviderRef<List<CompletedWorkout>>;
String _$workoutsRepositoryHash() =>
    r'5e40639e0bec85f73d55a482a7fdce4891c6f5c8';

/// See also [workoutsRepository].
@ProviderFor(workoutsRepository)
final workoutsRepositoryProvider = Provider<WorkoutsRepository>.internal(
  workoutsRepository,
  name: r'workoutsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkoutsRepositoryRef = ProviderRef<WorkoutsRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
