// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_merchant_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteMerchantNotifierHash() =>
    r'156aa44b4e868d0d4cd773ca83678d1d0f6af958';

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

  Future<DeleteMerchantData> build(
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
    this.merchantId,
  ) : super.internal(
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
        );

  final String merchantId;

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

  @override
  Future<DeleteMerchantData> runNotifierBuild(
    covariant DeleteMerchantNotifier notifier,
  ) {
    return notifier.build(
      merchantId,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
