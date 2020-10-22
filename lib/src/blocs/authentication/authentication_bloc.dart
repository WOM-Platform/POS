import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:meta/meta.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/services/user_repository.dart';
import '../../../app.dart';
import '../../my_logger.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final HomeBloc homeBloc;

  AuthenticationBloc({
    @required this.homeBloc,
    @required this.userRepository,
  }) : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        final user = await userRepository.readUser();
        final lastMerchantAndPosIdUsed = await userRepository.readLastPosId();
        final merchantId = lastMerchantAndPosIdUsed[0];
        final posId = lastMerchantAndPosIdUsed[1];
        if (user != null) {
          globalUser = user;
          homeBloc.user = user;
          if (merchantId == null || merchantId.isEmpty) {
            homeBloc.add(LoadRequest());
          } else {
            homeBloc.setMerchantAndPosId(merchantId, posId);
          }

          yield AuthenticationAuthenticated(user);
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (ex) {
        logger.i(ex.toString());
        yield AuthenticationUnauthenticated();
      }
    } else if (event is LoggedIn) {
//      yield AuthenticationLoading();
      await userRepository.persistToken(
          event.user, event.email, event.password);
      globalUser = event.user;
      homeBloc.user = event.user;
      homeBloc.add(LoadRequest());

      yield AuthenticationAuthenticated(event.user);
    } else if (event is LoggedOut) {
//      yield AuthenticationLoading();
      homeBloc.clear();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
