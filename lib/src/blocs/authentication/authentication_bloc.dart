import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:pos/src/extensions.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:pos/src/utils.dart';
import '../../my_logger.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:collection/collection.dart';

final isAnonymousUserProvider = Provider((ref) {
  final s = ref.watch(authNotifierProvider);
  if (s is AuthenticationAuthenticated) {
    return s.user.isAnonymous;
  }
  return false;
});

final authNotifierProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationState>((ref) {
  return AuthenticationNotifier(ref: ref);
});

final isLoggedProvider = Provider<bool>((ref) {
  return ref.watch(posUserProvider) != null;
});

final posUserProvider = Provider<POSUser?>((ref) {
  final s = ref.watch(authNotifierProvider);
  if (s is AuthenticationAuthenticated) {
    return s.user;
  }
  return null;
});

final merchantsProvider = Provider<List<Merchant>>((ref) {
  final s = ref.watch(authNotifierProvider);
  if (s is AuthenticationAuthenticated) {
    return s.user.merchants;
  }
  return [];
});

final anonymousToken = '00000000000000000000000000000000';

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  final Ref ref;

  AuthenticationNotifier({
    required this.ref,
  }) : super(AuthenticationUninitialized()) {
    startApp();
  }

  startApp() async {
    try {
      final token = await ref.read(userRepositoryProvider).getToken();
      if (token == null) {
        state = AuthenticationUnauthenticated();
        return;
      }

      if (token == anonymousToken) {
        final pos = ref.read(getPosProvider);
        final user = await getAnonymousUser(pos);
        final merchant =
            user.merchants.firstWhere((element) => element.posList.isNotEmpty);
        ref.read(selectedPosProvider.notifier).state =
            SelectedPos(merchant, merchant.posList.first);
        state = AuthenticationAuthenticated(user, token);
        return;
      }

      if (JwtDecoder.isExpired(token)) {
        state = AuthenticationUnauthenticated();
        return;
      }

      final user = await ref.read(userRepositoryProvider).getUser(token);
      final lastMerchantAndPosIdUsed = await ref
          .read(userRepositoryProvider)
          .readLastMerchantIdAndPosIdUsed();
      if (lastMerchantAndPosIdUsed != null &&
          lastMerchantAndPosIdUsed.length == 2) {
        final merchantId = lastMerchantAndPosIdUsed[0];
        final posId = lastMerchantAndPosIdUsed[1];
        final merchant =
            user.merchants.firstWhereOrNull((m) => m.id == merchantId);
        if (merchant != null && merchant.posList.isNotEmpty) {
          final pos = merchant.posList.firstWhereOrNull((p) => p.id == posId);
          ref.read(selectedPosProvider.notifier).state =
              SelectedPos(merchant, pos ?? merchant.posList.first);
        }
      }
      state = AuthenticationAuthenticated(user, token);
    } catch (ex) {
      logger.i(ex.toString());
      state = AuthenticationUnauthenticated();
    }
  }

  logIn(LoggedIn event) async {
    await ref
        .read(userRepositoryProvider)
        .persistToken(event.user, event.email, event.password);

    final user = event.user;
    final m = user.merchants.firstWhere((m) => m.posList.isNotEmpty);
    final p = m.posList.first;
    ref.read(selectedPosProvider.notifier).state = SelectedPos(m, p);

    state = AuthenticationAuthenticated(user, event.token);
  }

  logOut() async {
    await ref.read(userRepositoryProvider).deleteToken();
    state = AuthenticationUnauthenticated();
  }

  Future refresh() async {
    final currentState = state;
    if (currentState is! AuthenticationAuthenticated) {
      return;
    }

    final user = await ref.read(userRepositoryProvider).getUser(
          currentState.token,
        );
    state = AuthenticationAuthenticated(user, currentState.token);
  }

  void deleteAccount() async {
    final currentState = state;
    if (currentState is AuthenticationAuthenticated) {
      final userId = currentState.user.id;
      final repo = ref.watch(userRepositoryProvider);
      final email = await repo.getSavedEmail();
      final password = await repo.getSavedPassword();
      if (email == null || password == null || userId == null) {
        throw Exception();
      }
      await ref.read(getPosProvider).deleteAccount(userId, email, password);
      logOut();
    }
  }
}
