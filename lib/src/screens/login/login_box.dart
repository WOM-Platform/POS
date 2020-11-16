import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import '../../constants.dart';
import '../../utils.dart';
import 'load_stuff_button.dart';

class LoginBox extends StatefulWidget {
  const LoginBox({
    Key key,
  }) : super(key: key);

  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is InsufficientPos) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).translate('in')),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (
          BuildContext context,
          LoginState state,
        ) {
          return Center(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
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
                            const Spacer(),
                            Image.asset(
                              'assets/logo_wom.png',
                              height: 50.0,
                            ),
                            const Spacer(),
                            TextField(
                              controller:
                                  context.bloc<LoginBloc>().usernameController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                prefixIcon: Icon(Icons.account_circle),
                              ),
                            ),
                            const Spacer(),
                            TextField(
                              obscureText: true,
                              controller:
                                  context.bloc<LoginBloc>().passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            const Spacer(),
                            LoadStuffButton(
                              onTap: _onLoginButtonPressed,
                            ),
                            const Spacer(),
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
                          context.bloc<LoginBloc>().add(AnonymousLogin());
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
                const SizedBox(
                  height: 8.0,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      launchUrl('https://$domain/user/register-merchant'),
                  child: RichText(
                    textAlign: TextAlign.center,
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
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _onLoginButtonPressed() {
    final password = context.bloc<LoginBloc>().passwordController.text;
    if (password.length > 5) {
      FocusScope.of(context).requestFocus(new FocusNode());
      context.bloc<LoginBloc>().add(LoginButtonPressed(
            username: context.bloc<LoginBloc>().usernameController.text.trim(),
            password: context.bloc<LoginBloc>().passwordController.text,
          ));
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }
}
