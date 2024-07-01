// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leaderboardRepositoryHash() =>
    r'8b439139eb9b99eb87b3d87b56ea718df48ad0e5';

/// See also [leaderboardRepository].
@ProviderFor(leaderboardRepository)
final leaderboardRepositoryProvider =
    AutoDisposeProvider<LeaderboardRepository>.internal(
  leaderboardRepository,
  name: r'leaderboardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leaderboardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LeaderboardRepositoryRef
    = AutoDisposeProviderRef<LeaderboardRepository>;
String _$globalLeaderboardHash() => r'e2082a16b45c2a121a2ada103e4217dcd6ecaae8';

/// See also [globalLeaderboard].
@ProviderFor(globalLeaderboard)
final globalLeaderboardProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  globalLeaderboard,
  name: r'globalLeaderboardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalLeaderboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GlobalLeaderboardRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$localLeaderboardHash() => r'f2f164830a6553a49aeacd7db3faa50d0fd17928';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [localLeaderboard].
@ProviderFor(localLeaderboard)
const localLeaderboardProvider = LocalLeaderboardFamily();

/// See also [localLeaderboard].
class LocalLeaderboardFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [localLeaderboard].
  const LocalLeaderboardFamily();

  /// See also [localLeaderboard].
  LocalLeaderboardProvider call(
    String userID,
  ) {
    return LocalLeaderboardProvider(
      userID,
    );
  }

  @override
  LocalLeaderboardProvider getProviderOverride(
    covariant LocalLeaderboardProvider provider,
  ) {
    return call(
      provider.userID,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'localLeaderboardProvider';
}

/// See also [localLeaderboard].
class LocalLeaderboardProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [localLeaderboard].
  LocalLeaderboardProvider(
    String userID,
  ) : this._internal(
          (ref) => localLeaderboard(
            ref as LocalLeaderboardRef,
            userID,
          ),
          from: localLeaderboardProvider,
          name: r'localLeaderboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localLeaderboardHash,
          dependencies: LocalLeaderboardFamily._dependencies,
          allTransitiveDependencies:
              LocalLeaderboardFamily._allTransitiveDependencies,
          userID: userID,
        );

  LocalLeaderboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userID,
  }) : super.internal();

  final String userID;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(LocalLeaderboardRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocalLeaderboardProvider._internal(
        (ref) => create(ref as LocalLeaderboardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userID: userID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _LocalLeaderboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalLeaderboardProvider && other.userID == userID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LocalLeaderboardRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `userID` of this provider.
  String get userID;
}

class _LocalLeaderboardProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with LocalLeaderboardRef {
  _LocalLeaderboardProviderElement(super.provider);

  @override
  String get userID => (origin as LocalLeaderboardProvider).userID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
