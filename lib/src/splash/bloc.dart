import 'package:bloc/bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() {
    Future.delayed(Duration(seconds: 1), () {
      add(SplashEvent.LOAD);
    });
  }

  @override
  get initialState => SplashState.START;

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    switch (event) {
      case SplashEvent.LOAD:
        yield SplashState.LOADING;
        Future.delayed(Duration(seconds: 1), () {
          add(SplashEvent.GOTOHOME);
        });
        break;
      case SplashEvent.GOTOHOME:
        yield SplashState.END;
        break;
    }
  }
}

enum SplashState { START, LOADING, END }

enum SplashEvent { LOAD, GOTOHOME }
