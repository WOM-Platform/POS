import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import '../../constants.dart';
import '../../utils.dart';
import 'load_stuff_button.dart';
import 'no_merchant_screen.dart';

class LoginBox extends StatefulWidget {
  const LoginBox({
    Key? key,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is InsufficientPos) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoMerchantScreen()));
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Spacer(),
                            Image.asset(
                              'assets/logo_wom.png',
                              height: 60.0,
                            ),
                            const Spacer(),
                            TextField(
                              controller:
                                  context.read<LoginBloc>().usernameController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            const Spacer(),
                            TextField(
                              obscureText: true,
                              controller:
                                  context.read<LoginBloc>().passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: _onLoginButtonPressed,
                              child: Text('Login'),
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
                          context.read<LoginBloc>().anonymousLogin();
                        },
                        child: const Center(
                          child: Text(
                            'Accesso Anonimo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      launchUrl('https://wom.social/authentication/signup'),
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
    print('_onLoginButtonPressed');
    final password = context.read<LoginBloc>().passwordController.text;
    if (password.length > 5) {
      FocusScope.of(context).requestFocus(FocusNode());
      context.read<LoginBloc>().login(LoginButtonPressed(
            username: context.read<LoginBloc>().usernameController.text.trim(),
            password: password,
          ));
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }
}
