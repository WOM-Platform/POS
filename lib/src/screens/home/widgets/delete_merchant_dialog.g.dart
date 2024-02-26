// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_merchant_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteMerchantNotifierHash() =>
    r'e10bf5e718f92f6c3e8769355a0acb38adf5dbe7';

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

abstract class _$DeleteMerchantNotifier
    extends BuildlessAutoDisposeAsyncNotifier<DeleteMerchantData> {
  late final String merchantId;

  FutureOr<DeleteMerchantData> build(
    String merchantId,
  );
}

/// See also [DeleteMerchantNotifier].
@ProviderFor(DeleteMerchantNotifier)
const deleteMerchantNotifierProvider = DeleteMerchantNotifierFamily();

/// See also [DeleteMerchantNotifier].
class DeleteMerchantNotifierFamily
    extends Family<AsyncValue<DeleteMerchantData>> {
  /// See also [DeleteMerchantNotifier].
  const DeleteMerchantNotifierFamily();

  /// See also [DeleteMerchantNotifier].
  DeleteMerchantNotifierProvider call(
    String merchantId,
  ) {
    return DeleteMerchantNotifierProvider(
      merchantId,
    );
  }

  @override
  DeleteMerchantNotifierProvider getProviderOverride(
    covariant DeleteMerchantNotifierProvider provider,
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
  String? get name => r'deleteMerchantNotifierProvider';
}

/// See also [DeleteMerchantNotifier].
class DeleteMerchantNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DeleteMerchantNotifier,
        DeleteMerchantData> {
  /// See also [DeleteMerchantNotifier].
  DeleteMerchantNotifierProvider(
    String merchantId,
  ) : this._internal(
          () => DeleteMerchantNotifier()..merchantId = merchantId,
          from: deleteMerchantNotifierProvider,
          name: r'deleteMerchantNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteMerchantNotifierHash,
          dependencies: DeleteMerchantNotifierFamily._dependencies,
          allTransitiveDependencies:
              DeleteMerchantNotifierFamily._allTransitiveDependencies,
          merchantId: merchantId,
        );

  DeleteMerchantNotifierProvider._internal(
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
  FutureOr<DeleteMerchantData> runNotifierBuild(
    covariant DeleteMerchantNotifier notifier,
  ) {
    return notifier.build(
      merchantId,
    );
  }

  @override
  Override overrideWith(DeleteMerchantNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeleteMerchantNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<DeleteMerchantNotifier,
      DeleteMerchantData> createElement() {
    return _DeleteMerchantNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteMerchantNotifierProvider &&
        other.merchantId == merchantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, merchantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteMerchantNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<DeleteMerchantData> {
  /// The parameter `merchantId` of this provider.
  String get merchantId;
}

class _DeleteMerchantNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DeleteMerchantNotifier,
        DeleteMerchantData> with DeleteMerchantNotifierRef {
  _DeleteMerchantNotifierProviderElement(super.provider);

  @override
  String get merchantId =>
      (origin as DeleteMerchantNotifierProvider).merchantId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
