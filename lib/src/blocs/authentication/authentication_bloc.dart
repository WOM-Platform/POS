import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/services/user_repository.dart';
import '../../../app.dart';
import '../../my_logger.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc
    extends Cubit<AuthenticationState> {
  final UserRepository userRepository;
  final HomeBloc homeBloc;

  AuthenticationBloc({
    required this.homeBloc,
    required this.userRepository,
  }) : super(AuthenticationUninitialized());

  startApp() async {
    try {
      // final user = await userRepository.readUser();
      final user = await userRepository.autoLogin();
      if (user != null) {
        globalUser = user;
        await homeBloc.checkAndSetPreviousSelectedMerchantAndPos();
        await homeBloc.loadRequest();
        emit(AuthenticationAuthenticated(user));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (ex) {
      logger.i(ex.toString());
      emit(AuthenticationUnauthenticated());
    }
  }

  logIn(LoggedIn event) async {
    await userRepository.persistToken(event.user, event.email, event.password);

    final user = event.user;

    globalUser = user;
    homeBloc.loadRequest();

    emit(AuthenticationAuthenticated(user));
  }

  logOut() async {
    homeBloc.clear();
    await userRepository.deleteToken();
    emit(AuthenticationUnauthenticated());
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
