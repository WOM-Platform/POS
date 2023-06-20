import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pos/src/blocs/login/bloc.dart';

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
        state = AuthenticationAuthenticated(user, token, true);
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
      } else {
        if (!(user.merchants.isEmpty ||
            user.merchants.fold<int>(
                    0,
                    (int previousValue, Merchant element) =>
                        previousValue + (element.posList.length)) ==
                0)) {
          final m = user.merchants.firstWhere((m) => m.posList.isNotEmpty);
          final p = m.posList.first;
          ref.read(selectedPosProvider.notifier).state = SelectedPos(m, p);
        }
      }
      state = AuthenticationAuthenticated(user, token, user.verified);
    } catch (ex, st) {
      logger.e(ex.toString());
      logger.e(st.toString());
      state = AuthenticationUnauthenticated();
    }
  }

  Future<AuthResponse?> login(String username, String password) async {
    logger.i('login');
    try {
      final authResponse = await ref.read(userRepositoryProvider).authenticate(
            username: username,
            password: password,
          );

      if (!authResponse.verified) {
        state = AuthenticationEmailNotVerified(
            username, password, authResponse.id, authResponse.token);
        return authResponse;
      }

      await ref
          .read(userRepositoryProvider)
          .persistJWTToken(authResponse.token);

      final user =
          await ref.read(userRepositoryProvider).getUser(authResponse.token);

      logger.i(user.name);
      logger.i(user.merchants.length);
      if (!(user.merchants.isEmpty ||
          user.merchants.fold<int>(
                  0,
                  (int previousValue, Merchant element) =>
                      previousValue + (element.posList.length)) ==
              0)) {
        final m = user.merchants.firstWhere((m) => m.posList.isNotEmpty);
        final p = m.posList.first;
        ref.read(selectedPosProvider.notifier).state = SelectedPos(m, p);
      }
      state =
          AuthenticationAuthenticated(user, authResponse.token, user.verified);
      return authResponse;
    } catch (ex, stack) {
      logger.e(ex);
      logger.e(stack);
      ref.read(loginErrorProvider.notifier).state =
          LoginFailure(error: "Username e/o password non validi!");
      return null;
    }
  }

  checkEmailVerification() async {
    if (state is AuthenticationEmailNotVerified) {
      await login(
        (state as AuthenticationEmailNotVerified).email,
        (state as AuthenticationEmailNotVerified).password,
      );
    }
  }

  sendEmailVerification() async {
    if (state is AuthenticationEmailNotVerified) {
      await ref.read(userRepositoryProvider).sendEmailVerification(
            (state as AuthenticationEmailNotVerified).userId,
            (state as AuthenticationEmailNotVerified).token,
          );
    }
  }

  anonymousLogin() async {
    final user = await getAnonymousUser(ref.read(getPosProvider));
    final m = user.merchants.firstWhere((m) => m.posList.isNotEmpty);
    final p = m.posList.first;
    ref.read(selectedPosProvider.notifier).state = SelectedPos(m, p);

    state = AuthenticationAuthenticated(user, anonymousToken, user.verified);
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
    if (!(user.merchants.isEmpty ||
        user.merchants.fold<int>(
                0,
                (int previousValue, Merchant element) =>
                    previousValue + (element.posList.length)) ==
            0)) {
      final m = user.merchants.firstWhere((m) => m.posList.isNotEmpty);
      final p = m.posList.first;
      ref.read(selectedPosProvider.notifier).state = SelectedPos(m, p);
    }
    state =
        AuthenticationAuthenticated(user, currentState.token, user.verified);
  }

  void deleteAccount() async {
    final currentState = state;
    if (currentState is AuthenticationAuthenticated) {
      final userId = currentState.user.id;
      final repo = ref.watch(userRepositoryProvider);
      final token = await repo.getToken();
      if (token == null) {
        throw Exception();
      }
      await ref.read(getPosProvider).deleteAccount(userId, token);
      logOut();
    }
  }
}
