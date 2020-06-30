import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/material.dart';
import 'package:wom_package/wom_package.dart' as womPack;
import 'login_box.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  LoginScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: womPack.AnimatedBackground()),
          Positioned.fill(child: womPack.Particles(30)),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.center,
              child: ControlledAnimation(
                duration: Duration(milliseconds: 1500),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, opacity) {
                  return Opacity(
                    opacity: opacity,
                    child: LoginBox(
                      authenticationBloc: _authenticationBloc,
                      loginBloc: _loginBloc,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }
}

/*
class AnimatedBox extends StatelessWidget {
  static final boxDecoration = BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 5,
            offset: Offset(0, 8),
            spreadRadius: 2)
      ]);

  @override
  Widget build(BuildContext context) {
    final boxSideWidth = MediaQuery.of(context).size.width - 70;
    return ControlledAnimation(
      duration: Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: boxSideWidth),
      builder: (context, height) {
        return ControlledAnimation(
          duration: Duration(milliseconds: 1200),
          delay: Duration(milliseconds: 500),
          tween: Tween(begin: 2.0, end: boxSideWidth),
          builder: (context, width) {
            return Container(
              decoration: boxDecoration,
              width: width,
              height: height,
              child:
                  isEnoughRoomForTypewriter(width) ? LoginBox() : Container(),
            );
          },
        );
      },
    );
  }

  isEnoughRoomForTypewriter(width) => width > 0;
}
*/

/*
class TypewriterText extends StatelessWidget {
  static const TEXT_STYLE =
  TextStyle(letterSpacing: 5, fontSize: 20, fontWeight: FontWeight.w300);

  final String text;
  TypewriterText(this.text);

  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
        duration: Duration(milliseconds: 800),
        delay: Duration(milliseconds: 800),
        tween: IntTween(begin: 0, end: text.length),
        builder: (context, textLength) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text.substring(0, textLength), style: TEXT_STYLE),
              ControlledAnimation(
                playback: Playback.LOOP,
                duration: Duration(milliseconds: 600),
                tween: IntTween(begin: 0, end: 1),
                builder: (context, oneOrZero) {
                  return Opacity(
                      opacity: oneOrZero == 1 ? 1.0 : 0.0,
                      child: Text("_", style: TEXT_STYLE));
                },
              )
            ],
          );
        });
  }
}
*/
