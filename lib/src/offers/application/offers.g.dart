// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getPosHash() => r'ee9b5c43f694fa78393491316cdcb6faf9b315c1';

/// See also [getPos].
@ProviderFor(getPos)
final getPosProvider = Provider<PosClient>.internal(
  getPos,
  name: r'getPosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getPosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetPosRef = ProviderRef<PosClient>;
String _$getSecureStorageHash() => r'6332fa91e7aff685b1ed579146881c124696d744';

/// See also [getSecureStorage].
@ProviderFor(getSecureStorage)
final getSecureStorageProvider =
    AutoDisposeProvider<FlutterSecureStorage>.internal(
  getSecureStorage,
  name: r'getSecureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSecureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetSecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
String _$cloudOffersNotifierHash() =>
    r'f9764fdb230652c6456f2820b1d1e1caeb1603a3';

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

abstract class _$CloudOffersNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Offer>> {
  late final String? posId;

  Future<List<Offer>> build(
    String? posId,
  );
}

/// See also [CloudOffersNotifier].
@ProviderFor(CloudOffersNotifier)
const cloudOffersNotifierProvider = CloudOffersNotifierFamily();

/// See also [CloudOffersNotifier].
class CloudOffersNotifierFamily extends Family<AsyncValue<List<Offer>>> {
  /// See also [CloudOffersNotifier].
  const CloudOffersNotifierFamily();

  /// See also [CloudOffersNotifier].
  CloudOffersNotifierProvider call(
    String? posId,
  ) {
    return CloudOffersNotifierProvider(
      posId,
    );
  }

  @override
  CloudOffersNotifierProvider getProviderOverride(
    covariant CloudOffersNotifierProvider provider,
  ) {
    return call(
      provider.posId,
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
  String? get name => r'cloudOffersNotifierProvider';
}

/// See also [CloudOffersNotifier].
class CloudOffersNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CloudOffersNotifier, List<Offer>> {
  /// See also [CloudOffersNotifier].
  CloudOffersNotifierProvider(
    this.posId,
  ) : super.internal(
          () => CloudOffersNotifier()..posId = posId,
          from: cloudOffersNotifierProvider,
          name: r'cloudOffersNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cloudOffersNotifierHash,
          dependencies: CloudOffersNotifierFamily._dependencies,
          allTransitiveDependencies:
              CloudOffersNotifierFamily._allTransitiveDependencies,
        );

  final String? posId;

  @override
  bool operator ==(Object other) {
    return other is CloudOffersNotifierProvider && other.posId == posId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, posId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Future<List<Offer>> runNotifierBuild(
    covariant CloudOffersNotifier notifier,
  ) {
    return notifier.build(
      posId,
    );
  }
}

String _$requestNotifierHash() => r'78996f82d45eb5f6639a066dee2ec22f0ba8f9ed';

/// See also [RequestNotifier].
@ProviderFor(RequestNotifier)
final requestNotifierProvider =
    AsyncNotifierProvider<RequestNotifier, HomeState>.internal(
  RequestNotifier.new,
  name: r'requestNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$requestNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RequestNotifier = AsyncNotifier<HomeState>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
