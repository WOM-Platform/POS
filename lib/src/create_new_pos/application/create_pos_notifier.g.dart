// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_pos_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createPOSNotifierHash() => r'46ffd75254972658f847d5966a67085ea8851ff9';

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

abstract class _$CreatePOSNotifier
    extends BuildlessAutoDisposeNotifier<CreatePOSState> {
  late final String merchantId;

  CreatePOSState build(
    String merchantId,
  );
}

/// See also [CreatePOSNotifier].
@ProviderFor(CreatePOSNotifier)
const createPOSNotifierProvider = CreatePOSNotifierFamily();

/// See also [CreatePOSNotifier].
class CreatePOSNotifierFamily extends Family<CreatePOSState> {
  /// See also [CreatePOSNotifier].
  const CreatePOSNotifierFamily();

  /// See also [CreatePOSNotifier].
  CreatePOSNotifierProvider call(
    String merchantId,
  ) {
    return CreatePOSNotifierProvider(
      merchantId,
    );
  }

  @override
  CreatePOSNotifierProvider getProviderOverride(
    covariant CreatePOSNotifierProvider provider,
  ) {
    return call(
      provider.merchantId,
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
  String? get name => r'createPOSNotifierProvider';
}

/// See also [CreatePOSNotifier].
class CreatePOSNotifierProvider
    extends AutoDisposeNotifierProviderImpl<CreatePOSNotifier, CreatePOSState> {
  /// See also [CreatePOSNotifier].
  CreatePOSNotifierProvider(
    String merchantId,
  ) : this._internal(
          () => CreatePOSNotifier()..merchantId = merchantId,
          from: createPOSNotifierProvider,
          name: r'createPOSNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createPOSNotifierHash,
          dependencies: CreatePOSNotifierFamily._dependencies,
          allTransitiveDependencies:
              CreatePOSNotifierFamily._allTransitiveDependencies,
          merchantId: merchantId,
        );

  CreatePOSNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.merchantId,
  }) : super.internal();

  final String merchantId;

  @override
  CreatePOSState runNotifierBuild(
    covariant CreatePOSNotifier notifier,
  ) {
    return notifier.build(
      merchantId,
    );
  }

  @override
  Override overrideWith(CreatePOSNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CreatePOSNotifierProvider._internal(
        () => create()..merchantId = merchantId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        merchantId: merchantId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CreatePOSNotifier, CreatePOSState>
      createElement() {
    return _CreatePOSNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreatePOSNotifierProvider && other.merchantId == merchantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, merchantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CreatePOSNotifierRef on AutoDisposeNotifierProviderRef<CreatePOSState> {
  /// The parameter `merchantId` of this provider.
  String get merchantId;
}

class _CreatePOSNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<CreatePOSNotifier,
        CreatePOSState> with CreatePOSNotifierRef {
  _CreatePOSNotifierProviderElement(super.provider);

  @override
  String get merchantId => (origin as CreatePOSNotifierProvider).merchantId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
