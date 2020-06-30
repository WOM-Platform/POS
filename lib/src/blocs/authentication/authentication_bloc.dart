import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:meta/meta.dart';
import 'package:pos/src/services/user_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        final User user = await userRepository.readUser();
        if (user != null) {
          yield AuthenticationAuthenticated(user);
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (ex) {
        print(ex.toString());
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
//      yield AuthenticationLoading();
      await userRepository.persistToken(
          event.user, event.email, event.password);
      yield AuthenticationAuthenticated(event.user);
    }

    if (event is LoggedOut) {
//      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
