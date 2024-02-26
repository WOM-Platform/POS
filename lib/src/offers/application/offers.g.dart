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
    r'75898b7bc5c23c9e84a07db11a907de385713bb4';

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

  FutureOr<List<Offer>> build(
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
    String? posId,
  ) : this._internal(
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
          posId: posId,
        );

  CloudOffersNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.posId,
  }) : super.internal();

  final String? posId;

  @override
  FutureOr<List<Offer>> runNotifierBuild(
    covariant CloudOffersNotifier notifier,
  ) {
    return notifier.build(
      posId,
    );
  }

  @override
  Override overrideWith(CloudOffersNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CloudOffersNotifierProvider._internal(
        () => create()..posId = posId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        posId: posId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CloudOffersNotifier, List<Offer>>
      createElement() {
    return _CloudOffersNotifierProviderElement(this);
  }

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
}

mixin CloudOffersNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Offer>> {
  /// The parameter `posId` of this provider.
  String? get posId;
}

class _CloudOffersNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CloudOffersNotifier,
        List<Offer>> with CloudOffersNotifierRef {
  _CloudOffersNotifierProviderElement(super.provider);

  @override
  String? get posId => (origin as CloudOffersNotifierProvider).posId;
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
