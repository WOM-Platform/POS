import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/blocs/home/bloc.dart';
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

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  final Ref ref;

  AuthenticationNotifier({
    required this.ref,
  }) : super(AuthenticationUninitialized()) {
    startApp();
  }

  startApp() async {
    try {
      final email = await ref.read(userRepositoryProvider).getSavedEmail();
      final password =
          await ref.read(userRepositoryProvider).getSavedPassword();
      if (email == null || password == null) {
        state = AuthenticationUnauthenticated();
        return;
      }
      if (email == anonymousEmail && password == anonymousPassword) {
        final pos = ref.read(getPosProvider);
        final user = await getAnonymousUser(pos);
        final merchant =
            user.merchants.firstWhere((element) => element.posList.isNotEmpty);
        ref.read(selectedPosProvider.notifier).state =
            SelectedPos(merchant, merchant.posList.first);
        state = AuthenticationAuthenticated(user, email, password);
      } else {
        final user = await ref
            .read(userRepositoryProvider)
            .authenticate(username: email, password: password);
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
        state = AuthenticationAuthenticated(user, email, password);
      }
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

    state = AuthenticationAuthenticated(user, event.email, event.password);
  }

  logOut() async {
    ref.read(homeNotifierProvider.notifier).clear();
    await ref.read(userRepositoryProvider).deleteToken();
    state = AuthenticationUnauthenticated();
  }

  Future refresh() async {
    final currentState = state;
    if (currentState is! AuthenticationAuthenticated) {
      return;
    }

    final user = await ref.read(userRepositoryProvider).authenticate(
          username: currentState.email,
          password: currentState.password,
        );
    state = AuthenticationAuthenticated(
      user,
      currentState.email,
      currentState.password,
    );
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
/*  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        final user = await userRepository.readUser();
        if (user != null) {
          globalUser = user;
          homeBloc.checkAndSetPreviousSelectedMerchantAndPos();
          homeBloc.add(LoadRequest());
          yield AuthenticationAuthenticated(user);
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (ex) {
        logger.i(ex.toString());
        yield AuthenticationUnauthenticated();
      }
    } else if (event is LoggedIn) {
      await userRepository.persistToken(
          event.user, event.email, event.password);

      final user = event.user;

      globalUser = user;
      homeBloc.add(LoadRequest());

      yield AuthenticationAuthenticated(user);
    } else if (event is LoggedOut) {}
  }*/
}
