import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import '../../constants.dart';
import '../../utils.dart';
import 'load_stuff_button.dart';

class LoginBox extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;

  const LoginBox({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  FocusNode _focusNode = FocusNode();

  LoginBloc get _loginBloc => widget.loginBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          onWidgetDidBuild(
            () {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        }
        return Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Spacer(),
                            Image.asset(
                              'assets/logo_wom.png',
                              height: 50.0,
                            ),
                            Spacer(),
                            Spacer(),
                            TextField(
                              controller: _loginBloc.usernameController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                prefixIcon: Icon(Icons.account_circle),
                              ),
                            ),
                            Spacer(),
                            TextField(
                              obscureText: true,
                              controller: _loginBloc.passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            Spacer(),
                            LoadStuffButton(
                              loginBloc: _loginBloc,
                              onTap: _onLoginButtonPressed,
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(4),
                  child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        splashColor: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          _loginBloc.add(AnonymousLogin());
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              'Accesso Anonimo',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    launchUrl('https://$domain/user/register-merchant'),
                child: RichText(
                  text: TextSpan(
                    text: 'Non sei registrato? ',
                    children: [
                      TextSpan(
                        text: 'Clicca qui',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _onLoginButtonPressed() {
    final password = _loginBloc.passwordController.text;
    if (password.length > 5) {
      FocusScope.of(context).requestFocus(new FocusNode());
      _loginBloc.add(LoginButtonPressed(
        username: _loginBloc.usernameController.text,
        password: _loginBloc.passwordController.text,
      ));
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }
}
