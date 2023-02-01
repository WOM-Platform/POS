import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/services/user_repository.dart';
import '../../../app.dart';
import '../../my_logger.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:collection/collection.dart';

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
      // final user = await userRepository.readUser();
      final user = await ref.read(userRepositoryProvider).autoLogin();
      if (user != null) {
        // globalUser = user;
        // await ref
        //     .read(homeNotifierProvider.notifier)
        //     .checkAndSetPreviousSelectedMerchantAndPos();

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

        // await ref.read(homeNotifierProvider.notifier).loadRequest();
        state = AuthenticationAuthenticated(user);
      } else {
        state = AuthenticationUnauthenticated();
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

    // globalUser = user;
    // ref.read(homeNotifierProvider.notifier).loadRequest();

    state = AuthenticationAuthenticated(user);
  }

  logOut() async {
    ref.read(homeNotifierProvider.notifier).clear();
    await ref.read(userRepositoryProvider).deleteToken();
    state = AuthenticationUnauthenticated();
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
