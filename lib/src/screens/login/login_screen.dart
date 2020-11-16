import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: womPack.AnimatedBackground()),
          Positioned.fill(child: womPack.Particles(30)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Align(
              alignment: Alignment.center,
              child: ControlledAnimation(
                duration: Duration(milliseconds: 1500),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, opacity) {
                  return Opacity(
                    opacity: opacity,
                    child: LoginBox(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
