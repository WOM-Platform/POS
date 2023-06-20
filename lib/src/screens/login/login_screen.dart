import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/signup/ui/screens/sign_up.dart';


final loginLoadingProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: LoadingOverlay(
        isLoading: ref.watch(loginLoadingProvider),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(child: LoginBox()),
        ),
      ),
    );
  }
}


class LoginBox extends StatefulHookConsumerWidget {
  const LoginBox({
    Key? key,
  }) : super(key: key);

  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends ConsumerState<LoginBox> {
  FocusNode _focusNode = FocusNode();

  bool obscureText = true;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginFailure?>(
      loginErrorProvider,
          (LoginFailure? previous, LoginFailure? next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );

    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Center(
      child: ListView(
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
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const Spacer(),
                      TextField(
                        obscureText: obscureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              icon: Icon(obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              }),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => _onLoginButtonPressed(
                            usernameController.text.trim(),
                            passwordController.text.trim()),
                        child: Text(
                            'signIn'.tr()),
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
                  onTap: () async {
                    try {
                      ref.read(loginLoadingProvider.notifier).state = true;
                      await ref
                          .read(authNotifierProvider.notifier)
                          .anonymousLogin();
                      ref.read(loginLoadingProvider.notifier).state = false;
                    } catch (ex) {
                      logger.e(ex);
                      ref.read(loginLoadingProvider.notifier).state = false;
                    }
                  },
                  child: Center(
                    child: Text('anonymousAccess'.tr(),
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
            onTap: () {
              context.go('/${SignUpScreen.path}');
            },
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'areYouNotRegistered'.tr(),
                children: [
                  TextSpan(
                    text: 'tapHere'.tr(),
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
  }

  _onLoginButtonPressed(String email, String password) async {
    print('_onLoginButtonPressed');
    if (password.length > 5) {
      try {
        FocusScope.of(context).requestFocus(FocusNode());
        ref.read(loginLoadingProvider.notifier).state = true;
        await ref.read(authNotifierProvider.notifier).login(
          email,
          password,
        );
        ref.read(loginLoadingProvider.notifier).state = false;
      } catch (ex) {
        logger.e(ex);
        ref.read(loginLoadingProvider.notifier).state = false;
      }
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }
}
