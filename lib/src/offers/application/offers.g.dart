// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String _$RequestNotifierHash() => r'b7df7569071e39b99c75c4ea9e994b95df50afd7';

/// See also [RequestNotifier].
final requestNotifierProvider =
    AsyncNotifierProvider<RequestNotifier, HomeState>(
  RequestNotifier.new,
  name: r'requestNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$RequestNotifierHash,
);
typedef RequestNotifierRef = AsyncNotifierProviderRef<HomeState>;

abstract class _$RequestNotifier extends AsyncNotifier<HomeState> {
  @override
  FutureOr<HomeState> build();
}

String _$getPosHash() => r'ee9b5c43f694fa78393491316cdcb6faf9b315c1';

/// See also [getPos].
final getPosProvider = Provider<PosClient>(
  getPos,
  name: r'getPosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getPosHash,
);
typedef GetPosRef = ProviderRef<PosClient>;
String _$getSecureStorageHash() => r'6332fa91e7aff685b1ed579146881c124696d744';

/// See also [getSecureStorage].
final getSecureStorageProvider = AutoDisposeProvider<FlutterSecureStorage>(
  getSecureStorage,
  name: r'getSecureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSecureStorageHash,
);
typedef GetSecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
String _$getOffersHash() => r'ec9d345d24b4741e998f694d9d73d860c95b045a';

/// See also [getOffers].
class GetOffersProvider extends AutoDisposeFutureProvider<List<Offer>> {
  GetOffersProvider({
    this.posId,
  }) : super(
          (ref) => getOffers(
            ref,
            posId: posId,
          ),
          from: getOffersProvider,
          name: r'getOffersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getOffersHash,
        );

  final String? posId;

  @override
  bool operator ==(Object other) {
    return other is GetOffersProvider && other.posId == posId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, posId.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef GetOffersRef = AutoDisposeFutureProviderRef<List<Offer>>;

/// See also [getOffers].
final getOffersProvider = GetOffersFamily();

class GetOffersFamily extends Family<AsyncValue<List<Offer>>> {
  GetOffersFamily();

  GetOffersProvider call({
    String? posId,
  }) {
    return GetOffersProvider(
      posId: posId,
    );
  }

  @override
  AutoDisposeFutureProvider<List<Offer>> getProviderOverride(
    covariant GetOffersProvider provider,
  ) {
    return call(
      posId: provider.posId,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'getOffersProvider';
}
